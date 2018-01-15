//
//  IncompleteToDoTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 1/11/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "IncompleteToDoTableViewCell.h"

@implementation IncompleteToDoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.profileImage.layer.cornerRadius = 14.0;
    self.profileImage.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Borders
    self.rightButton.layer.cornerRadius = 6;
    self.rightButton.layer.cornerRadius = 6;
    self.rightButton.clipsToBounds = YES;
    self.leftButton.clipsToBounds = YES;
    self.leftButton.layer.borderWidth = 1;
    self.leftButton.layer.borderColor = [[UIColor colorWithRed:0.239 green:0.310 blue:0.361 alpha:1]CGColor];
}

- (void)setName:(NSString *)name andMessage:(NSString *)message andImage:(UIImage *)image andTime:(NSString *)time andIsCreatedByMe:(BOOL)createdByMe andIsAssignedToMe:(BOOL)isAssignedToMe {
    self.profileImage.image = image;
    self.nameLabel.text = [NSString stringWithFormat:@"Assigned to %@", name];
    self.messageLabel.text = message;
    self.timeLabel.text = time;
    if (createdByMe) {
        [self.leftButton setTitle:@"Edit" forState:UIControlStateNormal];
    } else {
        if (isAssignedToMe) {
            [self.leftButton setTitle:@"Re-assign" forState:UIControlStateNormal];
        } else {
            [self.leftButton setTitle:@"Assign to me" forState:UIControlStateNormal];
        }
    }
}

@end
