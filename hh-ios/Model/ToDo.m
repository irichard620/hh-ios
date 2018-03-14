//
//  ToDo.m
//  hh-ios
//
//  Created by Ian Richard on 2/13/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "ToDo.h"
#import "NSString+Security.h"

@implementation ToDo

+ (ToDo *)deserializeTodo:(NSDictionary *)todoDict {
    ToDo *todo = [[ToDo alloc]init];
    todo.owner = [UserReference deserializeUserRef:todoDict[@"owner"]];
    todo.assignee = [UserReference deserializeUserRef:todoDict[@"assignee"]];
    todo.houseId = todoDict[@"house"];
    todo.title = todoDict[@"title"];
    todo.todoDescription = todoDict[@"description"];
    todo.complete = [[NSNumber numberWithBool:todoDict[@"complete"]]boolValue];
    todo.timeTaken = [NSNumber numberWithInteger:[todoDict[@"time_taken"]integerValue]];
    todo.timestamp = [todoDict[@"timestamp"] getDateFromString];
    
    return todo;
}

@end
