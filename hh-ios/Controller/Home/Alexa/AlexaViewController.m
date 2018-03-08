//
//  AlexaViewController.m
//  hh-ios
//
//  Created by Ian Richard on 1/7/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "AlexaViewController.h"
#import "SWRevealViewController.h"
#import "ViewHelpers.h"

@interface AlexaViewController ()

@end

@implementation AlexaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0];
    self.navigationItem.title = @"Connect to Alexa";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // Add gesture recognizer for reveal controller
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    // Create menu button
    self.navigationItem.leftBarButtonItem = [ViewHelpers createNavButtonWithTarget:self.revealViewController andSelectorName:@"revealToggle:" andImage:[UIImage imageNamed:@"menu.png"] isBack:NO];
    
    [ViewHelpers roundCorners:self.setupButton];
}

@end
