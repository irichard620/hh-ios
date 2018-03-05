//
//  JoinHouseViewController.m
//  hh-ios
//
//  Created by Ian Richard on 1/3/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "JoinHouseViewController.h"
#import "ViewHelpers.h"
#import "HouseManager.h"

#define TRIM(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

@interface JoinHouseViewController ()

@end

@implementation JoinHouseViewController

#pragma mark View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Nav customization
    self.navigationItem.title = @"Join House";
    self.navigationItem.hidesBackButton = YES;
    
    // Button
    UIBarButtonItem *backBarButton = [ViewHelpers createBackButtonWithTarget:self andSelectorName:@"backButtonClicked:"];
    self.navigationItem.leftBarButtonItem = backBarButton;

    [ViewHelpers roundCorners:self.messageContainer];
    [ViewHelpers roundCorners:self.joinHouseButton];
    
    // Tap recognizer to dismiss keyboard
    UITapGestureRecognizer *singleTapGestureRecognizer = [ViewHelpers createTapGestureRecognizerWithTarget:self andSelectorName:@"singleTap:"];
    [self.scrollView addGestureRecognizer:singleTapGestureRecognizer];
    
    [self.joinHouseButton addTarget:self action:@selector(joinButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Interaction

- (void)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)joinButtonClicked:(id)sender {
    NSString *uniqueId = TRIM(self.houseCodeField.text);
    [HouseManager joinHouseWithUnique:uniqueId withCompletion:^(House *house, NSString *error) {
        if (error) {
            if ([error isEqualToString:NOT_INVITED_ERROR]) {
                [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:@"You are not invited to join the specified house."] animated:YES completion:nil];
            } else {
                [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:@"An unknown error occurred. Please try again later."] animated:YES completion:nil];
            }
        } else {
            [self.delegate joinedHouse:house];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

-(void)singleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.houseCodeField endEditing:YES];
}

@end
