//
//  AuthenticationManager.h
//  hh-ios
//
//  Created by Ian Richard on 12/31/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface AuthenticationManager : NSObject

+ (User *) createNewUserWithEmail: (NSString *)email andPassword:(NSString *)password andFullName:(NSString *)fullName;
+ (User *) loginUserWithEmail: (NSString *)email andPassword:(NSString *)password;

@end
