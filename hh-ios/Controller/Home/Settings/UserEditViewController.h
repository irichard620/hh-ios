//
//  UserEditViewController.h
//  hh-ios
//
//  Created by Ian Richard on 4/18/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"

@protocol UserEditDelegate;

@interface UserEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) User *user;

@property (weak, nonatomic) id<UserEditDelegate> delegate;
@end
@protocol UserEditDelegate <NSObject>

- (void)userEdited;

@end
