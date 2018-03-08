//
//  ViewHelpers.m
//  hh-ios
//
//  Created by Ian Richard on 11/14/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "ViewHelpers.h"

@implementation ViewHelpers

+ (void)createNavTitleLabelWithText:(NSString *)text andNavItem:(UINavigationItem *)navigationItem {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.textColor = [UIColor whiteColor];
    navigationItem.titleView = label;
    label.text = text;
    [label sizeToFit];
}

+ (UITapGestureRecognizer *)createTapGestureRecognizerWithTarget:(UIViewController *)target andSelectorName:(NSString *)selectorString {
    SEL selector = NSSelectorFromString(selectorString);
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    return singleTapGestureRecognizer;
}

+ (void)roundCorners:(UIView *)view {
    view.layer.cornerRadius = 13;
    view.clipsToBounds = YES;
}

+ (UIBarButtonItem *)createNavButtonWithTarget:(UIViewController *)target andSelectorName:(NSString *)selectorString andImage:(UIImage *)image isBack:(BOOL)isBack {
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    NSDictionary *views = @{@"button":button};
    NSArray *heightConstraint;
    NSArray *widthConstraint;
    if (isBack) {
        [button setFrame:CGRectMake(0,0, 30,30)];
        heightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(30)]" options:0 metrics:nil views:views];
        widthConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(30)]" options:0 metrics:nil views:views];
    } else {
        [button setFrame:CGRectMake(15,5, 25,25)];
        heightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(25)]" options:0 metrics:nil views:views];
        widthConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(25)]" options:0 metrics:nil views:views];
    }
    [button addConstraints:heightConstraint];
    [button addConstraints:widthConstraint];
    SEL selector = NSSelectorFromString(selectorString);
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
}

+ (UIAlertController *)createErrorAlertWithTitle:(NSString *)title andDescription:(NSString *)description {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:description preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    return alert;
}

@end
