//
//  CompletedPaymentTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 1/6/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "CompletedPaymentTableViewCell.h"

@implementation CompletedPaymentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.profileImage.layer.cornerRadius = 14.0;
    self.profileImage.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setName:(NSString *)name andMessage:(NSString *)message andProfileImage:(UIImage *)image andTime:(NSString *)time andAmount:(float)amount andIsNegative:(BOOL)isNegative {
    self.messageLabel.text = message;
    self.profileImage.image = image;
    self.timeLabel.text = time;
    
    if (isNegative) {
        self.nameLabel.text = [NSString stringWithFormat:@"Payment to %@", name];
        self.amountLabel.text = [NSString stringWithFormat:@"-$%.02f", amount];
        self.amountLabel.textColor = [UIColor redColor];
    } else {
        self.nameLabel.text = [NSString stringWithFormat:@"Payment from %@", name];
        self.amountLabel.text = [NSString stringWithFormat:@"+$%.02f", amount];
        self.amountLabel.textColor = [UIColor greenColor];
    }
}

@end
