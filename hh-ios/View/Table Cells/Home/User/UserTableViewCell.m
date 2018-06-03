//
//  UserTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 2/20/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "UserTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setNoImageCellWithText:(NSString *)title {
    self.imageView.hidden = YES;
    self.nameLabel.text = title;
}

- (void)setName:(NSString *)name andAvatarLink:(NSString *)avatarLink {
    self.imageView.hidden = NO;
    self.nameLabel.text = name;
    if (avatarLink == nil) {
        [self.avatarImageView setImage:[UIImage imageNamed:@"user-icon-grey.png"]];
    } else {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarLink] placeholderImage:[UIImage imageNamed:@"user-icon-grey.png"]];
    }
    self.avatarImageView.layer.cornerRadius = 12.0;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)setTitle:(NSString *)title andImage:(UIImage *)image shouldCurve:(BOOL)shouldCurve {
    self.avatarImageView.hidden = NO;
    self.nameLabel.text = title;
    self.avatarImageView.image = image;
    if (shouldCurve) {
        self.avatarImageView.layer.cornerRadius = 6.0;
        self.avatarImageView.clipsToBounds = YES;
    }
}

@end
