//
//  ResidentsViewController.m
//  hh-ios
//
//  Created by Ian Richard on 2/6/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "ResidentsViewController.h"
#import "SWRevealViewController.h"
#import "ViewHelpers.h"
#import "UserTableViewCell.h"
#import "NSString+Security.h"

#define TRIM(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

@interface ResidentsViewController ()

@property(nonatomic) NSMutableArray *residentsArray;

@property(nonatomic) BOOL loading;

@end

@implementation ResidentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _loading = YES;
        _residentsArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0];
    self.navigationItem.title = @"Residents";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // Add gesture recognizer for reveal controller
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    // Create menu button
    self.navigationItem.leftBarButtonItem = [ViewHelpers createNavButtonWithTarget:self.revealViewController andSelectorName:@"revealToggle:" andImage:[UIImage imageNamed:@"menu.png"] isBack:NO];
    self.navigationItem.rightBarButtonItem = [ViewHelpers createNavButtonWithTarget:self andSelectorName:@"addButtonClicked:" andImage:[UIImage imageNamed:@"add_white.png"] isBack:NO];
        
    // Setup table
    self.residentTableView.dataSource = self;
    self.residentTableView.delegate = self;
    self.residentTableView.estimatedSectionHeaderHeight = 30;
    self.residentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Get residents
    [self getResidents];
}

#pragma mark Data

- (void)getResidents {
    [HouseManager getListOfResidentsWithUniqueName:self.house.uniqueName withCompletion:^(NSArray *residents, NSString *error) {
        if (!error) {
            // Add all non-owners
            User *userToAdd;
            for (int i = 0; i < residents.count; i++) {
                userToAdd = (User *)[residents objectAtIndex:i];
                if (![userToAdd._id isEqualToString:self.house.owner._id]) {
                    [self.residentsArray addObject:[residents objectAtIndex:i]];
                }
            }
        }
        self.loading = NO;
        
        // Add invited
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.residentTableView reloadData];
        });
    }];
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        // Owner only
        return 1;
    } else if (section == 1) {
        return self.residentsArray.count == 0 ? 1 : self.residentsArray.count;
    } else {
        return self.house.invited.count == 0 ? 1 : self.house.invited.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.residentTableView.frame.size.width, 50)];
    headerView.backgroundColor = [UIColor colorWithRed:0.812 green:0.847 blue:0.863 alpha:1.0];

    
    // Add label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 20, self.residentTableView.frame.size.width, 30)];
    label.backgroundColor = [UIColor colorWithRed:0.812 green:0.847 blue:0.863 alpha:1.0];
    label.textColor = [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0];
    label.font = [UIFont systemFontOfSize:12];
    if (section == 0) {
        label.text = @"Owner";
    } else if (section == 1) {
        label.text = @"Other Residents";
    } else {
        label.text = @"Invited Users";
    }
    [headerView addSubview:label];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"userCell";
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [self.residentTableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if (self.loading) {
        [cell setNoImageCellWithText:@"Loading..."];
    } else {
        if (indexPath.section == 0) {
            // Owner
            UserReference *owner = self.house.owner;
            [cell setName:owner.name andAvatarLink:owner.avatarLink];
        } else if (indexPath.section == 1) {
            // Other residents
            if (self.residentsArray.count == 0) {
                [cell setNoImageCellWithText:@"No Other Residents"];
            } else {
                // Get each user
                User *user = [self.residentsArray objectAtIndex:indexPath.row];
                [cell setName:user.fullName andAvatarLink:user.avatarLink];
            }
        } else {
            // Invited
            if (self.house.invited.count == 0) {
                [cell setNoImageCellWithText:@"No Invited Residents"];
            } else {
                // Get each user
                NSString *email = [self.house.invited objectAtIndex:indexPath.row];
                [cell setNoImageCellWithText:email];
            }
        }
    }
    
    return cell;
}

#pragma mark User Interaction

- (void)addButtonClicked:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add User to House" message:@"To add a user, enter their email address below. If they already have an account, use the email they used to create their account" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.placeholder = @"Email";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Invite" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Get email
        NSString *email = TRIM([[alert.textFields objectAtIndex:0]text]);
        if ([email isEqualToString:@""] || email == nil || ![email isValidEmail]) {
            [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Invalid Email" andDescription:@"Please enter a valid email"] animated:YES completion:nil];
        } else {
            // Send network request
            [HouseManager inviteUser:email toHouseName:self.house.uniqueName withCompletion:^(NSString *error) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:error] animated:YES completion:nil];
                    });
                } else {
                    // Update our house object locally
                    NSMutableArray *newInvited = [[NSMutableArray alloc]initWithArray:self.house.invited];
                    [newInvited addObject:email];
                    self.house.invited = newInvited;
                    
                    // Show alert
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Success" andDescription:[NSString stringWithFormat:@"An email has been sent to %@", email]] animated:YES completion:nil];
                    });
                }
            }];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
