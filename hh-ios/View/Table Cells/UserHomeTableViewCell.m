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

- (void)setNoImageCellWithText:(NSString *)title {
    self.iconImage.hidden = YES;
    self.iconLabel.text = title;
}

- (void)setTitle:(NSString *)title andImage:(UIImage *)image shouldCurve:(BOOL)shouldCurve {
    self.iconImage.hidden = NO;
    self.iconLabel.text = title;
    self.iconImage.image = image;
    if (shouldCurve) {
        self.iconImage.layer.cornerRadius = 6.0;
        self.iconImage.clipsToBounds = YES;
    }
}

@end
