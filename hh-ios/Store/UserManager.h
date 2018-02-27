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
#import <UIKit/UIKit.h>
#import "StoreHelpers.h"

@interface UserManager : NSObject

/*
 * Get all the houses that this user is part of
 *
 * Arguments:
 * none
 *
 * Return:
 * Array of house objects
 */
+ (void)getHouseListForUserWithCompletion:(void (^)(NSArray *houses, NSString *error))completion;

/*
 * Upload profile picture for user
 *
 * Arguments
 * UIImage object and assetURL of image
 *
 * Return
 * Error completion block
 *
 */
+ (void)uploadProfilePic:(UIImage *)image withCompletion:(void(^)(NSString *resourceURL, NSString *error))completion;

/*
 * Edit user
 *
 * Arguments
 * full_name = optional String
 * avatar_link = optional String
 * one or the other must be provided
 *
 * Return
 * Updated user object
 *
 */
+ (void)editUserWithName:(NSString *)name andAvatarLink:(NSString *)avatarLink withCompletion:(void(^)(User *user, NSString *error))completion;

@end
