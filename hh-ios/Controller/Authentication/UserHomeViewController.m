//
//  UserHomeViewController.m
//  hh-ios
//
//  Created by Ian Richard on 11/21/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "UserHomeViewController.h"
#import "ChatViewController.h"
#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "ViewHelpers.h"
#import "UserHomeTableViewCell.h"
#import "MenuTableViewCell.h"
#import "JoinHouseViewController.h"
#import "CreateHouseViewController.h"

@interface UserHomeViewController ()

@property (nonatomic) BOOL navBarShouldDissapear;

@end

@implementation UserHomeViewController

#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _navBarShouldDissapear = NO;
    }
    return self;
}

#pragma mark View methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Customize nav bar
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0];
    self.navigationItem.title = @"Choose House";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // Table view background - 207, 216, 220
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.estimatedSectionHeaderHeight = 30;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.navBarShouldDissapear) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
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
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"userHomeCell";
    UserHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [self.tableView registerNib:[UINib nibWithNibName:@"UserHomeTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        // Choose house
        [cell setTitle:@"Scu House" andImage:[UIImage imageNamed:@"group-icon-black-background.png"] shouldCurve:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell setTitle:@"Create new house" andImage:[UIImage imageNamed:@"home_black.png"] shouldCurve:NO];
        } else {
            [cell setTitle:@"Join a house" andImage:[UIImage imageNamed:@"grid.png"] shouldCurve:NO];
        }
    } else {
        // Logout
        [cell setTitle:@"Logout" andImage:[UIImage imageNamed:@"close.png"] shouldCurve:NO];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 50;
    } else if (section == 1) {
        return 50;
    } else {
        return 100;
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
        label.text = @"CHOOSE EXISTING";
    } else if (section == 1) {
        label.frame = CGRectMake(8, 20, self.tableView.frame.size.width, 30);
        label.text = @"CREATE OR JOIN";
    } else {
        header.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 100);
        label.frame = CGRectMake(8, 70, self.tableView.frame.size.width, 30);
        label.text = @"LOGGED IN AS IRICHARD@SCU.EDU";
        UILabel *label2 = [[UILabel alloc]init];
        label2.backgroundColor = [UIColor colorWithRed:0.812 green:0.847 blue:0.863 alpha:1.0];
        label2.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
        label2.font = [UIFont systemFontOfSize:12];
        label2.frame = CGRectMake(8, 8, self.tableView.frame.size.width, 30);
        label2.numberOfLines = 0;
        label2.text = @"To join a house, you must have received an email invitation from an existing user that contained a unique code for the house.";
        [label2 sizeToFit];
        [header addSubview:label2];
    }
    [header addSubview:label];
    header.backgroundColor = [UIColor colorWithRed:0.812 green:0.847 blue:0.863 alpha:1.0];
    return header;
}

#pragma mark User interaction

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // Create front controller
        ChatViewController *chatVC = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:chatVC];
        
        // Create rear controller
        MenuViewController *menuVC = [[MenuViewController alloc]initWithNibName:@"MenuViewController" bundle:nil];
        
        // Create reveal controller
        SWRevealViewController *revealVC = [[SWRevealViewController alloc]initWithRearViewController:menuVC frontViewController:navVC];
        revealVC.rearViewRevealOverdraw = 0;
        [revealVC revealToggleAnimated:NO];
        
        self.navBarShouldDissapear = YES;
        [self.navigationController pushViewController:revealVC animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // Create
            CreateHouseViewController *createHouseVC = [[CreateHouseViewController alloc]initWithNibName:@"CreateHouseViewController" bundle:nil];
            self.navBarShouldDissapear = NO;
            [self.navigationController pushViewController:createHouseVC animated:YES];
        } else {
            // Join
            JoinHouseViewController *joinHouseVC = [[JoinHouseViewController alloc]initWithNibName:@"JoinHouseViewController" bundle:nil];
            self.navBarShouldDissapear = NO;
            [self.navigationController pushViewController:joinHouseVC animated:YES];
        }
    } else if (indexPath.section == 2) {
        // Logout
        self.navBarShouldDissapear = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
