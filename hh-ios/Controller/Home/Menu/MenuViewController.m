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
#import "AlexaViewController.h"
#import "ToDosViewController.h"
#import "HouseEditViewController.h"

NSInteger const EDIT = 0;
NSInteger const CHAT = 1;
NSInteger const PAYMENTS = 2;
NSInteger const TODOS = 3;
NSInteger const RESIDENTS = 4;
NSInteger const ALEXA = 5;
NSInteger const SETTINGS = 6;

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
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
    gradient.colors = @[(id)[UIColor colorWithRed:61/255.0 green:79/255.0 blue:92/255.0 alpha:1.0].CGColor, (id)[UIColor blackColor].CGColor];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
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

        [cell setTitle:self.house.displayName andSubtitle:[NSString stringWithFormat:@"@%@",self.house.uniqueName] andAvatarLink:self.house.avatarLink];
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
        
        if (indexPath.row == CHAT) {
            [cell setTitle:@"Home" andImage:[UIImage imageNamed:@"home.png"] changeColor:NO];
        } else if (indexPath.row == PAYMENTS) {
            [cell setTitle:@"Payments" andImage:[UIImage imageNamed:@"tag.png"] changeColor:NO];
        } else if (indexPath.row == TODOS) {
            [cell setTitle:@"To-Dos" andImage:[UIImage imageNamed:@"check.png"] changeColor:NO];
        } else if (indexPath.row == RESIDENTS) {
            [cell setTitle:@"Residents" andImage:[UIImage imageNamed:@"manage_residents.png"] changeColor:NO];
        } else if (indexPath.row == ALEXA) {
            [cell setTitle:@"Connect to Alexa" andImage:[UIImage imageNamed:@"share.png"] changeColor:NO];
        } else if (indexPath.row == SETTINGS) {
            [cell setTitle:@"Settings" andImage:[UIImage imageNamed:@"settings.png"] changeColor:NO];
        }
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == CHAT) {
        [cell setSelected:YES];
    }
}

- (UIView *)getSelectedView:(CGRect)frame {
    UIView *myBackView = [[UIView alloc] initWithFrame:frame];
    myBackView.backgroundColor = [UIColor colorWithRed:0.314 green:0.384 blue:0.435 alpha:0.4];
    return myBackView;
}

#pragma mark User Interaction

- (void)exitButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == EDIT && !(self.currentIndex == EDIT)) {
        // House page
        [[self.menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:CHAT inSection:0]]setSelected:NO];
        HouseEditViewController *editVC = [[HouseEditViewController alloc]initWithNibName:@"HouseEditViewController" bundle:nil];
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:editVC];
        [self.revealViewController pushFrontViewController:navVC animated:YES];
        self.currentIndex = EDIT;
    } else if (indexPath.row == CHAT && !(self.currentIndex == CHAT)) {
        // Home - chat
        ChatViewController *chatVC = [[ChatViewController alloc]init];
        chatVC.user = self.user;
        chatVC.house = self.house;
        chatVC.channel = self.channel;
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:chatVC];
        [self.revealViewController pushFrontViewController:navVC animated:YES];
        self.currentIndex = CHAT;
    } else if (indexPath.row == PAYMENTS && !(self.currentIndex == PAYMENTS)) {
        // Payments
        [[self.menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:CHAT inSection:0]]setSelected:NO];
        PaymentsViewController *paymentsVC = [[PaymentsViewController alloc]initWithNibName:@"PaymentsViewController" bundle:nil];
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:paymentsVC];
        [self.revealViewController pushFrontViewController:navVC animated:YES];
        self.currentIndex = PAYMENTS;
    } else if (indexPath.row == TODOS && !(self.currentIndex == TODOS)) {
        // To-dos
        [[self.menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:CHAT inSection:0]]setSelected:NO];
        ToDosViewController *todoVC = [[ToDosViewController alloc]initWithNibName:@"ToDosViewController" bundle:nil];
        todoVC.house = self.house;
        todoVC.user = self.user;
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:todoVC];
        [self.revealViewController pushFrontViewController:navVC animated:YES];
        self.currentIndex = TODOS;
    } else if (indexPath.row == RESIDENTS && !(self.currentIndex == RESIDENTS)) {
        // residents
        [[self.menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:CHAT inSection:0]]setSelected:NO];
        ResidentsViewController *residentVC = [[ResidentsViewController alloc]initWithNibName:@"ResidentsViewController" bundle:nil];
        
        // Pass house
        residentVC.house = self.house;
        residentVC.user = self.user;
        
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:residentVC];
        [self.revealViewController pushFrontViewController:navVC animated:YES];
        self.currentIndex = RESIDENTS;
    }else if (indexPath.row == ALEXA && !(self.currentIndex == ALEXA)) {
        // Alexa
        [[self.menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:CHAT inSection:0]]setSelected:NO];
        AlexaViewController *alexaVC = [[AlexaViewController alloc]initWithNibName:@"AlexaViewController" bundle:nil];
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:alexaVC];
        [self.revealViewController pushFrontViewController:navVC animated:YES];
        self.currentIndex = ALEXA;
    } else if (indexPath.row == SETTINGS && !(self.currentIndex == SETTINGS)) {
        // Settings
        [[self.menuTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:CHAT inSection:0]]setSelected:NO];
    }
}

#pragma mark Delegate



@end
