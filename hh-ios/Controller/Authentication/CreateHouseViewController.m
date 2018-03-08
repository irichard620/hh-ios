//
//  CreateHouseViewController.m
//  hh-ios
//
//  Created by Ian Richard on 1/3/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "CreateHouseViewController.h"
#import "ViewHelpers.h"

#define TRIM(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

@interface CreateHouseViewController ()

@end

@implementation CreateHouseViewController

#pragma mark View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Create House";
    self.navigationItem.hidesBackButton = YES;
    
    // Button
    self.navigationItem.leftBarButtonItem = [ViewHelpers createNavButtonWithTarget:self andSelectorName:@"backButtonClicked:" andImage:[UIImage imageNamed:@"left-arrow.png"] isBack:YES];;
    
    [ViewHelpers roundCorners:self.messageContainer];
    [ViewHelpers roundCorners:self.continueButton];
    
    // Tap recognizer to dismiss keyboard
    UITapGestureRecognizer *singleTapGestureRecognizer = [ViewHelpers createTapGestureRecognizerWithTarget:self andSelectorName:@"singleTap:"];
    [self.scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    [self.continueButton addTarget:self action:@selector(continueButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Interaction

- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)continueButtonClicked:(id)sender {
    NSString *displayName = TRIM(self.houseNicknameField.text);
    
    if ([displayName isEqualToString:@""]) {
        [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Missing Display Name" andDescription:@"Please enter a display name for your new house."] animated:YES completion:nil];
    } else {
        CreateHouseViewController2 *createHouse2VC = [[CreateHouseViewController2 alloc]initWithNibName:@"CreateHouseViewController2" bundle:nil];
        createHouse2VC.displayName = displayName;
        createHouse2VC.delegate = self;
        [self.navigationController pushViewController:createHouse2VC animated:YES];
    }
}

-(void)singleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.houseNicknameField endEditing:YES];
}

#pragma mark Created delegate

- (void)houseCreated:(House *)house {
    [self.delegate houseCreated:house];
}

@end
