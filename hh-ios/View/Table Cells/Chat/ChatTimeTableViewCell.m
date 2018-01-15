//
//  ChatTimeTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 11/24/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "ChatTimeTableViewCell.h"

@implementation ChatTimeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setTime:(NSString *)time {
    self.timeLabel.text = time;
}

@end
