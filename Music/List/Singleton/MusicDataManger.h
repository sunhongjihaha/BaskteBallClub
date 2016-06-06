//
//  MusicDataManger.h
//  Music
//
//  Created by 孙鸿吉 on 15/12/7.
//  Copyright © 2015年 孙鸿吉. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MusicModel;
@class timeModel;
typedef void(^NETWORKBLOCK)(BOOL isFinished);

@interface MusicDataManger : NSObject
@property (nonatomic,strong)NSArray *dataArray;//存储Music数据
+ (MusicDataManger *)shareDataManger;
///网络请求
- (void)getDataFromNetWorkWithBlock:(NETWORKBLOCK)finishBlock;
//获取当前应该播放的歌曲
- (MusicModel *)currentPlayMusic;
//设置当前播放歌曲
- (void)setCurrentMusicWithModel:(MusicModel *)model;
//获取上一首歌曲的model
- (MusicModel *)getPreviousMusic;
//获取下一首歌曲的model
- (MusicModel *)getNextMusic;
//获取当前播放歌曲的歌词
- (NSArray *)getCurrentLyric;
@end
