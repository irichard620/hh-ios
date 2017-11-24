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

@end
