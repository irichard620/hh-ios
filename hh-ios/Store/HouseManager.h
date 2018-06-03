//
//  HouseManager.h
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

@interface HouseManager : NSObject

/*
 * Create a house in the DB
 *
 * Arguments:
 * displayName - What shows to all users - doesnt have to be unique
 * uniqueName - what is used to join the house, shown as username, unique
 * creatorId - the ID of the user creating house
 *
 * Return:
 * House object that was created
*/
+ (void)createHouseWithDisplay:(NSString *)displayName andUnique:(NSString *)uniqueName withCompletion:(void (^)(House *house, NSString *error))completion;

/*
 * Invite an email to a house
 *
 * Arguments:
 * email - Email to invite
 * houseId - the ID of house we are inviting user to
 *
 * Return:
 * None
 */
+ (void)inviteUser:(NSString *)email toHouseName:(NSString *)uniqueName withCompletion:(void (^)(NSString *error))completion;

/*
 * Join a house
 *
 * Arguments:
 * uniqueName - Username of the house to join
 *
 * Return:
 * House object
 */
+ (void)joinHouseWithUnique:(NSString *)uniqueName withCompletion:(void (^)(House *house, NSString *error))completion;

/*
 * Get list of members in house
 *
 * Arguments:
 * uniqueName - username of house to join
 *
 * REturn:
 * Array of user objects
 */
+ (void)getListOfResidentsWithUniqueName:(NSString *)uniqueName withCompletion:(void (^)(NSArray *residents, NSString *error))completion;

/*
 * Upload profile picture for house
 *
 * Arguments
 * UIImage object and uniqueName of house
 *
 * Return
 * Error completion block
 *
 */
+ (void)uploadHousePic:(UIImage *)image withUniqueName:(NSString *)uniqueName withCompletion:(void(^)(NSString *resourceURL, NSString *error))completion;

/*
 * Edit House
 *
 * Arguments
 * display_name = optional String
 * avatar_link = optional String
 * unique_name = required String
 *
 * Return
 * Updated house object
 *
 */
+ (void)editHouseWithUniqueName:(NSString *)uniqueName withDisplayName:(NSString *)displayName andAvatarLink:(NSString *)avatarLink andFullName:(NSString *)fullName withCompletion:(void(^)(House *house, NSString *error))completion;

/*
 * Get House
 *
 * Arguments
 * unique_name = required String
 *
 * Return
 * Current house object
 *
 */
+ (void)getHouseWithUniqueName:(NSString *)uniqueName withCompletion:(void(^)(House *house, NSString *error))completion;

@end
