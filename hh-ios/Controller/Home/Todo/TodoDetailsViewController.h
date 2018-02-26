//
//  TodoDetailsViewController.h
//  hh-ios
//
//  Created by Ian Richard on 2/20/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ToDo.h"
#import "SWRevealViewController+SWRevealViewController_Data.h"

@interface TodoDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// PAss in variables
@property (nonatomic) User *user;
@property (nonatomic) ToDo *todo;
@property (nonatomic) BOOL isEdit;

@end
