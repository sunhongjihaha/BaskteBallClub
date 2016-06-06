//
//  LyricTableViewCell.m
//  Music
//
//  Created by 孙鸿吉 on 15/12/9.
//  Copyright © 2015年 孙鸿吉. All rights reserved.
//

#import "LyricTableViewCell.h"

@implementation LyricTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self allViews];
    }
    return self;
}
- (void)allViews
{

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
