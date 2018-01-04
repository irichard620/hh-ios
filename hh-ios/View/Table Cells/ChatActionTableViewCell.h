//
//  ChatActionTableViewCell.h
//  hh-ios
//
//  Created by Ian Richard on 11/24/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatActionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *actionImage;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (void)setHouseAction:(NSString *)action;
- (void)setPaymentAction:(NSString *)action;
- (void)setTodoAction:(NSString *)action;

@end
