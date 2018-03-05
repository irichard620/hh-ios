//
//  UserHomeViewController.h
//  hh-ios
//
//  Created by Ian Richard on 11/21/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "CreateHouseViewController.h"
#import "JoinHouseViewController.h"

@interface UserHomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, HouseCreated2Delegate, JoinHouseDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic) User *user;

@end
