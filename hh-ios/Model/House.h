//
//  House.h
//  hh-ios
//
//  Created by Ian Richard on 12/31/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface House : NSObject

// unique ID of the house
@property (strong, nonatomic) NSString *_id;

// Link to house picture
@property (strong, nonatomic) NSString *avatarLink;

// Name for house that displays in UI
@property (strong, nonatomic) NSString *displayName;

// Name for house that must be entered to join
@property (strong, nonatomic) NSString *uniqueName;

// Invited
@property (strong, nonatomic) NSArray *invited;

// Members
@property (strong, nonatomic) NSArray *members;

+ (House *) deserializeHouse: (NSDictionary *)houseJson;

@end
