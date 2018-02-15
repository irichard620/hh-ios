//
//  CreateHouseViewController.h
//  hh-ios
//
//  Created by Ian Richard on 1/3/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface CreateHouseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *messageContainer;
@property (weak, nonatomic) IBOutlet UITextField *houseNicknameField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

// User object
@property (nonatomic) User *user;

@end
