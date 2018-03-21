//
//  ToDosViewController.h
//  hh-ios
//
//  Created by Ian Richard on 1/7/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoManager.h"
#import "UserManager.h"
#import "TodoDetailsViewController.h"

@interface ToDosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, TodoDetailsDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *todosTableView;

@property (nonatomic) House *house;
@property (nonatomic) User *user;

@end
