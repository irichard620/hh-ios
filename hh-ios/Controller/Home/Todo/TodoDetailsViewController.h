//
//  TodoDetailsViewController.h
//  hh-ios
//
//  Created by Ian Richard on 2/20/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoManager.h"
#import "House.h"

@protocol TodoDetailsDelegate;

#define CREATE_TYPE 0 // Title and description as fields, default assignee selected with list of options
#define VIEW_TYPE 1 // Title and description and assignee - no list of options - edit in top right
#define EDIT_TYPE 2 // Title and description as fields if owner, assignee list of options
#define COMPLETE_TYPE 3 // Title only, list of time options
#define VIEW_COMPLETED_TYPE 4 // Title, description, created by, completed by, time taken - no edit

@interface TodoDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// PAss in variables
@property (nonatomic) User *user;
@property (nonatomic) ToDo *todo;
@property (nonatomic) House *house;
@property (nonatomic) NSInteger type;

@property (weak, nonatomic) id<TodoDetailsDelegate> delegate;
@end
@protocol TodoDetailsDelegate <NSObject>

- (void)todoCreated:(ToDo *)todo;
- (void)todoEdited:(ToDo *)todo;
- (void)todoDeletedWithId:(NSString *)todoId;
- (void)todoCompleted:(ToDo *)todo;

@end
