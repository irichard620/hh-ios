//
//  House.m
//  hh-ios
//
//  Created by Ian Richard on 12/31/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "House.h"

@implementation House

+ (House *)deserializeHouse:(NSDictionary *)houseJson {
    House *house = [[House alloc]init];
    if (houseJson[@"avatar_link"] == (id)[NSNull null]) {
        house.avatarLink = nil;
    } else {
        house.avatarLink = houseJson[@"avatar_link"];
    }
    house.displayName = houseJson[@"display_name"];
    house.uniqueName = houseJson[@"unique_name"];
    house.owner = [UserReference deserializeUserRef:houseJson[@"owner"]];
    house.invited = houseJson[@"invited"];
    
    return house;
}

@end
