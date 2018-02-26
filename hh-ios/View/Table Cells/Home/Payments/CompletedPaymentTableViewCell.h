//
//  CompletedPaymentTableViewCell.h
//  hh-ios
//
//  Created by Ian Richard on 1/6/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletedPaymentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (void)setName:(NSString *)name andMessage:(NSString *)message andProfileImage:(UIImage *)image andTime:(NSString *)time andAmount:(float)amount andIsNegative:(BOOL)isNegative;

@end
