//
//  User.m
//  hh-ios
//
//  Created by Ian Richard on 12/31/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "User.h"

@implementation User

+ (User *)deserializeUser:(NSDictionary *)userJson {
    User *user = [[User alloc]init];
    user._id = userJson[@"id"];
    user.avatarLink = userJson[@"avatarLink"];
    user.email = userJson[@"email"];
    user.fullName = userJson[@"fullName"];
    user.accessToken = userJson[@"access_token"];
    
    return user;
}

@end
