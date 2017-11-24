//
//  MenuTableViewCell.h
//  hh-ios
//
//  Created by Ian Richard on 11/13/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;

- (void)setTitle:(NSString *)title andImage:(UIImage *)image changeColor:(BOOL)shouldChangeColor;

@end
