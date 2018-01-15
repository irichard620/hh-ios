//
//  IncompleteToDoTableViewCell.h
//  hh-ios
//
//  Created by Ian Richard on 1/11/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncompleteToDoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

- (void)setName:(NSString *)name andMessage:(NSString *)message andImage:(UIImage *)image andTime:(NSString *)time andIsCreatedByMe:(BOOL)createdByMe andIsAssignedToMe:(BOOL)isAssignedToMe;

@end
