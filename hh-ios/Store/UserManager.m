//
//  UserManager.m
//  hh-ios
//
//  Created by Ian Richard on 1/30/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

+ (NSArray *)getHouseListForUser:(User *)user {
    House *house = [[House alloc]init];
    house._id = @"b1";
    house.displayName = @"SCU House";
    house.uniqueName = @"scu-house";
    return [NSArray arrayWithObjects:house, nil];
}

@end
