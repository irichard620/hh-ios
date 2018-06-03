//
//  SettingsViewController.m
//  hh-ios
//
//  Created by Ian Richard on 2/9/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserTableViewCell.h"
#import "ViewHelpers.h"
#import "UserEditViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Settings";
    self.navigationItem.hidesBackButton = YES;
    // Customize nav bar
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    // Button
    self.navigationItem.leftBarButtonItem = [ViewHelpers createNavButtonWithTarget:self andSelectorName:@"backButtonClicked:" andImage:[UIImage imageNamed:@"left-arrow.png"] isBack:YES];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.estimatedSectionHeaderHeight = 30;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.tableView reloadData];
}

#pragma mark Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"userCell";
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [self.tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        // Choose house
        NSLog(@"Name: %@ andAvatar: %@", self.user.fullName, self.user.avatarLink);
        [cell setName:self.user.fullName andAvatarLink:self.user.avatarLink];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell setTitle:@"Help Center" andImage:[UIImage imageNamed:@"help-center.png"] shouldCurve:NO];
        } else {
            [cell setTitle:@"Report a problem" andImage:[UIImage imageNamed:@"report-problem.png"] shouldCurve:NO];
        }
    } else {
        if (indexPath.row == 0) {
            [cell setTitle:@"Terms of use" andImage:[UIImage imageNamed:@"terms-of-use.png"] shouldCurve:NO];
        } else if (indexPath.row == 1) {
            [cell setTitle:@"Privacy policy" andImage:[UIImage imageNamed:@"privacy-policy.png"] shouldCurve:NO];
        } else if (indexPath.row == 2) {
            [cell setTitle:@"Licenses" andImage:[UIImage imageNamed:@"licenses.png"] shouldCurve:NO];
        } else {
            [cell setTitle:@"About the developer" andImage:[UIImage imageNamed:@"about-developer.png"] shouldCurve:NO];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 50;
    } else if (section == 1) {
        return 50;
    } else {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor colorWithRed:0.812 green:0.847 blue:0.863 alpha:1.0];
    label.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
    label.font = [UIFont systemFontOfSize:12];
    if (section == 0) {
        label.frame = CGRectMake(8, 20, self.tableView.frame.size.width, 30);
        label.text = @"USER";
    } else if (section == 1) {
        label.frame = CGRectMake(8, 20, self.tableView.frame.size.width, 30);
        label.text = @"HELP";
    } else {
        label.frame = CGRectMake(8, 20, self.tableView.frame.size.width, 30);
        label.text = @"INFO";
    }
    [header addSubview:label];
    header.backgroundColor = [UIColor colorWithRed:0.812 green:0.847 blue:0.863 alpha:1.0];
    return header;
}

#pragma mark Interaction

- (void)backButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // User edit
        UserEditViewController *vc = [[UserEditViewController alloc]initWithNibName:@"UserEditViewController" bundle:nil];
        vc.user = self.user;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 0) {
        // Help
        if (indexPath.row == 0) {
            // Help center
        } else {
            // Report problem
            
        }
    } else {
        // Info
        if (indexPath.row == 0) {
            // Terms
        } else if (indexPath.row == 1) {
            // Privacy
        } else if (indexPath.row == 2) {
            // Licenses
        } else {
            // About developer
        }
    }
}

@end
