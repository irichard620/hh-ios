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
#import "UserHomeTableViewCell.h"

@interface ToDosViewController ()

@property(nonatomic) NSMutableArray *incompleteArray;
@property(nonatomic) NSMutableArray *pastArray;
@property(nonatomic) UIView *oldHeaderView;

@property(nonatomic) BOOL needsReloadHeader;

@property(strong,nonatomic) UISegmentedControl *segment;

@property(nonatomic) BOOL isIncompleteLoaded;
@property(nonatomic) BOOL isPastLoaded;

@end

@implementation ToDosViewController

- (void)shouldDealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _incompleteArray = [[NSMutableArray alloc]init];
        _pastArray = [[NSMutableArray alloc]init];
        _needsReloadHeader = YES;
        _isIncompleteLoaded = NO;
        _isPastLoaded = NO;
        
        // Notifications
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(todoCreatedFromNotif:) name:CREATE_TODO_MESSAGE object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(todoEditedFromNotif:) name:EDIT_TODO_MESSAGE object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(todoDeletedFromNotif:) name:DELETE_TODO_MESSAGE object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(todoComletedFromNotif:) name:COMPLETE_TODO_MESSAGE object:nil];
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
    
    // Get incomplete for a house
    [self getIncompleteTodos];
}

#pragma mark Data

- (void)getIncompleteTodos {
    [TodoManager getTodosForHouseWithName:self.house.uniqueName withCompletion:^(NSArray *todos, NSString *error) {
        if (!error) {
            [self.incompleteArray addObjectsFromArray:todos];
        }
        self.isIncompleteLoaded = YES;
        
        // Add items
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.todosTableView reloadData];
        });
    }];
}

- (void)getPastTodos {
    [TodoManager getPastTodosForHouseWithName:self.house.uniqueName withCompletion:^(NSArray *todos, NSString *error) {
        if (!error) {
            [self.pastArray addObjectsFromArray:todos];
        }
        self.isPastLoaded = YES;
        
        // Add items
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.todosTableView reloadData];
        });
    }];
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segment == nil) {
        return 0;
    } else {
        if (self.segment.selectedSegmentIndex == 0 && self.isIncompleteLoaded && self.incompleteArray.count > 0) {
            return self.incompleteArray.count;
        } else if (self.segment.selectedSegmentIndex == 1 && self.isPastLoaded && self.pastArray.count > 0) {
            return self.pastArray.count;
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((self.segment.selectedSegmentIndex == 0 && (!self.isIncompleteLoaded || self.incompleteArray.count == 0)) && (self.segment.selectedSegmentIndex == 1 && (!self.isPastLoaded || self.pastArray.count == 0))) {
        // No image cell
        static NSString *CellIdentifier = @"userHomeCell";
        UserHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.todosTableView registerNib:[UINib nibWithNibName:@"UserHomeTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        if ((self.segment.selectedSegmentIndex == 0 && !self.isIncompleteLoaded) || (self.segment.selectedSegmentIndex == 1 && !self.isPastLoaded)) {
            [cell setNoImageCellWithText:@"Loading..."];
        } else {
            [cell setNoImageCellWithText:@"No to-dos to show"];
        }
        return cell;
    } else if (self.segment.selectedSegmentIndex == 0) {
        static NSString *CellIdentifier = @"incompleteCell";
        IncompleteToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.todosTableView registerNib:[UINib nibWithNibName:@"IncompleteToDoTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        ToDo *todo = [self.incompleteArray objectAtIndex:indexPath.row];
        [cell setName:todo.assignee.name andTodoTitle:todo.title andAvatarLink:todo.assignee.avatarLink andTime:[ViewHelpers getUIFriendlyDateFrom:todo.timestamp] andIsCreatedByMe:[self.user._id isEqualToString:todo.owner._id] andIsAssignedToMe:[self.user._id isEqualToString:todo.assignee._id]];
        
        // Buttons
        [cell.leftButton removeTarget:self action:@selector(todoLeftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightButton removeTarget:self action:@selector(todoRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.leftButton addTarget:self action:@selector(todoLeftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightButton addTarget:self action:@selector(todoRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"completeCell";
        CompletedToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.todosTableView registerNib:[UINib nibWithNibName:@"CompletedToDoTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        ToDo *todo = [self.pastArray objectAtIndex:indexPath.row];
        [cell setName:todo.assignee.name andMessage:todo.title andAvatarLink:todo.assignee.avatarLink andTime:[ViewHelpers getUIFriendlyDateFrom:todo.timestamp] andTimeTaken:[todo.timeTaken intValue]];
        
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

#pragma mark Interaction

- (void)segmentOptionChanged:(id)sender {
    if (!self.isPastLoaded) {
        // This is the first segment change
        
        // Reload to show loading
        [self.todosTableView reloadData];

        // Get past
        [self getPastTodos];
    } else {
        [self.todosTableView reloadData];
    }
}

- (void)todoLeftButtonClicked:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.todosTableView];
    NSIndexPath *indexPath = [self.todosTableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath) {
        ToDo *todo = [self.incompleteArray objectAtIndex:indexPath.row];
        // Can be edit, re-assign or assign to me
        if ([todo.owner._id isEqualToString:self.user._id] || [todo.assignee._id isEqualToString:self.user._id]) {
            // Edit or re-assign - go to screen
            TodoDetailsViewController *vc = [[TodoDetailsViewController alloc]initWithNibName:@"TodoDetailsViewController" bundle:nil];
            vc.type = EDIT_TYPE;
            vc.user = self.user;
            vc.house = self.house;
            vc.todo = todo;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            // Assign to me
            [TodoManager reassignToDoWithAssignee:self.user._id andToDo:todo._id withCompletion:^(ToDo *todo, NSString *error) {
                
            }];
        }
    }
}

- (void)todoRightButtonClicked:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.todosTableView];
    NSIndexPath *indexPath = [self.todosTableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath) {
        ToDo *todo = [self.incompleteArray objectAtIndex:indexPath.row];
        // Can be view or complete
        TodoDetailsViewController *vc = [[TodoDetailsViewController alloc]initWithNibName:@"TodoDetailsViewController" bundle:nil];
        vc.type = EDIT_TYPE;
        vc.user = self.user;
        vc.house = self.house;
        vc.todo = todo;
        vc.delegate = self;
        if ([todo.assignee._id isEqualToString:self.user._id]) {
            // Complete
            vc.type = COMPLETE_TYPE;
        } else {
            // View
            vc.type = VIEW_TYPE;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)addButtonClicked:(id)sender {
    TodoDetailsViewController *vc = [[TodoDetailsViewController alloc]initWithNibName:@"TodoDetailsViewController" bundle:nil];
    vc.type = CREATE_TYPE;
    vc.user = self.user;
    vc.house = self.house;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Delegate and Notifications

- (void)todoCreated:(ToDo *)todo {
    // Get from DB
    [self.incompleteArray insertObject:todo atIndex:0];
    [self reloadIfInIncomplete];
}

- (void)todoEdited:(ToDo *)todo {
    // Get from DB
    NSInteger index = [self getIndexOfTodoId:todo._id];
    if (index != -1) {
        [self.incompleteArray replaceObjectAtIndex:index withObject:todo];
        [self reloadIfInIncomplete];
    }
}

- (void)todoDeletedWithId:(NSString *)todoId {
    // Find in incomplete
    NSInteger index = [self getIndexOfTodoId:todoId];
    if (index != -1) {
        [self.incompleteArray removeObjectAtIndex:index];
        [self reloadIfInIncomplete];
    }
}

- (void)todoCompleted:(ToDo *)todo {
    // Remove from incomplete, get from DB, add to complete
    NSInteger index = [self getIndexOfTodoId:todo._id];
    if (index != -1) {
        [self.incompleteArray removeObjectAtIndex:index];
        [self reloadIfInIncomplete];
    }
    
    // Add sorted to complete
    
}

- (void)todoCreatedFromNotif:(NSNotification *)notification {
    NSString *todoId = [notification.userInfo objectForKey:@"id"];
    
    // Get from DB
    [TodoManager getTodoById:todoId withCompletion:^(ToDo *todo, NSString *error) {
        if (!error) {
            [self todoCreated:todo];
        }
    }];
}

- (void)todoEditedFromNotif:(NSNotification *)notification {
    NSString *todoId = [notification.userInfo objectForKey:@"id"];
    
    // Get from DB
    [TodoManager getTodoById:todoId withCompletion:^(ToDo *todo, NSString *error) {
        if (!error) {
            [self todoEdited:todo];
        }
    }];
    
}

- (void)todoDeletedFromNotif:(NSNotification *)notification {
    NSString *todoId = [notification.userInfo objectForKey:@"id"];
    [self todoDeletedWithId:todoId];
}

- (void)todoComletedFromNotif:(NSNotification *)notification {
    NSString *todoId = [notification.userInfo objectForKey:@"id"];
    
    // Get from DB
    [TodoManager getTodoById:todoId withCompletion:^(ToDo *todo, NSString *error) {
        if (!error) {
            [self todoCompleted:todo];
        }
    }];
}

#pragma mark Helpers

- (NSInteger)getIndexOfTodoId:(NSString *)todoId {
    ToDo *todo;
    for (NSInteger i = 0; i < self.incompleteArray.count; i++) {
        todo = [self.incompleteArray objectAtIndex:i];
        if ([todo._id isEqualToString:todoId]) {
            return i;
        }
    }
    return -1;
}

- (void)reloadIfInIncomplete {
    if (self.segment.selectedSegmentIndex == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.todosTableView reloadData];
        });
    }
}

@end
