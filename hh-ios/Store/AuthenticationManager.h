//
//  AuthenticationManager.h
//  hh-ios
//
//  Created by Ian Richard on 12/31/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

extern NSString * const UNKNOWN_ERROR;
extern NSString * const NOT_FOUND_ERROR;
extern NSString * const CONNECTION_ERROR;
extern NSString * const MISSING_INFO_ERROR;

@interface AuthenticationManager : NSObject

+ (void) createNewUserWithEmail: (NSString *)email andPassword:(NSString *)password andFullName:(NSString *)fullName withCompletion:(void(^)(User *user, NSString *error))completion;
+ (void)loginUserWithEmail:(NSString *)email andPassword:(NSString *)password withCompletion:(void (^)(User *user, NSString *error))completion;

@end
