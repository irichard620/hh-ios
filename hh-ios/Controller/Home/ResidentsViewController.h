//
//  ResidentsViewController.h
//  hh-ios
//
//  Created by Ian Richard on 2/6/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResidentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *residentTableView;

@end
