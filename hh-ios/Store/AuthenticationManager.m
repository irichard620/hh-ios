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

+ (void)createNewUserWithEmail:(NSString *)email andPassword:(NSString *)password andFullName:(NSString *)fullName andDeviceToken:(NSString *)deviceToken withCompletion:(void (^)(User *, NSString *))completion {
    // First, send request to register user with email, name, and hashed password
//    NSString *hashedPassword = [password createSHA512];
    NSDictionary* parameters;
    if (deviceToken) {
        parameters = @{@"email": email, @"name": fullName, @"password": password, @"device_token": deviceToken };
    } else {
        parameters = @{@"email": email, @"name": fullName, @"password": password };
    }
    
    [StoreHelpers sendPostRequestWithEndpoint:@"/auth/register" requiresAuth:NO hasParameters:parameters withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            [AuthenticationManager loginUserWithEmail:email andPassword:password andDeviceToken:deviceToken withCompletion:^(User *user, NSString *error) {
                completion(user, error);
            }];
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)loginUserWithEmail:(NSString *)email andPassword:(NSString *)password andDeviceToken:(NSString *)deviceToken withCompletion:(void (^)(User *, NSString *))completion {
//    NSString *hashedPassword = [password createSHA512];
    NSDictionary* parameters;
    if (deviceToken) {
        parameters = @{@"email": email, @"password": password, @"device_token": deviceToken };
    } else {
        parameters = @{@"email": email, @"password": password };
    }
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

+ (void)getTwilioAccessTokenWithCompletion:(void (^)(NSString *, NSString *))completion {
    [StoreHelpers sendGetRequestWithEndpoint:@"/auth/twilio" requiresAuth:YES withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            NSString *twilioToken = [User deserializeTwilio:jsonResponse[@"response"]];
            completion(twilioToken, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (NSString *)getCurrentAccessToken {
    NSString *jwt = [[A0SimpleKeychain keychain] stringForKey:@"auth0-token-jwt"];
    if (!jwt) {
        NSLog(@"No token saved");
        return nil;
    } else {
        if ([self tokenNeedsRefresh]) {
            NSLog(@"Token needs refresh");
            [[A0SimpleKeychain keychain] deleteEntryForKey:@"auth0-token-jwt"];
            return nil;
        } else {
            NSLog(@"Token is live");
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
        NSTimeInterval secondsBetween = [expirationDate timeIntervalSinceDate:now];
        int numberOfHours = secondsBetween / 60;
        if (numberOfHours < 12) {
            // If less than half a day to expiration - reset
            return YES;
        } else {
            return NO;
        }
        return YES;
    } else {
        return YES;
    }
}

+ (void)logout {
    [[A0SimpleKeychain keychain] deleteEntryForKey:@"auth0-token-jwt"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"auth0-token-expiration"];
}

@end
