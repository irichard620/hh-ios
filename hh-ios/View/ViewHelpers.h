//
//  ViewHelpers.h
//  hh-ios
//
//  Created by Ian Richard on 11/14/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface ViewHelpers : NSObject

+ (void)createNavTitleLabelWithText:(NSString *)text andNavItem:(UINavigationItem *)navigationItem;
+ (UITapGestureRecognizer *)createTapGestureRecognizerWithTarget:(UIViewController *)target andSelectorName:(NSString *)selectorString;
+ (void)roundCorners:(UIView *)view;
+ (UIBarButtonItem *)createBackButtonWithTarget:(UIViewController *)target andSelectorName:(NSString *)selectorString;
+ (UIBarButtonItem *)createMenuButtonWithTarget:(SWRevealViewController *)target;

@end
