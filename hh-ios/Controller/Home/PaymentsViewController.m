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

@interface PaymentsViewController ()

@property(nonatomic) NSMutableArray *requestedArray;
@property(nonatomic) NSMutableArray *incompleteArray;
@property(nonatomic) NSMutableArray *pastArray;

@property(strong,nonatomic) UISegmentedControl *segment;

@end

@implementation PaymentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _requestedArray = [[NSMutableArray alloc]init];
        _incompleteArray = [[NSMutableArray alloc]init];
        _pastArray = [[NSMutableArray alloc]init];
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
    UIImage* menuImage = [UIImage imageNamed:@"menu.png"];
    UIButton *menuButton = [[UIButton alloc] init];
    [menuButton setBackgroundImage:menuImage forState:UIControlStateNormal];
    NSDictionary *views = @{@"menuButton":menuButton};
    [menuButton setFrame:CGRectMake(15,5, 25,25)];
    NSArray *heightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[menuButton(25)]" options:0 metrics:nil views:views];
    NSArray *widthConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[menuButton(25)]" options:0 metrics:nil views:views];
    [menuButton addConstraints:heightConstraint];
    [menuButton addConstraints:widthConstraint];
    [menuButton addTarget:self.revealViewController action:@selector(revealToggle:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButton =[[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem =menuBarButton;
    
    // Setup table
    self.paymentTableView.dataSource = self;
    self.paymentTableView.delegate = self;
    self.paymentTableView.estimatedSectionHeaderHeight = 30;
    self.paymentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            return self.requestedArray.count;
        } else if (self.segment.selectedSegmentIndex == 1) {
            return self.incompleteArray.count;
        } else {
            return self.pastArray.count;
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
        
        return cell;
    } else if (self.segment.selectedSegmentIndex == 1) {
        return nil;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.paymentTableView.frame.size.width, 60)];
    header.backgroundColor = [UIColor whiteColor];
    
    // Set up segment w appearance
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"Requested", @"Incomplete", @"Past"]];
    self.segment.frame = CGRectMake(8, 8, self.paymentTableView.frame.size.width - 16, 44);
    self.segment.selectedSegmentIndex = 0;
    self.segment.tintColor = [UIColor colorWithRed:0.239 green:0.310 blue:0.361 alpha:1];
    
    // Set data
    [self.paymentTableView reloadData];
    
    // monitor for value of segment changing
    [self.segment addTarget:self action:@selector(segmentOptionChanged:) forControlEvents:UIControlEventValueChanged];
    
    [header addSubview:self.segment];
    return header;
}

- (void)segmentOptionChanged:(id)sender {
    [self.paymentTableView reloadData];
}

@end
