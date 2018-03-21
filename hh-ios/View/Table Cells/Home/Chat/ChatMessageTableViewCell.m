//
//  ChatMessageTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 11/24/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "ChatMessageTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ChatMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.profileImage.layer.cornerRadius = 14.0;
    self.profileImage.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setName:(NSString *)name andMessage:(NSString *)message andAvatarLink:(NSString *)avatarLink showMarker:(BOOL)showMarker {
    self.senderName.text = name;
    self.senderMessage.text = message;
    if (avatarLink == nil) {
        [self.profileImage setImage:[UIImage imageNamed:@"user-icon-grey.png"]];
    } else {
        [self.profileImage sd_setImageWithURL:[NSURL URLWithString:avatarLink] placeholderImage:[UIImage imageNamed:@"user-icon-grey.png"]];
    }
    self.markerView.hidden = !showMarker;
}

@end
