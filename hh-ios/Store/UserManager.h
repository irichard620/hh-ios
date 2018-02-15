//
//  UserManager.h
//  hh-ios
//
//  Created by Ian Richard on 1/30/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "House.h"
#import "User.h"

@interface UserManager : NSObject

/*
 * Get all the houses that this user is part of
 *
 * Arguments:
 * user - user that we are getting list for
 *
 * Return:
 * Array of house objects
 */
+ (NSArray *)getHouseListForUser:(User *)user;

@end
