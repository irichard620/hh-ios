//
//  ChatViewController.m
//  hh-ios
//
//  Created by Ian Richard on 11/13/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "ChatViewController.h"
#import "SWRevealViewController.h"
#import "ViewHelpers.h"
#import "ChatMessageTableViewCell.h"
#import "ChatTimeTableViewCell.h"
#import "ChatActionTableViewCell.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (id)init {
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set bar color
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0];
    
    // Set color of text bar
    self.textInputbar.barTintColor = [UIColor colorWithRed:0.812 green:0.847 blue:0.863 alpha:1.0];
    
    // Setup SLK Controller
    self.inverted = NO;
    self.shouldScrollToBottomAfterKeyboardShows = YES;
    self.textView.placeholder = @"Send Message...";
    
    // Setup table view
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Add gesture recognizer for reveal controller
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    // Create menu button
    UIImage* menuImage = [UIImage imageNamed:@"menu.png"];
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(15,5, 25,25)];
    [menuButton setBackgroundImage:menuImage forState:UIControlStateNormal];
    [menuButton addTarget:self.revealViewController action:@selector(revealToggle:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButton =[[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem =menuBarButton;
    
    // Titlel abel
    [ViewHelpers createNavTitleLabelWithText:@"Home" andNavItem:self.navigationItem];
    
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Only one section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Fake info
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Create cells
    if (indexPath.row == 0 || indexPath.row == 12) {
        static NSString *CellIdentifier = @"actionCell";
        ChatActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:@"ChatActionTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0) {
            [cell setHouseAction:@"Ian Richard created the house 'Scu House'. Time to start chatting!"];
        } else {
            [cell setPaymentAction:@"Brian Cox paid Ian Richard for 'Door mat'"];
        }
        return cell;
    } else if (indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 8) {
        static NSString *CellIdentifier = @"timeCell";
        ChatTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:@"ChatTimeTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        if (indexPath.row == 1) {
            [cell setTime:@"Mon, 8:15pm"];
        } else if (indexPath.row == 4) {
            [cell setTime:@"Tue, 2:27pm"];
        } else {
            [cell setTime:@"Wed, 5:15pm"];
        }
        return cell;
    } else {
        static NSString *CellIdentifier = @"messageCell";
        ChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:@"ChatMessageTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 2) {
            [cell setName:@"Ian Richard" andMessage:@"Hey, we need to clean the bathroom today." andProfileImage:[UIImage imageNamed:@"ian_profile.jpg"] showMarker:YES];
        } else if (indexPath.row == 3) {
            [cell setName:@"Brian Cox" andMessage:@"Ok, sounds good. 2pm?" andProfileImage:[UIImage imageNamed:@"ian_profile2.jpg"] showMarker:NO];
        } else if (indexPath.row == 5) {
            [cell setName:@"Brian Cox" andMessage:@"Hey, Trader Joe's today?" andProfileImage:[UIImage imageNamed:@"ian_profile2.jpg"] showMarker:NO];
        } else if (indexPath.row == 6) {
            [cell setName:@"Ian Richard" andMessage:@"Yeah. I'm in class till 5. Would 5:30 work?" andProfileImage:[UIImage imageNamed:@"ian_profile.jpg"] showMarker:YES];
        } else if (indexPath.row == 7) {
            [cell setName:@"Brian Cox" andMessage:@"Yeah, i'll meet you at the house" andProfileImage:[UIImage imageNamed:@"ian_profile2.jpg"] showMarker:NO];
        } else if (indexPath.row == 9) {
            [cell setName:@"Ian Richard" andMessage:@"Let's get a new front door mat" andProfileImage:[UIImage imageNamed:@"ian_profile.jpg"] showMarker:YES];
        } else if (indexPath.row == 10) {
            [cell setName:@"Brian Cox" andMessage:@"Sure, as long as it's not more than 20 dollars" andProfileImage:[UIImage imageNamed:@"ian_profile2.jpg"] showMarker:NO];
        } else if (indexPath.row == 11) {
            [cell setName:@"Ian Richard" andMessage:@"Ok I found one, charging you 10 dollars" andProfileImage:[UIImage imageNamed:@"ian_profile.jpg"] showMarker:YES];
        }
        return cell;
    }
}


@end