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
    house._id = houseJson[@"_id"];
    house.avatarLink = houseJson[@"avatar_link"];
    house.displayName = houseJson[@"display_name"];
    house.uniqueName = houseJson[@"unique_name"];
    house.owner = [UserReference deserializeUserRef:houseJson[@"owner"]];
    
    return house;
}

@end
