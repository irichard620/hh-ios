//
//  SWRevealViewController+SWRevealViewController_Data.h
//  hh-ios
//
//  Created by Ian Richard on 2/22/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

// This class allows us to save the user and house object to the outer most view controller, so it does not need to be passed between all individual controllers
#import "SWRevealViewController.h"
#import "User.h"
#import "House.h"

@interface SWRevealViewController (SWRevealViewController_Data)

@property(nonatomic) User *user;
@property(nonatomic) House *house;

@end
