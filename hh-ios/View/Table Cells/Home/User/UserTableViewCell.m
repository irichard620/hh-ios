//
//  UserTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 2/20/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.avatarImageView.layer.cornerRadius = 12.0;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)setNoImageCellWithText:(NSString *)title {
    self.imageView.hidden = YES;
    self.nameLabel.text = title;
}

- (void)setName:(NSString *)name andImage:(UIImage *)image {
    self.nameLabel.text = name;
    self.avatarImageView.image = image;
}

@end
