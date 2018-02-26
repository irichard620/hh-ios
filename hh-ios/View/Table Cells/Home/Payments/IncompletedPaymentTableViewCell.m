//
//  IncompletedPaymentTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 12/28/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "IncompletedPaymentTableViewCell.h"

@implementation IncompletedPaymentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.profileImage.layer.cornerRadius = 14.0;
    self.profileImage.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Borders
    self.payButton.layer.cornerRadius = 6;
    self.denyButton.layer.cornerRadius = 6;
    self.payButton.clipsToBounds = YES;
    self.denyButton.clipsToBounds = YES;
    self.denyButton.layer.borderWidth = 1;
    self.denyButton.layer.borderColor = [[UIColor colorWithRed:0.239 green:0.310 blue:0.361 alpha:1]CGColor];
}

- (void)setName:(NSString *)name andMessage:(NSString *)message andProfileImage:(UIImage *)image andTime:(NSString *)time andAmount:(float)amount {
    self.nameLabel.text = [NSString stringWithFormat:@"%@ requests money", name];
    self.messageLabel.text = message;
    self.profileImage.image = image;
    self.timeLabel.text = time;
    self.moneyLabel.text = [NSString stringWithFormat:@"$%.02f", amount];
}

@end
