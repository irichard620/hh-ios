//
//  UserHomeViewController.h
//  hh-ios
//
//  Created by Ian Richard on 11/21/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserHomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic) User *user;

@end
