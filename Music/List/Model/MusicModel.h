//
//  MusicModel.h
//  Music
//
//  Created by 孙鸿吉 on 15/12/7.
//  Copyright © 2015年 孙鸿吉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
///歌曲链接
@property (nonatomic,strong)NSString *mp3Url;
///ID
@property (nonatomic,assign)NSInteger numberID;
///歌曲的名字
@property (nonatomic,strong)NSString *name;
///图片
@property (nonatomic,strong)NSString *picUrl;
///演唱者
@property (nonatomic,strong)NSString *singer;
///歌词
@property (nonatomic,strong)NSString *lyric;
///时间
@property (nonatomic,copy)NSString *duration;

@end
