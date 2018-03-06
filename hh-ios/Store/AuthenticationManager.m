//
//  AuthenticationManager.m
//  hh-ios
//
//  Created by Ian Richard on 12/31/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "AuthenticationManager.h"
#import <UNIRest.h>
#import "NSString+Security.h"
#import <A0SimpleKeychain.h>

@implementation AuthenticationManager

+ (void)createNewUserWithEmail:(NSString *)email andPassword:(NSString *)password andFullName:(NSString *)fullName withCompletion:(void (^)(User *, NSString *))completion {
    // First, send request to register user with email, name, and hashed password
    NSString *hashedPassword = [password createSHA512];
    NSDictionary* parameters = @{@"email": email, @"name": fullName, @"password": hashedPassword };
    [StoreHelpers sendPostRequestWithEndpoint:@"/auth/register" requiresAuth:NO hasParameters:parameters withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            [AuthenticationManager loginUserWithEmail:email andPassword:password withCompletion:^(User *user, NSString *error) {
                completion(user, nil);
            }];
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)loginUserWithEmail:(NSString *)email andPassword:(NSString *)password withCompletion:(void (^)(User *, NSString *))completion {
    NSString *hashedPassword = [password createSHA512];
    NSDictionary *parameters = @{@"email": email, @"password": hashedPassword };
    [StoreHelpers sendPostRequestWithEndpoint:@"/auth/login" requiresAuth:NO hasParameters:parameters withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            // If no error, get json response and deserialize to user object
            User *user = [User deserializeUser:jsonResponse[@"response"] isLogin:YES];
            completion(user, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (NSString *)getCurrentAccessToken {
    NSString *jwt = [[A0SimpleKeychain keychain] stringForKey:@"auth0-token-jwt"];
    if (!jwt) return nil;
    else {
        if ([self tokenNeedsRefresh]) {
            [[A0SimpleKeychain keychain] deleteEntryForKey:@"auth0-token-jwt"];
            return nil;
        } else {
            return jwt;
        }
    }
}

+ (NSString *)getCurrentTwilioAccessToken {
    return [[A0SimpleKeychain keychain] stringForKey:@"twilio-token-jwt"];
}

+ (BOOL)tokenNeedsRefresh {
    NSDate *now = [NSDate date];
    NSDate *expirationDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"auth0-token-expiration"];
    if ([now compare:expirationDate] == NSOrderedAscending) {
        // expiration in the past - must logout
        return YES;
    } else {
        NSTimeInterval secondsBetween = [expirationDate timeIntervalSinceDate:now];
        int numberOfHours = secondsBetween / 60;
        if (numberOfHours < 12) {
            // If less than half a day to expiration - reset
            return YES;
        } else {
            return NO;
        }
    }
}

+ (void)logout {
    [[A0SimpleKeychain keychain] deleteEntryForKey:@"auth0-token-jwt"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"auth0-token-expiration"];
}

@end
