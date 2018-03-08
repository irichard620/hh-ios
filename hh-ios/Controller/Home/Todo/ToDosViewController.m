//
//  ToDosViewController.m
//  hh-ios
//
//  Created by Ian Richard on 1/7/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "ToDosViewController.h"
#import "SWRevealViewController.h"
#import "IncompleteToDoTableViewCell.h"
#import "CompletedToDoTableViewCell.h"
#import "ViewHelpers.h"

@interface ToDosViewController ()

@property(nonatomic) NSMutableArray *incompleteArray;
@property(nonatomic) NSMutableArray *pastArray;
@property(nonatomic) UIView *oldHeaderView;

@property(nonatomic) BOOL needsReloadHeader;

@property(strong,nonatomic) UISegmentedControl *segment;

@end

@implementation ToDosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _incompleteArray = [[NSMutableArray alloc]init];
        _pastArray = [[NSMutableArray alloc]init];
        _needsReloadHeader = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0];
    self.navigationItem.title = @"To-Dos";
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
    self.todosTableView.dataSource = self;
    self.todosTableView.delegate = self;
    self.todosTableView.estimatedSectionHeaderHeight = 30;
    self.todosTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            return 2;
        } else {
            return 5;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segment.selectedSegmentIndex == 0) {
        static NSString *CellIdentifier = @"incompleteCell";
        IncompleteToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.todosTableView registerNib:[UINib nibWithNibName:@"IncompleteToDoTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        if (indexPath.row == 0) {
            [cell setName:@"Brian Cox" andMessage:@"Clean the bathroom" andImage:[UIImage imageNamed:@"ian_profile2.jpg"] andTime:@"2h" andIsCreatedByMe:YES andIsAssignedToMe:NO];
        } else {
            [cell setName:@"Ian Richard" andMessage:@"Call utility company" andImage:[UIImage imageNamed:@"ian_profile.jpg"] andTime:@"5h" andIsCreatedByMe:NO andIsAssignedToMe:YES];
        }
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"completeCell";
        CompletedToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.todosTableView registerNib:[UINib nibWithNibName:@"CompletedToDoTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 0) {
            [cell setName:@"Ian Richard" andMessage:@"Mop kitchen" andProfileImage:[UIImage imageNamed:@"ian_profile.jpg"] andTime:@"1d" andTimeTaken:30];
        } else if (indexPath.row == 1) {
            [cell setName:@"Brian Cox" andMessage:@"Fix TV stand" andProfileImage:[UIImage imageNamed:@"ian_profile2.jpg"] andTime:@"4d" andTimeTaken:45];
        } else if (indexPath.row == 2) {
            [cell setName:@"Ian Richard" andMessage:@"Vacuum living room" andProfileImage:[UIImage imageNamed:@"ian_profile.jpg"] andTime:@"4d" andTimeTaken:20];
        } else if (indexPath.row == 3) {
            [cell setName:@"Brian Cox" andMessage:@"Take out garbage" andProfileImage:[UIImage imageNamed:@"ian_profile2.jpg"] andTime:@"6d" andTimeTaken:10];
        } else {
            [cell setName:@"Brian Cox" andMessage:@"Talk to city about landscaping" andProfileImage:[UIImage imageNamed:@"ian_profile2.jpg"] andTime:@"8d" andTimeTaken:15];
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
        self.oldHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.todosTableView.frame.size.width, 60)];
        self.oldHeaderView.backgroundColor = [UIColor whiteColor];
        
        // Set up segment w appearance
        self.segment = [[UISegmentedControl alloc]initWithItems:@[@"Incomplete", @"Past"]];
        self.segment.frame = CGRectMake(8, 8, self.todosTableView.frame.size.width - 16, 44);
        self.segment.selectedSegmentIndex = 0;
        self.segment.tintColor = [UIColor colorWithRed:0.239 green:0.310 blue:0.361 alpha:1];
        self.segment.userInteractionEnabled = YES;
        
        // Set data
        [self.todosTableView reloadData];
        
        // monitor for value of segment changing
        [self.segment addTarget:self action:@selector(segmentOptionChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.oldHeaderView addSubview:self.segment];
        return self.oldHeaderView;
        
    } else {
        return self.oldHeaderView;
    }
}

- (void)segmentOptionChanged:(id)sender {
    [self.todosTableView reloadData];
}

- (void)addButtonClicked:(id)sender {
}

@end
