//
//  MenuTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 11/13/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title andImage:(UIImage *)image changeColor:(BOOL)shouldChangeColor{
    self.iconLabel.text = title;
    self.iconImage.image = image;
    if (shouldChangeColor) {
        self.iconLabel.textColor = [UIColor blackColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
