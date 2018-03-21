//
//  HouseEditViewController.h
//  hh-ios
//
//  Created by Ian Richard on 2/9/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseManager.h"

@interface HouseEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) House *house;
@property (nonatomic) User *user;

@end
