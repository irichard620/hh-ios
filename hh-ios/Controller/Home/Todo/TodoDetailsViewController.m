//
//  TodoDetailsViewController.m
//  hh-ios
//
//  Created by Ian Richard on 2/20/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "TodoDetailsViewController.h"
#import "SWRevealViewController.h"
#import "TodoDetailsTableViewCell.h"
#import "UserTableViewCell.h"
#import "ViewHelpers.h"

@interface TodoDetailsViewController ()

@property(nonatomic) NSMutableArray *residentsArray;
@property(nonatomic) BOOL residentsLoading;

@end

@implementation TodoDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _residentsArray = [[NSMutableArray alloc]init];
        _residentsLoading = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0];
    if (self.isEdit) {
        self.navigationItem.title = @"Edit To-Do";
    } else {
        self.navigationItem.title = @"Create To-Do";
    }
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
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.residentsLoading) {
        return 2;
    } else {
        return 1 + self.residentsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"detailsCell";
        TodoDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:@"TodoDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        if (self.isEdit) {
            if (![self.user._id isEqualToString:self.todo.owner._id]) {
                [cell restrictEditForNonOwner];
            }
        } 
        cell.descrTextView.delegate = self;
        return cell;
    } else {
        static NSString *CellIdentifier = @"userCell";
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        UserReference *user = [self.residentsArray objectAtIndex:indexPath.row - 1];
        [cell setName:user.name andImage:nil];
    }
}

#pragma mark Text view

- (void)textViewDidChange:(UITextView *)textView {
    CGSize currentSize = textView.bounds.size;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(currentSize.width, CGFLOAT_MAX)];
    
    if (newSize.height != currentSize.height) {
        CGPoint currentOffset = [self.tableView contentOffset];
        [UIView setAnimationsEnabled:NO];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [UIView setAnimationsEnabled:YES];
        [self.tableView setContentOffset:currentOffset];
    }
}



@end
