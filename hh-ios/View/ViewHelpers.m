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

+ (UIBarButtonItem *)createBackButtonWithTarget:(UIViewController *)target andSelectorName:(NSString *)selectorString {
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    backButton.userInteractionEnabled = YES;
    [backButton setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];
    [backButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [backButton addConstraint:[NSLayoutConstraint constraintWithItem:backButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30]];
    [backButton addConstraint:[NSLayoutConstraint constraintWithItem:backButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30]];
    
    // Add action
    SEL selector = NSSelectorFromString(selectorString);
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    // Add to bar button item
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    return backBarButton;
}

+ (UIBarButtonItem *)createMenuButtonWithTarget:(SWRevealViewController *)target {
    UIImage* menuImage = [UIImage imageNamed:@"menu.png"];
    UIButton *menuButton = [[UIButton alloc] init];
    [menuButton setBackgroundImage:menuImage forState:UIControlStateNormal];
    NSDictionary *views = @{@"menuButton":menuButton};
    [menuButton setFrame:CGRectMake(15,5, 25,25)];
    NSArray *heightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[menuButton(25)]" options:0 metrics:nil views:views];
    NSArray *widthConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[menuButton(25)]" options:0 metrics:nil views:views];
    [menuButton addConstraints:heightConstraint];
    [menuButton addConstraints:widthConstraint];
    [menuButton addTarget:target action:@selector(revealToggle:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButton =[[UIBarButtonItem alloc] initWithCustomView:menuButton];
    return menuBarButton;
}

+ (UIBarButtonItem *)createRightButtonWithTarget:(UIViewController *)target andSelectorName:(NSString *)selectorString {
    UIImage* buttonImage = [UIImage imageNamed:@"add_white.png"];
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    NSDictionary *views = @{@"button":button};
    [button setFrame:CGRectMake(15,5, 25,25)];
    NSArray *heightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(25)]" options:0 metrics:nil views:views];
    NSArray *widthConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(25)]" options:0 metrics:nil views:views];
    [button addConstraints:heightConstraint];
    [button addConstraints:widthConstraint];
    SEL selector = NSSelectorFromString(selectorString);
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    return menuBarButton;
}

+ (UIAlertController *)createErrorAlertWithTitle:(NSString *)title andDescription:(NSString *)description {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:description preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    return alert;
}

@end
