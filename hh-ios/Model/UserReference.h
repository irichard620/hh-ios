//
//  UserReference.h
//  hh-ios
//
//  Created by Ian Richard on 12/30/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//
// Purpose: Reference to a user in data object that is not user object
// Ex: reference to user in payment object - don't want to store whole user

#import <Foundation/Foundation.h>

@interface UserReference : NSObject

// ID of this user
@property (nonatomic) NSString *_id;

// Name of this user
@property (nonatomic) NSString *name;

// Link to this user's profile picture
@property (nonatomic) NSString *avatarLink;

+ (UserReference *)deserializeUserRef:(NSDictionary *)userRefDict;

@end
