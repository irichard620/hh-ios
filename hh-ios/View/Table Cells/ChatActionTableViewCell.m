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
}

- (void)setHouseAction:(NSString *)action {
    self.actionImage.image = [UIImage imageNamed:@"home_black.png"];
    self.actionLabel.text = action;
}

- (void)setPaymentAction:(NSString *)action {
    self.actionImage.image = [UIImage imageNamed:@"tag_black.png"];
    self.actionLabel.text = action;
}

- (void)setTodoAction:(NSString *)action {
    self.actionImage.image = [UIImage imageNamed:@"check_black.png"];
    self.actionLabel.text = action;
}

@end
