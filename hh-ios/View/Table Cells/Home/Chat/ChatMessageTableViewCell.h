//
//  ChatMessageTableViewCell.h
//  hh-ios
//
//  Created by Ian Richard on 11/24/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *senderName;
@property (weak, nonatomic) IBOutlet UILabel *senderMessage;
@property (weak, nonatomic) IBOutlet UIView *markerView;

- (void)setName:(NSString *)name andMessage:(NSString *)message andAvatarLink:(NSString *)avatarLink showMarker:(BOOL)showMarker;
@end
