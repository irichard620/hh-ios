//
//  ChatTimeTableViewCell.h
//  hh-ios
//
//  Created by Ian Richard on 11/24/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTimeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setTime:(NSString *)time;

@end
