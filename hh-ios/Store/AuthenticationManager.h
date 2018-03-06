//
//  AuthenticationManager.h
//  hh-ios
//
//  Created by Ian Richard on 12/31/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "StoreHelpers.h"

@interface AuthenticationManager : NSObject

+ (void)createNewUserWithEmail: (NSString *)email andPassword:(NSString *)password andFullName:(NSString *)fullName withCompletion:(void(^)(User *user, NSString *error))completion;
+ (void)loginUserWithEmail:(NSString *)email andPassword:(NSString *)password withCompletion:(void (^)(User *user, NSString *error))completion;
+ (NSString *)getCurrentAccessToken;
+ (NSString *)getCurrentTwilioAccessToken;
+ (void)logout;

@end
