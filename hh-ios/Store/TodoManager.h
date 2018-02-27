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
+ (void)createToDoWithAssignee:(NSString *)assigneeId andHouseId:(NSString *)houseId andTitle:(NSString *)title andDescription:(NSString *)todoDescription andCreator:(User *)creator withCompletion:(void (^)(ToDo *todo, NSString *error))completion;

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
+ (void)reassignToDoWithAssignee:(NSString *)assigneeId andToDo:(NSString *)todoId andEditingUser:(User *)editingUser withCompletion:(void(^)(ToDo *todo, NSString *error))completion;

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
+ (void)completeToDoWithUser:(User *)completingUser andToDo:(NSString *)todoId andTimeTaken:(NSNumber *)timeTaken withCompletion:(void(^)(ToDo *todo, NSString *error))completion;

/*
 * Get todos assigned to user
 *
 * Arguments:
 * user
 *
 * Return:
 * Array of todo objects
 */
+ (void)getTodosAssignedToMe:(User *)user withCompletion:(void(^)(NSArray *todos, NSString *error))completion;

@end
