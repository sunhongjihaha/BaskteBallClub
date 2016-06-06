//
//  MusicTool.m
//  Music
//
//  Created by 孙鸿吉 on 15/12/8.
//  Copyright © 2015年 孙鸿吉. All rights reserved.
//

#import "MusicTool.h"
@interface MusicTool()
@property (nonatomic,strong)AVPlayer *player;
//用来存放播放音乐的item
@property (nonatomic,strong)NSMutableDictionary *dict;
@end
static MusicTool *tool = nil;
@implementation MusicTool

+ (instancetype)sharedTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (tool == nil) {
            tool = [[MusicTool alloc]init];
            tool.dict = [NSMutableDictionary dictionary];
        }
    });
    return tool;
}
//音乐的播放
+ (AVPlayer *)playMusicWithUrlString:(NSString *)urlString
{
    AVPlayerItem *item = [MusicTool sharedTool].dict[urlString];
    if (item == nil) {
        //播放每首歌曲使用的item 根据URL去播放
        item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:urlString]];
        //把item存到字典里面
        [[MusicTool sharedTool].dict setObject:item forKey:urlString];
    }
    [[MusicTool sharedTool].player replaceCurrentItemWithPlayerItem:item];
        //开始播放
    [[MusicTool sharedTool].player play];
    return [MusicTool sharedTool].player;
}
//音乐的暂停
+ (AVPlayer *)stopMusicWithUrlString:(NSString *)urlString
{
    [[MusicTool sharedTool].player pause];
    
    return [MusicTool sharedTool].player;
}
#pragma mark - 懒加载
- (AVPlayer *)player
{
    if (_player == nil) {
        _player = [[AVPlayer alloc]init];
    }
    return _player;
}
//移除当前播放的item
+ (void)removeCurrentItem:(NSString *)urlString
{
    [[MusicTool sharedTool].dict removeObjectForKey:urlString];
}
@end
