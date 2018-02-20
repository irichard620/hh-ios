//
//  TodoManager.m
//  hh-ios
//
//  Created by Ian Richard on 2/19/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "TodoManager.h"
#import <UNIRest.h>

@implementation TodoManager

+ (void)createToDoWithAssignee:(NSString *)assigneeId andHouseId:(NSString *)houseId andTitle:(NSString *)title andDescription:(NSString *)todoDescription andCreator:(User *)creator withCompletion:(void (^)(ToDo *, NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", creator.accessToken]};
    
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
                NSDictionary *responseDict = jsonResponse.body.JSONObject;
                ToDo *todo = [ToDo deserializeTodo:responseDict];
                completion(todo, nil);
            } else {
                completion(nil, @"Unknown");
            }
        } else {
            completion(nil, error.localizedDescription);
        }
    }];
}

+ (void)reassignToDoWithAssignee:(NSString *)assigneeId andToDo:(NSString *)todoId andEditingUser:(User *)editingUser withCompletion:(void (^)(ToDo *, NSString *))completion  {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", editingUser.accessToken]};
    
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
                NSDictionary *responseDict = jsonResponse.body.JSONObject;
                ToDo *todo = [ToDo deserializeTodo:responseDict];
                completion(todo, nil);
            } else {
                completion(nil, @"Unknown");
            }
        } else {
            completion(nil, error.localizedDescription);
        }
    }];
}

+ (void)completeToDoWithUser:(User *)completingUser andToDo:(NSString *)todoId withCompletion:(void (^)(ToDo *, NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", completingUser.accessToken]};
    
    // Pass assignee, todo id
    NSDictionary* parameters = @{@"id": todoId, @"time_taken": };
    
    // Create post request to /api/todos/complete
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/todos/complete"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 201) {
                // If no error, get json response and deserialize to todo object
                NSDictionary *responseDict = jsonResponse.body.JSONObject;
                ToDo *todo = [ToDo deserializeTodo:responseDict];
                completion(todo, nil);
            } else {
                completion(nil, @"Unknown");
            }
        } else {
            completion(nil, error.localizedDescription);
        }
    }];
}

@end
