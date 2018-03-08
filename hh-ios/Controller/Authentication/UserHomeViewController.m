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
#import "UserManager.h"
#import "AuthenticationManager.h"
#import "HouseManager.h"
#import <TwilioAccessManager/TwilioAccessManager.h>
#import <TwilioChatClient/TwilioChatClient.h>

@interface UserHomeViewController ()

@property (nonatomic) BOOL navBarShouldDissapear;
@property (nonatomic) NSMutableArray *houseArray;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) NSString *currentHouseUniqueName;

@property(strong, nonatomic) TwilioAccessManager *twilioAccessManager;
@property(strong, nonatomic) TwilioChatClient *chatClient;

@end

@implementation UserHomeViewController

#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _currentHouseUniqueName = nil;
        _navBarShouldDissapear = NO;
        _isLoading = YES;
        _houseArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)deallocTwilio {
    self.chatClient = nil;
    self.twilioAccessManager = nil;
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
    
    // Settings button top right
    self.navigationItem.rightBarButtonItem = [ViewHelpers createNavButtonWithTarget:self andSelectorName:@"settingsClicked:" andImage:[UIImage imageNamed:@"settings.png"] isBack:NO];
    
    // Table view background - 207, 216, 220
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.estimatedSectionHeaderHeight = 30;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    NSLog(@"View did finish loading");
    [self setupTwilio];
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

#pragma mark Data

- (void)setupTwilio {
    NSLog(@"Setup Twilio in UserHome");
    self.twilioAccessManager = [TwilioAccessManager accessManagerWithToken:[AuthenticationManager getCurrentTwilioAccessToken] delegate:self];
    NSLog(@"Twilio token %@", [self.twilioAccessManager currentToken]);
    [TwilioChatClient chatClientWithToken:self.twilioAccessManager.currentToken properties:nil delegate:self completion:^(TCHResult * _Nonnull result, TwilioChatClient * _Nullable chatClient) {
        if ([result isSuccessful]) {
            self.chatClient = chatClient;
            __weak typeof(chatClient) weakClient = chatClient;
            [self.twilioAccessManager registerClient:chatClient forUpdates:^(NSString *updatedToken) {
                [weakClient updateToken:updatedToken completion:^(TCHResult *result) {
                    if (![result isSuccessful]) {
                        // warn the user the update didn't succeed
                        NSLog(@"Twilio Client couldn't update token");
                    } else {
                        NSLog(@"Twilio client updated token");
                    }
                }];
            }];
        }
    }];
    
    // Get user and house
    if (!self.user) {
        NSLog(@"No user on UserHome yet");
        [self getUser];
    } else {
        [self getHouses];
    }
}

- (void)getUser {
    NSLog(@"Get user");
    [UserManager getUserWithCompletion:^(User *user, NSString *error) {
        if (!error) {
            self.user = user;
            [self getHouses];
        } else {
            [self getHouses];
        }
    }];
}

- (void)getHouses {
    NSLog(@"Get Houses");
    [UserManager getHouseListForUserWithCompletion:^(NSArray *houses, NSString *error) {
        if (!error) {
            [self.houseArray addObjectsFromArray:houses];
            self.isLoading = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            self.isLoading = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

#pragma mark Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.isLoading) {
            return 1;
        } else {
            if (self.houseArray.count == 0) return 1;
            else return self.houseArray.count;
        }
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
        if (self.isLoading) {
            [cell setNoImageCellWithText:@"Loading..."];
        } else if (self.houseArray.count == 0) {
            [cell setNoImageCellWithText:@"No Houses to Show"];
        } else {
            House *house = [self.houseArray objectAtIndex:indexPath.row];
            [cell setHouseName:house.displayName andAvatarLink:house.avatarLink];
        }
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
        if (self.isLoading) {
            label.text = @"Loading...";
        } else {
            label.text = [NSString stringWithFormat:@"LOGGED IN AS %@", [self.user.email uppercaseString]];
        }
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

- (void)settingsClicked:(id)sender {
    // Push settings controller onto nav stack
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.isLoading || self.houseArray.count == 0) return;
        
        // Get house object
        House *house = [self.houseArray objectAtIndex:indexPath.row];
        
        // Channel list
        TCHChannels *channels = [self.chatClient channelsList];
        
        // Create front controller
        ChatViewController *chatVC = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
        chatVC.user = self.user;
        chatVC.house = house;
        chatVC.channels = channels;
        
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:chatVC];
        
        // Create rear controller
        MenuViewController *menuVC = [[MenuViewController alloc]initWithNibName:@"MenuViewController" bundle:nil];
        menuVC.user = self.user;
        menuVC.house = house;
        
        // Create reveal controller
        SWRevealViewController *revealVC = [[SWRevealViewController alloc]initWithRearViewController:menuVC frontViewController:navVC];
        revealVC.rearViewRevealOverdraw = 0;
        [revealVC revealToggleAnimated:NO];
        
        self.navBarShouldDissapear = YES;
        self.currentHouseUniqueName = house.uniqueName;
        [self.navigationController pushViewController:revealVC animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            // Create
            CreateHouseViewController *createHouseVC = [[CreateHouseViewController alloc]initWithNibName:@"CreateHouseViewController" bundle:nil];
            self.navBarShouldDissapear = NO;
            createHouseVC.delegate = self;
            [self.navigationController pushViewController:createHouseVC animated:YES];
        } else {
            // Join
            JoinHouseViewController *joinHouseVC = [[JoinHouseViewController alloc]initWithNibName:@"JoinHouseViewController" bundle:nil];
            self.navBarShouldDissapear = NO;
            joinHouseVC.delegate = self;
            [self.navigationController pushViewController:joinHouseVC animated:YES];
        }
    } else if (indexPath.section == 2) {
        // Dealloc
        [self deallocTwilio];
        
        // Logout
        [AuthenticationManager logout];
        self.navBarShouldDissapear = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark Created delegate

- (void)houseCreated:(House *)house {
    // Add it to table
    NSLog(@"Created a house");
    [self.houseArray addObject:house];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark Joined delegate

- (void)joinedHouse:(House *)house {
    // Add it to table
    NSLog(@"Joined a house");
    [self.houseArray addObject:house];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark Access manager delegate

- (void)accessManagerTokenWillExpire:(TwilioAccessManager *)accessManager {
    // Notification if access manager expires
    NSLog(@"Access token will expire");
    // Send request
    [AuthenticationManager getTwilioAccessTokenWithCompletion:^(NSString *newToken, NSString *error) {
        if (!error) {
            [accessManager updateToken:newToken];
            NSLog(@"Twilio token %@", [self.twilioAccessManager currentToken]);
        } else {
            NSLog(@"Could not get token at this time");
        }
    }];
}

#pragma mark Chat Delegate

- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel messageAdded:(TCHMessage *)message {
    NSLog(@"%@",message.body);
    
    // First, make sure message not from us
    // Messages from us are handled on our side before sent to others
    if ([message.author isEqualToString:self.user._id]) {
        return;
    }

    // Get type
    NSString *messageType = [message.attributes objectForKey:@"type"];
    if ([messageType isEqualToString:EDIT_HOUSE_MESSAGE]) {
        // If edit house message - adjust this screen
        // Refresh house
        [HouseManager getHouseWithUniqueName:channel.uniqueName withCompletion:^(House *house, NSString *error) {
            // Find house in array and update
            for (int i = 0; i < self.houseArray.count; i++) {
                if ([[(House *)[self.houseArray objectAtIndex:i] uniqueName] isEqualToString:house.uniqueName]) {
                    [self.houseArray replaceObjectAtIndex:i withObject:house];
                    break;
                }
            }
            // Reload table
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    }
    
    // Send notification
    [[NSNotificationCenter defaultCenter]postNotificationName:messageType object:nil userInfo:message.attributes];
}

@end
