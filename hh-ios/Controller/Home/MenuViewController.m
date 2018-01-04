//
//  MenuViewController.m
//  hh-ios
//
//  Created by Ian Richard on 11/13/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "MenuTableViewCell.h"
#import "TopMenuTableViewCell.h"
#import "ChatViewController.h"
#import "PaymentsViewController.h"

@interface MenuViewController ()

// Keep track of current selected menu item
@property(nonatomic) NSInteger currentIndex;

@end

@implementation MenuViewController

#pragma mark View

// Background - 61 79 92 - 0.239 0.310 0.361
// Grey (in icon and some text) - [UIColor colorWithRed:0.82 green:0.85 blue:0.86 alpha:1.0]
// Selected - 80 98 111
// 178 223 219

- (void)viewDidLoad {
    [super viewDidLoad];
    // Index starts at 1 - chat
    self.currentIndex = 1;
    
    // Setup table view
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuTableView.estimatedRowHeight = 44;
    self.menuTableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 7 rows - house page, home (chat), payments, to-dos, stats, Alexa, settings
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"topMenuCell";
        TopMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [self.menuTableView registerNib:[UINib nibWithNibName:@"TopMenuTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.selectedBackgroundView = [self getSelectedView:cell.frame];

        [cell setTitle:@"Scu House" andSubtitle:@"@scu-house" andImage:[UIImage imageNamed:@"HH_group_placeholder.png"]];
        [cell.exitButton removeTarget:self action:@selector(exitButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.exitButton addTarget:self action:@selector(exitButtonAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    else {
        static NSString *CellIdentifier = @"menuCell";
        MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.menuTableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        cell.selectedBackgroundView = [self getSelectedView:cell.frame];
        
        if (indexPath.row == 1) {
            [cell setTitle:@"Home" andImage:[UIImage imageNamed:@"home.png"] changeColor:NO];
        } else if (indexPath.row == 2) {
            [cell setTitle:@"Payments" andImage:[UIImage imageNamed:@"tag.png"] changeColor:NO];
        } else if (indexPath.row == 3) {
            [cell setTitle:@"To-Dos" andImage:[UIImage imageNamed:@"check.png"] changeColor:NO];
        } else if (indexPath.row == 4) {
            [cell setTitle:@"Statistics" andImage:[UIImage imageNamed:@"bar-chart.png"] changeColor:NO];
        } else if (indexPath.row == 5) {
            [cell setTitle:@"Connect to Alexa" andImage:[UIImage imageNamed:@"share.png"] changeColor:NO];
        } else if (indexPath.row == 6) {
            [cell setTitle:@"Settings" andImage:[UIImage imageNamed:@"settings.png"] changeColor:NO];
        }
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Will display");
    if (indexPath.row == 1) {
        [cell setSelected:YES];
    }
}

- (UIView *)getSelectedView:(CGRect)frame {
    UIView *myBackView = [[UIView alloc] initWithFrame:frame];
    myBackView.backgroundColor = [UIColor colorWithRed:0.314 green:0.384 blue:0.435 alpha:1];
    return myBackView;
}

#pragma mark User Interaction

- (void)exitButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && !(self.currentIndex == 0)) {
        // House page
        [[self.menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]setSelected:NO];
    } else if (indexPath.row == 1 && !(self.currentIndex == 1)) {
        // Home - chat
        ChatViewController *chatVC = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:chatVC];
        [self.revealViewController pushFrontViewController:navVC animated:YES];
        self.currentIndex = 1;
    } else if (indexPath.row == 2 && !(self.currentIndex == 2)) {
        // Payments
        [[self.menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]setSelected:NO];
        PaymentsViewController *paymentsVC = [[PaymentsViewController alloc]initWithNibName:@"PaymentsViewController" bundle:nil];
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:paymentsVC];
        [self.revealViewController pushFrontViewController:navVC animated:YES];
        self.currentIndex = 2;
    } else if (indexPath.row == 3 && !(self.currentIndex == 3)) {
        // To-dos
        [[self.menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]setSelected:NO];
    } else if (indexPath.row == 4 && !(self.currentIndex == 4)) {
        // Stats
        [[self.menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]setSelected:NO];
    } else if (indexPath.row == 5 && !(self.currentIndex == 5)) {
        // Alexa
        [[self.menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]setSelected:NO];
    } else if (indexPath.row == 6 && !(self.currentIndex == 6)) {
        // Settings
        [[self.menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]setSelected:NO];
    }
}

@end
