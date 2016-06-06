//
//  ListViewController.m
//  Music
//
//  Created by 孙鸿吉 on 15/12/7.
//  Copyright © 2015年 孙鸿吉. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "MusicDataManger.h"
#import "MusicModel.h"
#import "PlayViewController.h"
#import "MBProgressHUD.h"
@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic,strong)PlayViewController *playVC;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataFromNetWork];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [MusicDataManger shareDataManger].dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableViewCell" forIndexPath:indexPath];
    MusicModel *model = [MusicDataManger shareDataManger].dataArray[indexPath.row];
    [cell setCellDataWithMusicModel:model];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取storyboard上面的控制器
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.playVC = [board instantiateViewControllerWithIdentifier:@"PlayViewController"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //设置当前播放歌曲
    [[MusicDataManger shareDataManger] setCurrentMusicWithModel:[MusicDataManger shareDataManger].dataArray[indexPath.row]];
    self.view.x = 200;
    
    
    [self.playVC showViewAndPlayMusic];
    
}

- (void)getDataFromNetWork
{
    //转圈
    [MBProgressHUD showHUDAddedTo:self.mainTableView animated:YES];
    
    
    
    MusicDataManger *manger = [MusicDataManger shareDataManger];
    [manger getDataFromNetWorkWithBlock:^(BOOL isFinished) {
        [MBProgressHUD hideHUDForView:self.mainTableView animated:YES];
        if (isFinished) {
            [self.mainTableView reloadData];
        }else{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"网络请求失败,是否重新加载" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self getDataFromNetWork];
            }];
            UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:alertAction1];
            [alertVC addAction:alertAction2];
            //弹框-利用模态方法
            [self presentViewController:alertVC animated:YES completion:^{
                
            }];
        }
    }];

}




















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
