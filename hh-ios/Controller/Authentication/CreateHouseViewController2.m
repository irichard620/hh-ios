//
//  CreateHouseViewController2.m
//  hh-ios
//
//  Created by Ian Richard on 1/4/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "CreateHouseViewController2.h"
#import "ViewHelpers.h"

@interface CreateHouseViewController2 ()

@end

@implementation CreateHouseViewController2

#pragma mark View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Create House";
    self.navigationItem.hidesBackButton = YES;
    
    // Button
    UIBarButtonItem *backBarButton = [ViewHelpers createBackButtonWithTarget:self andSelectorName:@"backButtonClicked:"];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    [ViewHelpers roundCorners:self.messageContainer];
    [ViewHelpers roundCorners:self.createButton];
    
    // Tap recognizer to dismiss keyboard
    UITapGestureRecognizer *singleTapGestureRecognizer = [ViewHelpers createTapGestureRecognizerWithTarget:self andSelectorName:@"singleTap:"];
    [self.scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    [self.createButton addTarget:self action:@selector(createButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Interaction

- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createButtonClicked:(id)sender {
    UIViewController *View = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
    [self.navigationController popToViewController:View animated:YES];
}

-(void)singleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.houseIdField endEditing:YES];
}

@end
