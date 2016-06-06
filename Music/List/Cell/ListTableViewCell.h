//
//  ListTableViewCell.h
//  Music
//
//  Created by 孙鸿吉 on 15/12/7.
//  Copyright © 2015年 孙鸿吉. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;
@interface ListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *musicImageView;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicSingleLabel;
//cell的赋值方法
- (void)setCellDataWithMusicModel:(MusicModel *)musicModel;
@end
