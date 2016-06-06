//
//  MusicDataManger.m
//  Music
//
//  Created by 孙鸿吉 on 15/12/7.
//  Copyright © 2015年 孙鸿吉. All rights reserved.
//

#import "MusicDataManger.h"
#import "MusicModel.h"
#import "timeModel.h"
@interface MusicDataManger()
{
    MusicModel *_currentModel;
}
@end
static MusicDataManger *dataManger = nil;
@implementation MusicDataManger
+ (MusicDataManger *)shareDataManger
{
    return [[self alloc]init];
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (dataManger == nil) {
            dataManger = [super allocWithZone:zone];
        }        
    });
    return dataManger;
}

///网络请求
- (void)getDataFromNetWorkWithBlock:(NETWORKBLOCK)finishBlock
{
    NSString *urlStr = @"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist";
    //创建全局队列  只要再里面加任务  就会去子线程里面执行
    NSURL *url = [NSURL URLWithString:urlStr];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue,^{
        @autoreleasepool {//使用多线程 在子线程里面 一定要自己写autoreleasepoor 否则会造成内存泄露
            NSArray *array = [NSArray arrayWithContentsOfURL:url];
            NSMutableArray *tempMutableArray = [NSMutableArray array];
            for (NSDictionary *dict in array) {
                MusicModel *model = [[MusicModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [tempMutableArray addObject:model];
            }
            self.dataArray = [NSArray arrayWithArray:tempMutableArray];
            dispatch_async(dispatch_get_main_queue(),^{
                if (self.dataArray.count > 0) {
                    finishBlock(YES);
                }else{
                    finishBlock(NO);
                }
            });
        }
        
    });

}
//获取当前应该播放的歌曲
- (MusicModel *)currentPlayMusic
{
    return _currentModel;
}
//设置当前播放歌曲
- (void)setCurrentMusicWithModel:(MusicModel *)model;
{
    //如果设置的音乐存在列表中 就赋值
    if ([self.dataArray containsObject:model]) {
        _currentModel = model;
    }
}
//获取上一首歌曲的model
- (MusicModel *)getPreviousMusic
{
    NSInteger index = [self.dataArray indexOfObject:_currentModel];
    if (index == 0) {
        _currentModel = self.dataArray.lastObject;
        return [self.dataArray lastObject];
        
    }
    index = index - 1;
    _currentModel = self.dataArray[index];
    return self.dataArray[index];
}
//获取下一首歌曲的model
- (MusicModel *)getNextMusic
{
    NSInteger index = [self.dataArray indexOfObject:_currentModel];
    if (index == (self.dataArray.count - 1)) {
        _currentModel = self.dataArray.firstObject;
        return [self.dataArray firstObject];
    }
    index = index + 1;
    _currentModel = self.dataArray[index];
    return self.dataArray[index];
}
//获取当前播放歌曲的歌词
- (NSArray *)getCurrentLyric
{
    //获取歌词
    NSString *lyricString = _currentModel.lyric;
    NSArray *sumLyricArray = [lyricString componentsSeparatedByString:@"\n"];
    NSMutableArray *finalArray = [NSMutableArray array];
    //循环遍历所有歌词的数组
    for (int i = 0; i < sumLyricArray.count - 1; i++) {
        //获取每一列的歌词(时间+歌词)
        NSString *lineLyricString = sumLyricArray[i];
        if (![lineLyricString hasPrefix:@"["]) {
            timeModel *model = [[timeModel alloc]initWithTime:0 lyric:lineLyricString];
            [finalArray addObject:model];
            continue;
        }
        //分割每一列的歌词
        NSArray *subLineLyricArray = [lineLyricString componentsSeparatedByString:@"]"];
        //时间
        NSString *timeString = [subLineLyricArray[0] substringWithRange:NSMakeRange(1, 5)];
        //时间分割
        NSArray *timeArray = [timeString componentsSeparatedByString:@":"];
        //获取秒数
        NSInteger time = [timeArray[0]integerValue]*60 + [timeArray[1]integerValue];
        //歌词
        NSString *lyricString = subLineLyricArray[1];
        
        if (lyricString.length < 1) {
            continue;
        }
        timeModel *model = [[timeModel alloc]initWithTime:time lyric:lyricString];
        [finalArray addObject:model];
    }
    return finalArray;
}
@end
