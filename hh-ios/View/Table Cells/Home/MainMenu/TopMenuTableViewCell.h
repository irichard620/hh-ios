//
//  TopMenuTableViewCell.h
//  hh-ios
//
//  Created by Ian Richard on 11/13/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopMenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellSubtitle;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;

- (void)setTitle:(NSString *)title andSubtitle:(NSString *)subTitle andAvatarLink:(NSString *)avatarLink;

@end
