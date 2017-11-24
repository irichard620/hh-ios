//
//  UserHomeTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 11/23/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "UserHomeTableViewCell.h"

@implementation UserHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title andImage:(UIImage *)image {
    self.iconLabel.text = title;
    self.iconImage.image = image;
}

@end
