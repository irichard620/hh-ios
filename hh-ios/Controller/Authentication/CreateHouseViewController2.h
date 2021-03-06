//
//  CreateHouseViewController2.h
//  hh-ios
//
//  Created by Ian Richard on 1/4/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "House.h"

@protocol HouseCreatedDelegate;

@interface CreateHouseViewController2 : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *messageContainer;
@property (weak, nonatomic) IBOutlet UITextField *houseIdField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

// Pass through display name
@property (nonatomic) NSString *displayName;

@property(weak,nonatomic) id<HouseCreatedDelegate> delegate;
@end
@protocol HouseCreatedDelegate <NSObject>

- (void)houseCreated:(House *)house;

@end
