//
//  ToDosViewController.h
//  hh-ios
//
//  Created by Ian Richard on 1/7/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *todosTableView;

@end
