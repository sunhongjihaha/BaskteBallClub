//
//  MusicModel.m
//  Music
//
//  Created by 孙鸿吉 on 15/12/7.
//  Copyright © 2015年 孙鸿吉. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.numberID = (NSInteger)value;
    }
}
- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"duration"]) {
        //总秒数
        NSInteger sumSeconds = [value integerValue] / 1000;
        //取余获取描述  取整获得分钟数
        self.duration = [NSString stringWithFormat:@"%ld:%ld",sumSeconds/60,sumSeconds&60];
    }
}
@end
