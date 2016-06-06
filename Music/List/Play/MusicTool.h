//
//  MusicTool.h
//  Music
//
//  Created by 孙鸿吉 on 15/12/8.
//  Copyright © 2015年 孙鸿吉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface MusicTool : NSObject
//播放音乐的知识:播放音乐最常见的两种方式:AVPlayer 比较强大 可以播放多媒体(音频视频 支持在线直播)
//AVAudioPlayer支持播放本地音乐 优点:封装的好 用起来简单
//音乐的播放
+ (AVPlayer *)playMusicWithUrlString:(NSString *)urlString;
//音乐的暂停
+ (AVPlayer *)stopMusicWithUrlString:(NSString *)urlString;
//移除当前播放的item
+ (void)removeCurrentItem:(NSString *)urlString;
@end
