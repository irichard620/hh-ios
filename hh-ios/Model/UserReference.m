//
//  UserReference.m
//  hh-ios
//
//  Created by Ian Richard on 12/30/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "UserReference.h"

@implementation UserReference

+ (UserReference *)deserializeUserRef:(NSDictionary *)userRefDict {
    UserReference *userRef = [[UserReference alloc]init];
    userRef._id = userRefDict[@"id"];
    userRef.avatarLink = userRefDict[@"avatarLink"];
    userRef.name = userRefDict[@"fullName"];
    return userRef;
}

@end
