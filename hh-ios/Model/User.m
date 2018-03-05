//
//  User.m
//  hh-ios
//
//  Created by Ian Richard on 12/31/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "User.h"
#import <A0SimpleKeychain.h>

@implementation User

+ (User *)deserializeUser:(NSDictionary *)userJson isLogin:(BOOL)isLogin {
    User *user = [[User alloc]init];
    user._id = userJson[@"id"];
    user.avatarLink = userJson[@"avatar_link"];
    user.email = userJson[@"email"];
    user.fullName = userJson[@"full_name"];
    
    if (isLogin) {
        NSDictionary *authDict = @{
                                   @"access_token": userJson[@"access_token"],
                                   @"expires_in": userJson[@"expires_in"]
                                   };
        [User deserializeAuthInfo:authDict];
    }
    
    return user;
}

+ (void)deserializeAuthInfo:(NSDictionary *)authJson {
    NSString *accessToken = authJson[@"acess_token"];
    NSNumber *seconds = authJson[@"expires_in"];
    
    // Save access token to keychain
    [[A0SimpleKeychain keychain]setString:accessToken forKey:@"auth0-token-jwt"];
    
    // Save expiration to user defaults
    NSDate *currentDate = [NSDate date];
    NSDate *expirationDate = [currentDate dateByAddingTimeInterval:[seconds intValue]];
    [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:@"auth0-token-expiration"];
}

@end
