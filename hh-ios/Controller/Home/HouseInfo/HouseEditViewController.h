//
//  HouseEditViewController.h
//  hh-ios
//
//  Created by Ian Richard on 2/9/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
