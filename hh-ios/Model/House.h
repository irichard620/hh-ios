//
//  House.h
//  hh-ios
//
//  Created by Ian Richard on 12/31/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserReference.h"

@interface House : NSObject

// Link to house picture
@property (strong, nonatomic) NSString *avatarLink;

// Name for house that displays in UI
@property (strong, nonatomic) NSString *displayName;

// Name for house that must be entered to join
@property (strong, nonatomic) NSString *uniqueName;

// ref of house owner
@property (strong, nonatomic) UserReference *owner;

// Invited
@property (strong, nonatomic) NSArray *invited;

+ (House *) deserializeHouse: (NSDictionary *)houseJson;

@end
