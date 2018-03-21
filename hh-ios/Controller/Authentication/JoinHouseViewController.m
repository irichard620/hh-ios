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
    self.navigationItem.leftBarButtonItem = [ViewHelpers createNavButtonWithTarget:self andSelectorName:@"backButtonClicked:" andImage:[UIImage imageNamed:@"left-arrow.png"] isBack:YES];;

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
    [self setToLoading];
    NSString *uniqueId = TRIM(self.houseCodeField.text);
    [HouseManager joinHouseWithUnique:uniqueId withCompletion:^(House *house, NSString *error) {
        if (error) {
            if ([error isEqualToString:NOT_AUTHORIZED_ERROR]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:@"You are not invited to join the specified house."] animated:YES completion:nil];
                    [self resetFromLoading];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:@"An unknown error occurred. Please try again later."] animated:YES completion:nil];
                    [self resetFromLoading];
                });
            }
        } else {
            [self.delegate joinedHouse:house];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

-(void)singleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.houseCodeField endEditing:YES];
}

#pragma mark Helpers

- (void)setToLoading {
    [self.view endEditing:YES];
    [self.view setUserInteractionEnabled:NO];
    [self.activityIndicator startAnimating];
    [self.joinHouseButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)resetFromLoading {
    [self.view setUserInteractionEnabled:YES];
    [self.activityIndicator stopAnimating];
    [self.joinHouseButton setTitle:@"Join House" forState:UIControlStateNormal];
}

@end
