//
//  CompletedToDoTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 1/11/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "CompletedToDoTableViewCell.h"

@implementation CompletedToDoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.profileImage.layer.cornerRadius = 14.0;
    self.profileImage.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setName:(NSString *)name andMessage:(NSString *)message andProfileImage:(UIImage *)image andTime:(NSString *)time andTimeTaken:(int)minutes {
    self.nameLabel.text = [NSString stringWithFormat:@"%@ Completed To-Do", name];
    self.messageLabel.text = message;
    self.profileImage.image = image;
    self.timeLabel.text = time;
    self.timeToCompleteLabel.text = [NSString stringWithFormat:@"Took %imin", minutes];
}

@end
