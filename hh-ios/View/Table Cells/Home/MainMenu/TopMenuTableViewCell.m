//
//  TopMenuTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 11/13/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "TopMenuTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation TopMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.cellTitle.textColor = [UIColor whiteColor];
    self.cellTitle.font = [self boldFontWithFont:self.cellTitle.font];
//    self.cellSubtitle.textColor = [UIColor whiteColor];
//    self.backgroundColor = [UIColor colorWithRed:0.24 green:0.31 blue:0.36 alpha:1.0];
    
    // Round image
    self.cellImage.layer.cornerRadius = 16.0;
    self.cellImage.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setTitle:(NSString *)title andSubtitle:(NSString *)subTitle andAvatarLink:(NSString *)avatarLink {
    self.cellTitle.text = title;
    self.cellSubtitle.text = subTitle;
    if (avatarLink == nil) {
        [self.cellImage setImage:[UIImage imageNamed:@"group-icon-white-background.png"]];
    } else {
        [self.cellImage sd_setImageWithURL:[NSURL URLWithString:avatarLink] placeholderImage:[UIImage imageNamed:@"group-icon-white-background.png"]];
    }
}

- (UIFont *)boldFontWithFont:(UIFont *)font {
    UIFontDescriptor * fontD = [font.fontDescriptor
                                fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    return [UIFont fontWithDescriptor:fontD size:0];
}

@end
