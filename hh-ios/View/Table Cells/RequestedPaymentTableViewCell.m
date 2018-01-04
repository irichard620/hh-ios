//
//  RequestedPaymentTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 12/28/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "RequestedPaymentTableViewCell.h"

@implementation RequestedPaymentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.profileImage.layer.cornerRadius = 14.0;
    self.profileImage.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Borders
    self.remindButton.layer.cornerRadius = 6;
    self.cancelButton.layer.cornerRadius = 6;
    self.remindButton.clipsToBounds = YES;
    self.cancelButton.clipsToBounds = YES;
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [[UIColor colorWithRed:0.239 green:0.310 blue:0.361 alpha:1]CGColor];
}

- (void)setName:(NSString *)name andMessage:(NSString *)message andProfileImage:(UIImage *)image andTime:(NSString *)time andAmount:(NSString *)amount {
    self.nameLabel.text = [NSString stringWithFormat:@"Request to %@", name];
    self.messageLabel.text = message;
    self.profileImage.image = image;
    self.timeLabel.text = time;
    self.moneyLabel.text = amount;
}

@end
