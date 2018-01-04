//
//  ChatActionTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 11/24/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "ChatActionTableViewCell.h"

@implementation ChatActionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.containerView.layer.cornerRadius = 13;
//    self.containerView.layer.borderWidth = 1;
//    self.containerView.layer.borderColor = [[UIColor colorWithRed:0.239 green:0.310 blue:0.361 alpha:1]CGColor];
    self.containerView.clipsToBounds = YES;
}

- (void)setHouseAction:(NSString *)action {
    self.actionImage.image = [UIImage imageNamed:@"home.png"];
    self.actionLabel.text = action;
}

- (void)setPaymentAction:(NSString *)action {
    self.actionImage.image = [UIImage imageNamed:@"tag.png"];
    self.actionLabel.text = action;
}

- (void)setTodoAction:(NSString *)action {
    self.actionImage.image = [UIImage imageNamed:@"check.png"];
    self.actionLabel.text = action;
}

@end
