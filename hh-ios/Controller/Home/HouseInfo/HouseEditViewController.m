//
//  HouseEditViewController.m
//  hh-ios
//
//  Created by Ian Richard on 2/9/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "HouseEditViewController.h"
#import "UserHomeTableViewCell.h"
#import "SWRevealViewController.h"
#import "ViewHelpers.h"
#import "EditPropertyTableViewCell.h"
#import "SWRevealViewController+SWRevealViewController_Data.h"

@interface HouseEditViewController ()

@end

@implementation HouseEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0];
    self.navigationItem.title = @"Edit House";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // Add gesture recognizer for reveal controller
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    // Create menu button
    self.navigationItem.leftBarButtonItem = [ViewHelpers createMenuButtonWithTarget:self.revealViewController];
    
    // Setup table
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedSectionHeaderHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // Edit nickname cell
        static NSString *CellIdentifier = @"editProperty";
        EditPropertyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:@"EditPropertyTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.textField.text = @"SCU House";
        return cell;
    } else {
        // Options cells
        static NSString *CellIdentifier = @"userCell";
        UserHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:@"UserHomeTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0) {
            [cell setNoImageCellWithText:@"Manage Residents"];
        } else if (indexPath.row == 1) {
            [cell setNoImageCellWithText:@"Leave House"];
        } else {
            [cell setNoImageCellWithText:@"Disband House"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 110;
    } else {
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 110)];
        header.backgroundColor = [UIColor colorWithRed:0.812 green:0.847 blue:0.863 alpha:1.0];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.tableView.frame.size.width/2 - 35), 20, 70, 70)];
        imageView.image = [UIImage imageNamed:@"group-icon-white-background.png"];
        imageView.layer.cornerRadius = 16.0;
        imageView.clipsToBounds = YES;
        
        [header addSubview:imageView];
        
        return header;
    } else {
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor colorWithRed:0.812 green:0.847 blue:0.863 alpha:1.0];
        label.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        label.font = [UIFont systemFontOfSize:12];
        label.frame = CGRectMake(8, 20, self.tableView.frame.size.width, 30);
        label.text = @"OPTIONS";
        [header addSubview:label];
        header.backgroundColor = [UIColor colorWithRed:0.812 green:0.847 blue:0.863 alpha:1.0];
        return header;
    }
}

@end
