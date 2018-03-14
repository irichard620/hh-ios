//
//  TodoManager.h
//  hh-ios
//
//  Created by Ian Richard on 2/19/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDo.h"
#import "User.h"
#import "StoreHelpers.h"

@interface TodoManager : NSObject

/*
 * Create To-do
 *
 * Arguments:
 * assigneeId - id of person to assign to
 * houseId - ID of house to link to
 * title - title of todo
 * todoDescription - description of todo
 * creator - user object of creator
 *
 * Return:
 * Todo that was created
 */
+ (void)createToDoWithAssignee:(NSString *)assigneeId andHouseId:(NSString *)houseId andTitle:(NSString *)title andDescription:(NSString *)todoDescription withCompletion:(void (^)(ToDo *todo, NSString *error))completion;

/*
 * Edit To-do
 *
 * Arguments:
 * todoId - id of todo to edit
 * title - title of todo
 * todoDescription - description of todo
 *
 * Return:
 * Todo that was updated
 */
+ (void)editToDoWithId:(NSString *)todoId withTitle:(NSString *)title andDescription:(NSString *)todoDescription withCompletion:(void (^)(ToDo *todo, NSString *error))completion;

/*
 * Delete To-do
 *
 * Arguments:
 * todoId - id of todo to delete
 *
 * Return:
 * Success code
 */
+ (void)deleteToDoWithId:(NSString *)todoId withCompletion:(void (^)(NSString *error))completion;

/*
 * Re-assign To-do
 *
 * Arguments:
 * assigneeId - id of person to assign to
 * todoId - ID of todo
 * editingUser - user object of editor
 *
 * Return:
 * todo
 */
+ (void)reassignToDoWithAssignee:(NSString *)assigneeId andToDo:(NSString *)todoId withCompletion:(void(^)(ToDo *todo, NSString *error))completion;

/*
 * Complete To-do
 *
 * Arguments:
 * completingUser - user object of completor
 * todoId - ID of todo
 *
 * Return:
 * todo
 */
+ (void)completeToDo:(NSString *)todoId andTimeTaken:(NSNumber *)timeTaken withCompletion:(void(^)(ToDo *todo, NSString *error))completion;


/*
 * Get todos for a house
 *
 * Arguments:
 * unique name of house
 *
 * Return:
 * Array of todo objects
 */
+ (void)getTodosForHouseWithName:(NSString *)uniqueName withCompletion:(void(^)(NSArray *todos, NSString *error))completion;

/*
 * Get past (completed) todos for a house
 *
 * Arguments:
 * unique name of house
 *
 * Return:
 * Array of todo objects
 */
+ (void)getPastTodosForHouseWithName:(NSString *)uniqueName withCompletion:(void(^)(NSArray *todos, NSString *error))completion;

/*
 * Get list of potential assignees by time contribution
 *
 * Arguments:
 * unique name of house
 *
 * Return:
 * Array of user ref objects
 */
+ (void)getTodoAssignees:(NSString *)uniqueName withCompletion:(void(^)(NSArray *users, NSString *error))completion;

/*
 * Get todo by ID
 *
 * Arguments:
 * id of todo
 *
 * Return:
 * Todo object
 */
+ (void)getTodoById:(NSString *)todoId withCompletion:(void(^)(ToDo *todo, NSString *error))completion;

@end
