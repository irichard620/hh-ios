//
//  ChatViewController.m
//  hh-ios
//
//  Created by Ian Richard on 11/13/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "ChatViewController.h"
#import "SWRevealViewController.h"
#import "ViewHelpers.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set bar color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0];
    
    // Add gesture recognizer for reveal controller
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    // Create menu button
    UIImage* menuImage = [UIImage imageNamed:@"menu.png"];
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(15,5, 25,25)];
    [menuButton setBackgroundImage:menuImage forState:UIControlStateNormal];
    [menuButton addTarget:self.revealViewController action:@selector(revealToggle:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButton =[[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem =menuBarButton;
    
    // Titlel abel
    [ViewHelpers createNavTitleLabelWithText:@"Home" andNavItem:self.navigationItem];
    
}


@end
