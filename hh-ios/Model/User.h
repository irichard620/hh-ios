//
//  User.h
//  hh-ios
//
//  Created by Ian Richard on 12/31/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

// unique ID of the user
@property (strong, nonatomic) NSString *_id;

// Pic
@property (nonatomic) NSString *avatarLink;

// Email
@property (strong, nonatomic) NSString *email;

// Display name
@property (strong, nonatomic) NSString *fullName;

+ (User *) deserializeUser: (NSDictionary *)userJson isLogin:(BOOL)isLogin;

@end
