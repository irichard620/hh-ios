//
//  JoinHouseViewController.m
//  hh-ios
//
//  Created by Ian Richard on 1/3/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "JoinHouseViewController.h"

@interface JoinHouseViewController ()

@end

@implementation JoinHouseViewController

#pragma mark View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Nav customization
    self.navigationItem.title = @"Join House";
    self.navigationItem.hidesBackButton = YES;
    
    // Button with image and size
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    backButton.userInteractionEnabled = YES;
    [backButton setImage:[UIImage imageNamed:@"left-arrow.png"] forState:UIControlStateNormal];
    [backButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [backButton addConstraint:[NSLayoutConstraint constraintWithItem:backButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30]];
    [backButton addConstraint:[NSLayoutConstraint constraintWithItem:backButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:30]];
    
    // Add action
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add to bar button item
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButton;

    self.messageContainer.layer.cornerRadius = 13;
    self.messageContainer.clipsToBounds = YES;
    self.joinHouseButton.layer.cornerRadius = 13;
    self.joinHouseButton.clipsToBounds = YES;
    
    // Tap recognizer to dismiss keyboard
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:singleTapGestureRecognizer];
}

#pragma mark Interaction

- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)singleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.houseCodeField endEditing:YES];
}

@end
