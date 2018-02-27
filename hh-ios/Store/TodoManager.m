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
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
    
    // Pass assignee, house id, title, description
    NSDictionary* parameters = @{@"assignee": assigneeId, @"house": houseId, @"title": title, @"description": todoDescription};
    
    // Create post request to /api/todos/create
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/todos/create"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 201) {
                // If no error, get json response and deserialize to todo object
                NSDictionary *responseDict = jsonResponse.body.JSONObject[@"response"];
                ToDo *todo = [ToDo deserializeTodo:responseDict];
                completion(todo, nil);
            } else {
                completion(nil, UNKNOWN_ERROR);
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            completion(nil, UNKNOWN_ERROR);
        }
    }];
}

+ (void)reassignToDoWithAssignee:(NSString *)assigneeId andToDo:(NSString *)todoId withCompletion:(void (^)(ToDo *, NSString *))completion  {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
    
    // Pass assignee, todo id
    NSDictionary* parameters = @{@"id": todoId, @"assignee": assigneeId};
    
    // Create post request to /api/todos/reassign
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/todos/reassign"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 201) {
                // If no error, get json response and deserialize to todo object
                NSDictionary *responseDict = jsonResponse.body.JSONObject[@"response"];
                ToDo *todo = [ToDo deserializeTodo:responseDict];
                completion(todo, nil);
            } else {
                completion(nil, UNKNOWN_ERROR);
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            completion(nil, UNKNOWN_ERROR);
        }
    }];
}

+ (void)completeToDo:(NSString *)todoId andTimeTaken:(NSNumber *)timeTaken withCompletion:(void (^)(ToDo *, NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
    
    // Pass assignee, todo id
    NSDictionary* parameters = @{@"id": todoId, @"time_taken": timeTaken};
    
    // Create post request to /api/todos/complete
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/todos/complete"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 201) {
                // If no error, get json response and deserialize to todo object
                NSDictionary *responseDict = jsonResponse.body.JSONObject[@"response"];
                ToDo *todo = [ToDo deserializeTodo:responseDict];
                completion(todo, nil);
            } else {
                completion(nil, UNKNOWN_ERROR);
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            completion(nil, UNKNOWN_ERROR);
        }
    }];
}

+ (void)getTodosAssignedToMeWithCompletion:(void (^)(NSArray *, NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
    
    
    // Create get request to /api/todos/assigned
    [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/todos/assigned"];
        [request setHeaders:headers];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 200) {
                // If no error, get json response and deserialize to todo object
                NSDictionary *responseDict = jsonResponse.body.JSONObject;
                NSArray *responseArray = responseDict[@"todos"];
                NSMutableArray *todosArray = [[NSMutableArray alloc]init];
                for (int i = 0; i < responseArray.count; i++) {
                    [todosArray addObject:[ToDo deserializeTodo:responseArray[i]]];
                }
                completion(todosArray, nil);
            } else {
                completion(nil, UNKNOWN_ERROR);
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            completion(nil, UNKNOWN_ERROR);
        }
    }];
}

@end
