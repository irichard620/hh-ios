//
//  PaymentsViewController.m
//  hh-ios
//
//  Created by Ian Richard on 11/25/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "PaymentsViewController.h"
#import "SWRevealViewController.h"
#import "RequestedPaymentTableViewCell.h"
#import "IncompletedPaymentTableViewCell.h"
#import "CompletedPaymentTableViewCell.h"
#import "ViewHelpers.h"

@interface PaymentsViewController ()

@property(nonatomic) NSMutableArray *requestedArray;
@property(nonatomic) NSMutableArray *incompleteArray;
@property(nonatomic) NSMutableArray *pastArray;
@property(nonatomic) UIView *oldHeaderView;

@property(nonatomic) BOOL needsReloadHeader;

@property(strong,nonatomic) UISegmentedControl *segment;

@end

@implementation PaymentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _requestedArray = [[NSMutableArray alloc]init];
        _incompleteArray = [[NSMutableArray alloc]init];
        _pastArray = [[NSMutableArray alloc]init];
        _needsReloadHeader = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0];
    self.navigationItem.title = @"Payments";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // Add gesture recognizer for reveal controller
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
    // Create menu button
    self.navigationItem.leftBarButtonItem = [ViewHelpers createMenuButtonWithTarget:self.revealViewController];
    self.navigationItem.rightBarButtonItem = [ViewHelpers createRightButtonWithTarget:self andSelectorName:@"addButtonClicked:"];
    
    // Setup table
    self.paymentTableView.dataSource = self;
    self.paymentTableView.delegate = self;
    self.paymentTableView.estimatedSectionHeaderHeight = 60;
    self.paymentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Add fake cells
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segment == nil) {
        return 0;
    } else {
        if (self.segment.selectedSegmentIndex == 0) {
//            return self.requestedArray.count;
            return 2;
        } else if (self.segment.selectedSegmentIndex == 1) {
//            return self.incompleteArray.count;
            return 1;
        } else {
//            return self.pastArray.count;
            return 5;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segment.selectedSegmentIndex == 0) {
        static NSString *CellIdentifier = @"requestCell";
        RequestedPaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.paymentTableView registerNib:[UINib nibWithNibName:@"RequestedPaymentTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 0) {
            [cell setName:@"Brian Cox" andMessage:@"Door handle" andProfileImage:[UIImage imageNamed:@"ian_profile2.jpg"] andTime:@"2h" andAmount:6.00];
        } else {
            [cell setName:@"Brian Cox" andMessage:@"Nicole's bday decorations" andProfileImage:[UIImage imageNamed:@"ian_profile2.jpg"] andTime:@"1d" andAmount:20.00];
        }

        
        return cell;
    } else if (self.segment.selectedSegmentIndex == 1) {
        static NSString *CellIdentifier = @"incompleteCell";
        IncompletedPaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.paymentTableView registerNib:[UINib nibWithNibName:@"IncompletedPaymentTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        [cell setName:@"Brian Cox" andMessage:@"US Flag" andProfileImage:[UIImage imageNamed:@"ian_profile2.jpg"] andTime:@"1d" andAmount:10.00];
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"completeCell";
        CompletedPaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.paymentTableView registerNib:[UINib nibWithNibName:@"CompletedPaymentTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 0) {
            [cell setName:@"Brian Cox" andMessage:@"Saturday night" andProfileImage:[UIImage imageNamed:@"ian_profile2.jpg"] andTime:@"1h" andAmount:20.00 andIsNegative:YES];
        } else if (indexPath.row == 1) {
            [cell setName:@"Brian Cox" andMessage:@"Front door mat" andProfileImage:[UIImage imageNamed:@"ian_profile.jpg"] andTime:@"2h" andAmount:10.00 andIsNegative:NO];
        } else if (indexPath.row == 2) {
            [cell setName:@"Brian Cox" andMessage:@"Speaker repair" andProfileImage:[UIImage imageNamed:@"ian_profile2.jpg"] andTime:@"3d" andAmount:40.00 andIsNegative:YES];
        } else if (indexPath.row == 3) {
            [cell setName:@"Brian Cox" andMessage:@"Electricity for Jan." andProfileImage:[UIImage imageNamed:@"ian_profile.jpg"] andTime:@"6d" andAmount:25.00 andIsNegative:NO];
        } else {
            [cell setName:@"Brian Cox" andMessage:@"Paper Towels" andProfileImage:[UIImage imageNamed:@"ian_profile2.jpg"] andTime:@"8d" andAmount:8.00 andIsNegative:YES];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.needsReloadHeader) {
        self.needsReloadHeader = NO;
        self.oldHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.paymentTableView.frame.size.width, 60)];
        self.oldHeaderView.backgroundColor = [UIColor whiteColor];
        
        // Set up segment w appearance
        self.segment = [[UISegmentedControl alloc]initWithItems:@[@"Requested", @"Incomplete", @"Past"]];
        self.segment.frame = CGRectMake(8, 8, self.paymentTableView.frame.size.width - 16, 44);
        self.segment.selectedSegmentIndex = 0;
        self.segment.tintColor = [UIColor colorWithRed:0.239 green:0.310 blue:0.361 alpha:1];
        self.segment.userInteractionEnabled = YES;
        
        // Set data
        [self.paymentTableView reloadData];
        
        // monitor for value of segment changing
        [self.segment addTarget:self action:@selector(segmentOptionChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.oldHeaderView addSubview:self.segment];
        return self.oldHeaderView;

    } else {
        return self.oldHeaderView;
    }
}

- (void)segmentOptionChanged:(id)sender {
    [self.paymentTableView reloadData];
}

- (void)addButtonClicked:(id)sender {
}

@end
