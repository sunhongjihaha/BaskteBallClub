//
//  timeModel.m
//  Music
//
//  Created by 孙鸿吉 on 15/12/9.
//  Copyright © 2015年 孙鸿吉. All rights reserved.
//

#import "timeModel.h"

@implementation timeModel
//自定义初始化方法
- (instancetype)initWithTime:(NSInteger)time lyric:(NSString *)lyric
{
    self = [super init];
    if (self) {
        _time = time;
        _lyric = lyric;
    }
    return self;
}
@end
