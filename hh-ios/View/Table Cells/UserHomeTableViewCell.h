//
//  UserHomeTableViewCell.h
//  hh-ios
//
//  Created by Ian Richard on 11/23/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;

- (void)setNoImageCellWithText:(NSString *)title;
- (void)setTitle:(NSString *)title andImage:(UIImage *)image shouldCurve:(BOOL)shouldCurve;

@end
