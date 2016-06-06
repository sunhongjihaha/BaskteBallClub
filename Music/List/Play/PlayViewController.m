//
//  PlayViewController.m
//  Music
//
//  Created by 孙鸿吉 on 15/12/8.
//  Copyright © 2015年 孙鸿吉. All rights reserved.
//

#import "PlayViewController.h"
#import "MusicTool.h"
#import "MusicModel.h"
#import "MusicDataManger.h"
#import "UIImageView+WebCache.h"
#import "LyricTableViewCell.h"
#import "timeModel.h"
#import "AMBlurView.h"
typedef enum:NSUInteger{
    playingStatus = 100,
    stopingStatus,
    nonStatus,
}musicStatus;

@interface PlayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *playButton;//播放按钮
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;//时间条
@property (weak, nonatomic) IBOutlet UILabel *musicTime;//总时长
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;//背景图片
@property (weak, nonatomic) IBOutlet UITableView *lyricTableView;
@property (nonatomic,strong)NSArray *lyricArray;//保存歌词
@property (nonatomic,strong)NSTimer *timer;//定时器
@property (nonatomic,strong)AVPlayer *avPlayer;//定义AVplayer 接收当前正在播放的player
@property (nonatomic,assign)NSInteger currentIndex;//记录当前播放歌曲的下标
@property (weak, nonatomic) IBOutlet UIImageView *roolImageView;
@end

@implementation PlayViewController
//注册通知 移除通知
- (void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.lyricTableView.delegate = self;
    self.lyricTableView.dataSource = self;
    self.roolImageView.layer.cornerRadius = 20;
    self.roolImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.roolImageView.layer.borderWidth = 2;
    //注册音乐播放完毕的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicDidPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}
#pragma mark - 通知方法实现
- (void)musicDidPlayEnd:(NSNotification *)sender
{
    [self nextBtnDidClicked:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lyricArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyricTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"LyricTableViewCell" forIndexPath:indexPath];
    timeModel *model = self.lyricArray[indexPath.row];
    cell.lyricLabel.text = model.lyric;
    if (indexPath.row == self.currentIndex) {
        cell.lyricLabel.textColor = [UIColor yellowColor];
    }else{
        cell.lyricLabel.textColor = [UIColor whiteColor];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(void)dealloc
{
    //ARC里面不能写super dealloc
    //移除所有通知
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //移除指定某个通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
#pragma mark - 弹出界面并且播放音乐
- (void)showViewAndPlayMusic
{
    //1.把控制器的view添加到window上面
    UILabel *label = [[UILabel alloc]init];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;//获取当前使用的window
    //打电话
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://18698606882"]];
    //发短信
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://测试"]];
    [window addSubview:self.view];
    //2.让view处于window屏幕的最下方
    self.view.x = 0 - window.width;
    //3.通过动画让view处于屏幕上方
    window.userInteractionEnabled = NO;//先将交互功能关闭  在动画的block方法里面实现开启交互功能
    [UIView animateWithDuration:1.0 animations:^{
        self.view.x = - 200;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
        //重置歌曲
        [self resetMusicInfo];
    }];
}
//退出
- (IBAction)quitBtnDidClicked:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:1 animations:^{
        self.view.x = 0 - [UIScreen mainScreen].bounds.size.width;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
}
//上一曲
- (IBAction)preBtnAction:(id)sender {
    //先暂停当前播放的歌曲
    [self stopMusic];
    //获取上一首歌曲的model
    MusicModel *model = [[MusicDataManger shareDataManger]getPreviousMusic];
    //设置当前播放的model
    [[MusicDataManger shareDataManger]setCurrentMusicWithModel:model];
    //重置信息
    [self resetMusicInfo];
    
    
}
//播放
- (IBAction)playBtnDidClicked:(id)sender {
    MusicModel *model = [[MusicDataManger shareDataManger]currentPlayMusic];
    if (self.playButton.tag == playingStatus) {
        self.playButton.tag = stopingStatus;
        //修改button图片
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"player_btn_play_normal@2x"] forState:UIControlStateNormal];
        //暂停音乐
        [MusicTool stopMusicWithUrlString:model.mp3Url];
        self.timer.fireDate = [NSDate distantFuture];
        
    }else{
        self.playButton.tag = playingStatus;
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"player_btn_pause_normal@2x"] forState:UIControlStateNormal];
        //播放音乐
        [MusicTool playMusicWithUrlString:model.mp3Url];
        self.timer.fireDate = [NSDate distantPast];
    }
}
//下一曲
- (IBAction)nextBtnDidClicked:(id)sender {
    //先暂停播放的歌曲
    [self stopMusic];
    //获取下一首歌曲的model
    MusicModel *model = [[MusicDataManger shareDataManger]getNextMusic];
    //设置当前播放的model
    [[MusicDataManger shareDataManger]setCurrentMusicWithModel:model];
    //重置信息
    [self resetMusicInfo];
}
//暂停音乐
- (void)stopMusic
{
    MusicModel *model = [[MusicDataManger shareDataManger]currentPlayMusic];
    [MusicTool stopMusicWithUrlString:model.mp3Url];
    
    [MusicTool removeCurrentItem:model.mp3Url];
}

#pragma mark - 重置歌曲信息
- (void)resetMusicInfo
{
    MusicModel *model = [[MusicDataManger shareDataManger]currentPlayMusic];
    self.avPlayer = [MusicTool playMusicWithUrlString:model.mp3Url];
    self.playButton.tag = playingStatus;
    //设置播放界面的背景图片
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"musicbackGround@2x"]];
    [self.roolImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"musicbackGround@2x"]];
    //设置显示总时长
    self.musicTime.text = model.duration;
    self.lyricArray = [[MusicDataManger shareDataManger]getCurrentLyric];
    //刷新(必须刷新 因为不刷新会崩溃  获取到新的歌词信息  刷新才能显示)
    [self.lyricTableView reloadData];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //初始化定时器
        //时间不能小于0.1  小于0.1 系统默认为0.1
        self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateMusicProgress) userInfo:nil repeats:YES];
        //把timer加入到运行时
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        //主线程的runloop默认是开启的 所以主线程永远不会结束.(除非退出程序)
        //子线程的runloop默认是关闭的 所以只要子线程的任务完成之后 子线程就会销毁
    });
    self.timer.fireDate = [NSDate distantPast];
    
}
#pragma mark - 更新进度方法
- (void)updateMusicProgress
{
    //当前时间
    NSInteger current = (self.avPlayer.currentTime.value / self.avPlayer.currentTime.timescale);
    for (int i = 0; i < self.lyricArray.count; i++) {
        timeModel *model = self.lyricArray[i];
        if (current == model.time) {
            self.currentIndex = i;
            break;
        }
    }
    //让tableview滑动到这一行
    [self.lyricTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self.lyricTableView reloadData];
    MusicModel *model = [[MusicDataManger shareDataManger]currentPlayMusic];
    NSArray *timeArray = [model.duration componentsSeparatedByString:@":"];
    NSInteger sum = [timeArray[0]integerValue]*60 + [timeArray[1]integerValue];
    self.progressView.progress = current / (sum * 1.0f);
    if (self.playButton.tag == playingStatus) {
        self.roolImageView.transform = CGAffineTransformRotate(self.roolImageView.transform, M_PI_2/3);
    }
    
}




















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
