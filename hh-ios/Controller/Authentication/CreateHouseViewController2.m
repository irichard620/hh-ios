//
//  CreateHouseViewController2.m
//  hh-ios
//
//  Created by Ian Richard on 1/4/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "CreateHouseViewController2.h"
#import "ViewHelpers.h"
#import "HouseManager.h"

#define TRIM(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

@interface CreateHouseViewController2 ()

@end

@implementation CreateHouseViewController2

#pragma mark View Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Create House";
    self.navigationItem.hidesBackButton = YES;
    
    // Button
    self.navigationItem.leftBarButtonItem = [ViewHelpers createNavButtonWithTarget:self andSelectorName:@"backButtonClicked:" andImage:[UIImage imageNamed:@"left-arrow.png"] isBack:YES];;
    
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
    NSString *uniqueId = TRIM(self.houseIdField.text);
    if (uniqueId.length < 6) {
        [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"House Identifier Invalid" andDescription:@"You must enter a house identifier that is 6 or more letters."] animated:YES completion:nil];
    } else {
        [HouseManager createHouseWithDisplay:self.displayName andUnique:uniqueId withCompletion:^(House *house, NSString *error) {
            if (error) {
                if ([error isEqualToString:DUPLICATE_ERROR]) {
                    [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:@"There is already a house with the same unique name."] animated:YES completion:nil];
                } else {
                    [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:@"An unknown error occurred. Please try again later."] animated:YES completion:nil];
                }
            } else {
                // Go back to userHome screen
                [self.delegate houseCreated:house];
                UIViewController *View = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToViewController:View animated:YES];
                });
            }
        }];
    }
}

-(void)singleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.houseIdField endEditing:YES];
}

@end
