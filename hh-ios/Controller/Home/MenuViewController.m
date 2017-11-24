//
//  MenuViewController.m
//  hh-ios
//
//  Created by Ian Richard on 11/13/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "TopMenuTableViewCell.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    // 61 79 92
    // 178 223 219
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuTableView.estimatedRowHeight = 44.0;
    self.menuTableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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

- (void)exitButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
