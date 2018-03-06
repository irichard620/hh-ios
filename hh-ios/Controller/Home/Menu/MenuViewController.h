//
//  MenuViewController.h
//  hh-ios
//
//  Created by Ian Richard on 11/13/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "House.h"
#import "User.h"
#import "UserHomeViewController.h"

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UserHomeDelegate>

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@property (nonatomic) House *house;
@property (nonatomic) User *user;

@end
