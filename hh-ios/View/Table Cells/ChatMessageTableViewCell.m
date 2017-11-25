//
//  ChatMessageTableViewCell.m
//  hh-ios
//
//  Created by Ian Richard on 11/24/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "ChatMessageTableViewCell.h"

@implementation ChatMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.profileImage.layer.cornerRadius = 14.0;
    self.profileImage.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setName:(NSString *)name andMessage:(NSString *)message andProfileImage:(UIImage *)image showMarker:(BOOL)showMarker {
    self.senderName.text = name;
    self.senderMessage.text = message;
    self.profileImage.image = image;
    self.markerView.hidden = !showMarker;
}

@end
