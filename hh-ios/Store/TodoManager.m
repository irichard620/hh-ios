//
//  TodoManager.m
//  hh-ios
//
//  Created by Ian Richard on 2/19/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "TodoManager.h"
#import <UNIRest.h>
#import "AuthenticationManager.h"

@implementation TodoManager

+ (void)createToDoWithAssignee:(NSString *)assigneeId andHouseId:(NSString *)houseId andTitle:(NSString *)title andDescription:(NSString *)todoDescription withCompletion:(void (^)(ToDo *, NSString *))completion {
    // Pass assignee, house id, title, description
    NSDictionary* parameters = @{@"assignee": assigneeId, @"unique_name": houseId, @"title": title, @"description": todoDescription};
    
    // Send request
    [StoreHelpers sendPostRequestWithEndpoint:@"/todos/create" requiresAuth:YES hasParameters:parameters withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            // If no error, get json response and deserialize to todo object
            ToDo *todo = [ToDo deserializeTodo:jsonResponse[@"response"]];
            completion(todo, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)editToDoWithId:(NSString *)todoId withTitle:(NSString *)title andDescription:(NSString *)todoDescription withCompletion:(void (^)(ToDo *, NSString *))completion {
    // Params
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setObject:todoId forKey:@"todo_id"];
    if (!title && !todoDescription) {
        completion(nil, MISSING_INFO_ERROR);
        return;
    }
    if (title) [parameters setObject:title forKey:@"title"];
    if (todoDescription) [parameters setObject:todoDescription forKey:@"description"];
    
    // Send request
    [StoreHelpers sendPutRequestWithEndpoint:@"/todos/edit" requiresAuth:YES hasParameters:parameters withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            // If no error, get json response and deserialize to todo object
            ToDo *todo = [ToDo deserializeTodo:jsonResponse[@"response"]];
            completion(todo, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)deleteToDoWithId:(NSString *)todoId withCompletion:(void (^)(NSString *))completion {
    [StoreHelpers sendDeleteRequestWithEndpoint:[NSString stringWithFormat:@"/todos/%@", todoId] requiresAuth:YES withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        completion(errorType);
    }];
}

+ (void)reassignToDoWithAssignee:(NSString *)assigneeId andToDo:(NSString *)todoId withCompletion:(void (^)(ToDo *, NSString *))completion  {
    // Pass assignee, todo id
    NSDictionary* parameters = @{@"todo_id": todoId, @"assignee": assigneeId};
    
    [StoreHelpers sendPutRequestWithEndpoint:@"/todos/reassign" requiresAuth:YES hasParameters:parameters withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            // If no error, get json response and deserialize to todo object
            ToDo *todo = [ToDo deserializeTodo:jsonResponse[@"response"]];
            completion(todo, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)completeToDo:(NSString *)todoId andTimeTaken:(NSNumber *)timeTaken withCompletion:(void (^)(ToDo *, NSString *))completion {
    // Pass assignee, todo id
    NSDictionary* parameters = @{@"todo_id": todoId, @"time": timeTaken};
    
    [StoreHelpers sendPutRequestWithEndpoint:@"/todos/complete" requiresAuth:YES hasParameters:parameters withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            // If no error, get json response and deserialize to todo object
            ToDo *todo = [ToDo deserializeTodo:jsonResponse[@"response"]];
            completion(todo, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)getTodosForHouseWithName:(NSString *)uniqueName withCompletion:(void (^)(NSArray *, NSString *))completion {
    // Send request
    [StoreHelpers sendGetRequestWithEndpoint:[NSString stringWithFormat:@"/todos/%@",uniqueName] requiresAuth:YES withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            // If no error, get json response and deserialize to todo object
            NSArray *responseArray = jsonResponse[@"todos"];
            NSMutableArray *todosArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < responseArray.count; i++) {
                [todosArray addObject:[ToDo deserializeTodo:responseArray[i]]];
            }
            completion(todosArray, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)getPastTodosForHouseWithName:(NSString *)uniqueName withCompletion:(void(^)(NSArray *todos, NSString *error))completion {
    [StoreHelpers sendGetRequestWithEndpoint:[NSString stringWithFormat:@"/todos/%@/complete",uniqueName] requiresAuth:YES withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            // If no error, get json response and deserialize to todo object
            NSArray *responseArray = jsonResponse[@"todos"];
            NSMutableArray *todosArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < responseArray.count; i++) {
                [todosArray addObject:[ToDo deserializeTodo:responseArray[i]]];
            }
            completion(todosArray, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)getTodoAssignees:(NSString *)uniqueName withCompletion:(void(^)(NSArray *users, NSString *error))completion {
    [StoreHelpers sendGetRequestWithEndpoint:[NSString stringWithFormat:@"/todos/%@/assignee", uniqueName] requiresAuth:YES withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            // If no error, get json response and deserialize to user ref objects
            NSArray *responseArray = jsonResponse[@"users"];
            NSMutableArray *userArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < responseArray.count; i++) {
                [userArray addObject:[UserReference deserializeUserRef:responseArray[i]]];
            }
            completion(userArray, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

@end
