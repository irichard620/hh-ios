//
//  CompletedToDoTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 1/11/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "CompletedToDoTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CompletedToDoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.profileImage.layer.cornerRadius = 14.0;
    self.profileImage.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setName:(NSString *)name andMessage:(NSString *)message andAvatarLink:(NSString *)avatarLink andTime:(NSString *)time andTimeTaken:(int)minutes {
    self.nameLabel.text = [NSString stringWithFormat:@"%@ Completed To-Do", name];
    self.messageLabel.text = message;
    if (avatarLink == nil) {
        [self.profileImage setImage:[UIImage imageNamed:@"user-icon-grey.png"]];
    } else {
        [self.profileImage sd_setImageWithURL:[NSURL URLWithString:avatarLink] placeholderImage:[UIImage imageNamed:@"user-icon-grey.png"]];
    }
    self.timeLabel.text = time;
    self.timeToCompleteLabel.text = [NSString stringWithFormat:@"Took %imin", minutes];
}

@end
