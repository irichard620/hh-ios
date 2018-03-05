//
//  CreateHouseViewController.h
//  hh-ios
//
//  Created by Ian Richard on 1/3/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "House.h"
#import "CreateHouseViewController2.h"

@protocol HouseCreated2Delegate;

@interface CreateHouseViewController : UIViewController <HouseCreatedDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *messageContainer;
@property (weak, nonatomic) IBOutlet UITextField *houseNicknameField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property(weak,nonatomic) id<HouseCreated2Delegate> delegate;
@end
@protocol HouseCreated2Delegate <NSObject>

- (void)houseCreated:(House *)house;

@end
