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

#define TRIM(string) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

@interface TodoDetailsViewController ()

// KEep track of data
@property(nonatomic) NSMutableArray *dataArray;
@property(nonatomic) BOOL dataLoading;
@property(nonatomic) NSInteger selectedIndex;

// Keep track of inputs
@property(nonatomic) BOOL titleChanged;
@property(nonatomic) NSString *currentTitle;
@property(nonatomic) BOOL descrChanged;
@property(nonatomic) NSString *currentDescr;
@property(nonatomic) BOOL assigneeChanged;

// Bar button
@property(nonatomic) UIBarButtonItem *rightBarButton;

@end

@implementation TodoDetailsViewController

- (void)shouldDealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [[NSMutableArray alloc]init];
        _dataLoading = YES;
        _selectedIndex = 0;
        _titleChanged = NO;
        _descrChanged = NO;
        _assigneeChanged = NO;
        
        // Notifications
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(todoDeleted:) name:DELETE_TODO_MESSAGE object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(todoComleted:) name:COMPLETE_TODO_MESSAGE object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.00 green:0.59 blue:0.53 alpha:1.0];
    NSString *rightButtonTitle;
    if (self.type == CREATE_TYPE) {
        self.navigationItem.title = @"Create To-Do";
        rightButtonTitle = @"Create";
    } else if (self.type == EDIT_TYPE) {
        self.navigationItem.title = @"Edit To-Do";
        rightButtonTitle = @"Save";
    } else if (self.type == VIEW_TYPE) {
        self.navigationItem.title = @"To-Do Details";
        rightButtonTitle = @"Edit";
    } else {
        self.navigationItem.title = @"Complete To-Do";
        rightButtonTitle = @"Complete";
    }
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    // Create menu button
    self.navigationItem.leftBarButtonItem = [ViewHelpers createNavButtonWithTarget:self andSelectorName:@"backButtonClicked:" andImage:[UIImage imageNamed:@"left-arrow.png"] isBack:YES];
    
    // Right bar button
    self.rightBarButton = [ViewHelpers createTextNavButtonWithTarget:self andSelectorName:@"rightBarButtonClicked:" andTitle:rightButtonTitle];
    if (self.type != VIEW_TYPE && self.type != COMPLETE_TYPE) self.rightBarButton.enabled = NO;
    if ([self.todo.owner._id isEqualToString:self.user._id]) {
        UIBarButtonItem *deleteButton = [ViewHelpers createTextNavButtonWithTarget:self andSelectorName:@"deleteButtonClicked:" andTitle:@"Delete"];
        self.navigationItem.rightBarButtonItems = @[deleteButton, self.rightBarButton];
    } else {
        self.navigationItem.rightBarButtonItems = @[self.rightBarButton];
    }
    
    // Setup table
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    if (self.type == CREATE_TYPE || self.type == EDIT_TYPE) {
        [self getPreferredListOfAssignees];
    } else if (self.type == COMPLETE_TYPE) {
        [self getListOfTimes];
    } else  {
        self.dataLoading = NO;
        [self.tableView reloadData];
    }
}

#pragma mark Data

- (void)getPreferredListOfAssignees {
    [TodoManager getTodoAssignees:self.house.uniqueName withCompletion:^(NSArray *users, NSString *error) {
        if (!error) {
            for (int i = 0; i < users.count; i++) {
                UserReference *ref = (UserReference *)[users objectAtIndex:i];
                if ([ref._id isEqualToString:self.todo.assignee._id]) {
                    self.selectedIndex = i;
                }
                [self.dataArray addObject:ref];
            }
        }
        self.dataLoading = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)getListOfTimes {
    [self.dataArray addObjectsFromArray:@[@"5", @"10", @"15", @"30", @"45", @"60", @"90", @"120", @"240"]];
    self.dataLoading = NO;
    [self.tableView reloadData];
}

#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == VIEW_TYPE) {
        return 2;
    } else {
        if (self.dataLoading || self.dataArray.count == 0) {
            return 2;
        } else {
            return 1 + self.dataArray.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // If create
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"detailsCell";
        TodoDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:@"TodoDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        if (self.type == CREATE_TYPE) {
            [cell setupForCreateWithCreatedBy:self.user.fullName];
            [cell.titleField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [cell.titleField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.descrTextView.delegate = self;
        } else if (self.type == EDIT_TYPE) {
            if (![self.user._id isEqualToString:self.todo.owner._id]) {
                [cell setupForViewWithTitle:self.todo.title andDescr:self.todo.todoDescription andCreatedBy:self.todo.owner.name];
            } else {
                [cell setupForEditWithTitle:self.todo.title andDescr:self.todo.todoDescription andCreatedBy:self.todo.owner.name];
                [cell.titleField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                [cell.titleField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                cell.descrTextView.delegate = self;
            }
        } else if (self.type == VIEW_TYPE) {
            [cell setupForViewWithTitle:self.todo.title andDescr:self.todo.todoDescription andCreatedBy:self.todo.owner.name];
        } else {
            [cell setupForCompleteWithTitle:self.todo.title andDescr:self.todo.todoDescription andCreatedBy:self.todo.owner.name];
        }
        return cell;
    } else {
        static NSString *CellIdentifier = @"userCell";
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            [self.tableView registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        if (self.dataLoading) {
            [cell setNoImageCellWithText:@"Loading"];
        } else if (self.type == VIEW_TYPE) {
            [cell setName:self.todo.assignee.name andAvatarLink:self.todo.assignee.avatarLink];
        } else if (self.dataArray.count == 0) {
            [cell setNoImageCellWithText:@"No assignees to show"];
        } else {
            if (self.type == COMPLETE_TYPE) {
                NSString *timeString = [self.dataArray objectAtIndex:indexPath.row - 1];
                if ([timeString isEqualToString:@"60"]) {
                    [cell setNoImageCellWithText:@"1 hour"];
                } else if ([timeString isEqualToString:@"120"]) {
                    [cell setNoImageCellWithText:@"2 hours"];
                } else if ([timeString isEqualToString:@"240"]) {
                    [cell setNoImageCellWithText:@"4 hours"];
                } else {
                    [cell setNoImageCellWithText:[NSString stringWithFormat:@"%@ minutes",timeString]];
                }
            } else {
                UserReference *ref = [self.dataArray objectAtIndex:indexPath.row - 1];
                [cell setName:ref.name andAvatarLink:ref.avatarLink];
            }
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == VIEW_TYPE || self.dataLoading || self.dataArray.count == 0) {
        return;
    }
    if (self.selectedIndex + 1 == indexPath.row) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell setSelected:YES];
    }
}

#pragma mark Text view

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.textColor isEqual:[UIColor lightGrayColor]]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([TRIM(textView.text) isEqualToString:@""]) {
        textView.text = @"";
        textView.textColor = [UIColor lightGrayColor];
        self.descrChanged = NO;
    }
}

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

    NSString *text = TRIM(textView.text);
    self.currentDescr = text;
    if (self.type == CREATE_TYPE && [text isEqualToString:@""]) {
        self.descrChanged = NO;
    } else if (self.type == EDIT_TYPE && ([text isEqualToString:self.todo.title] || [text isEqualToString:@""])) {
        self.descrChanged = NO;
    } else {
        self.descrChanged = YES;
    }
    [self updateButton];
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSString *text = TRIM(textField.text);
    self.currentTitle = text;
    if (self.type == CREATE_TYPE && [text isEqualToString:@""]) {
        self.titleChanged = NO;
    } else if (self.type == EDIT_TYPE && ([text isEqualToString:self.todo.title] || [text isEqualToString:@""])) {
        self.titleChanged = NO;
    } else {
        self.titleChanged = YES;
    }
    [self updateButton];
}

- (void)updateButton {
    if (self.type == CREATE_TYPE) {
        if (self.titleChanged && self.descrChanged) {
            [self.rightBarButton setEnabled:YES];
        } else {
            [self.rightBarButton setEnabled:NO];
        }
    } else if (self.type == EDIT_TYPE) {
        if (self.titleChanged || self.descrChanged || self.assigneeChanged) {
            [self.rightBarButton setEnabled:YES];
        } else {
            [self.rightBarButton setEnabled:NO];
        }
    }
}

#pragma mark Interaction

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return nil;
    } else if (self.dataLoading || self.dataArray.count == 0) {
        return nil;
    } else {
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndex != indexPath.row - 1) {
        // Different index
        // Deselect currently selected
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex + 1 inSection:0]]setSelected:NO];
        self.selectedIndex = indexPath.row - 1;
    }
    if (self.type != COMPLETE_TYPE) {
        UserReference *ref = (UserReference *)[self.dataArray objectAtIndex:self.selectedIndex];
        if (![ref._id isEqualToString:self.todo.assignee._id]) {
            self.assigneeChanged = YES;
        } else {
            self.assigneeChanged = NO;
        }
    }
}

- (void)backButtonClicked:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)rightBarButtonClicked:(id)sender {
    if (self.type == CREATE_TYPE) {
        // Create new todo
        [self createTodo];
    } else if (self.type == EDIT_TYPE) {
        // Save new data
        [self saveTodo];
    } else if (self.type == VIEW_TYPE) {
        [self startEditingTodo];
    } else {
        // Complete
        [self completeTodo];
    }
}

- (void)deleteButtonClicked:(id)sender {
    [TodoManager deleteToDoWithId:self.todo._id withCompletion:^(NSString *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:error] animated:YES completion:nil];
            });
        } else {
            // Get ID
            [self.delegate todoDeletedWithId:self.todo._id];
            [self backButtonClicked:nil];
        }
    }];
}

#pragma DB interaction

- (void)createTodo {
    NSString *assigneeId = [(UserReference *)[self.dataArray objectAtIndex:self.selectedIndex]_id];
    [TodoManager createToDoWithAssignee:assigneeId andHouseId:self.house.uniqueName andTitle:self.currentTitle andDescription:self.currentDescr withCompletion:^(ToDo *todo, NSString *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:error] animated:YES completion:nil];
            });
        } else {
            // Get ID
            [self.delegate todoCreated:todo];
            [self backButtonClicked:nil];
        }
    }];
}

- (void)saveTodo {
    NSString *title;
    NSString *descr;
    if (self.titleChanged) {
        title = self.currentTitle;
    } else {
        title = nil;
    }
    if (self.descrChanged) {
        descr = self.currentDescr;
    } else {
        descr = nil;
    }
    NSLog(@"ID: %@", self.todo._id);
    [TodoManager editToDoWithId:self.todo._id withTitle:title andDescription:descr withCompletion:^(ToDo *todo, NSString *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:error] animated:YES completion:nil];
            });
        } else {
            if (self.assigneeChanged) {
                NSString *newId = [(UserReference *)[self.dataArray objectAtIndex:self.selectedIndex] _id];
                [TodoManager reassignToDoWithAssignee:newId andToDo:self.todo._id withCompletion:^(ToDo *todo, NSString *error) {
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:error] animated:YES completion:nil];
                        });
                    } else {
                        [self.delegate todoEdited:todo];
                        [self backButtonClicked:nil];
                    }
                }];
            } else {
                [self.delegate todoEdited:todo];
                [self backButtonClicked:nil];
            }
        }
    }];
}

- (void)startEditingTodo {
    // Switch to edit
    self.navigationItem.title = @"Edit To-Do";
    
    // Right bar button
    self.rightBarButton = [ViewHelpers createTextNavButtonWithTarget:self andSelectorName:@"rightBarButtonClicked:" andTitle:@"Save"];
    self.rightBarButton.enabled = NO;
    if ([self.todo.owner._id isEqualToString:self.user._id]) {
        UIBarButtonItem *deleteButton = [ViewHelpers createTextNavButtonWithTarget:self andSelectorName:@"deleteButtonClicked:" andTitle:@"Delete"];
        self.navigationItem.rightBarButtonItems = @[deleteButton, self.rightBarButton];
    } else {
        self.navigationItem.rightBarButtonItems = @[self.rightBarButton];
    }
    
    // Need to get preferred assignees and reload table
    self.type = EDIT_TYPE;
    self.dataLoading = YES;
    [self.tableView reloadData];
    
    [self getPreferredListOfAssignees];
}

- (void)completeTodo {
    NSString *time = [self.dataArray objectAtIndex:self.selectedIndex];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *timeNum = [f numberFromString:time];
    
    [TodoManager completeToDo:self.todo._id andTimeTaken:timeNum withCompletion:^(ToDo *todo, NSString *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:[ViewHelpers createErrorAlertWithTitle:@"Error" andDescription:error] animated:YES completion:nil];
            });
        } else {
            // Go back
            [self.delegate todoCompleted:todo];
            [self backButtonClicked:nil];
        }
    }];
}

#pragma mark Notifications

- (void)todoDeleted:(NSNotification *)notification {
    NSString *todoId = [notification.userInfo objectForKey:@"id"];
    if (self.type != CREATE_TYPE && [todoId isEqualToString:self.todo._id]) {
        // Deleted
        [self backButtonClicked:nil];
    }
}

- (void)todoComleted:(NSNotification *)notification {
    NSString *todoId = [notification.userInfo objectForKey:@"id"];
    if (self.type != CREATE_TYPE && [todoId isEqualToString:self.todo._id]) {
        // Completed
        [self backButtonClicked:nil];
    }
}

@end
