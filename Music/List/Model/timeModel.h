//
//  timeModel.h
//  Music
//
//  Created by 孙鸿吉 on 15/12/9.
//  Copyright © 2015年 孙鸿吉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface timeModel : NSObject
//时间
@property (nonatomic,assign)NSInteger time;
///歌词
@property (nonatomic,strong)NSString *lyric;
//自定义初始化方法
- (instancetype)initWithTime:(NSInteger)time lyric:(NSString *)lyric;
@end
