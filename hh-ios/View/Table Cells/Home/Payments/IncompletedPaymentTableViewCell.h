//
//  IncompletedPaymentTableViewCell.h
//  hh-ios
//
//  Created by Ian Richard on 12/28/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncompletedPaymentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *denyButton;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

- (void)setName:(NSString *)name andMessage:(NSString *)message andProfileImage:(UIImage *)image andTime:(NSString *)time andAmount:(float)amount;

@end
