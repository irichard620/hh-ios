//
//  PaymentsViewController.h
//  hh-ios
//
//  Created by Ian Richard on 11/25/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *paymentTableView;

@end
