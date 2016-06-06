//
//  ListTableViewCell.m
//  Music
//
//  Created by 孙鸿吉 on 15/12/7.
//  Copyright © 2015年 孙鸿吉. All rights reserved.
//

#import "ListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MusicModel.h"
@implementation ListTableViewCell
- (void)setCellDataWithMusicModel:(MusicModel *)musicModel
{
    [self.musicImageView sd_setImageWithURL:[NSURL URLWithString:musicModel.picUrl]placeholderImage:[UIImage imageNamed:@"loading_1@2x"]];
    self.musicNameLabel.text = musicModel.name;
    self.musicSingleLabel.text = musicModel.singer;
}
- (void)awakeFromNib {
    self.musicImageView.layer.cornerRadius = 50;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
