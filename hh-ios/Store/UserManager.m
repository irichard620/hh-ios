//
//  UserManager.m
//  hh-ios
//
//  Created by Ian Richard on 1/30/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "UserManager.h"
#import <UNIRest.h>
#import "House.h"

NSString * const UNKNOWN_ERROR = @"unknown";
NSString * const NOT_FOUND_ERROR = @"not_found";
NSString * const CONNECTION_ERROR = @"connection";
NSString * const MISSING_INFO_ERROR = @"missing_info";

@implementation UserManager

+ (void)getHouseListForUser:(User *)user withCompletion:(void (^)(NSArray *, NSString *))completion; {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", user.accessToken]};
    
    // Create get request to /api/user/houses
    [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/user/houses"];
        [request setHeaders:headers];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 200) {
                // If no error, get json response and deserialize to house object
                NSArray *housesJson = jsonResponse.body.JSONObject[@"houses"];
                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
                for (int i = 0; i < housesJson.count; i++) {
                    House *house = [House deserializeHouse:housesJson[i]];
                    [resultArray addObject:house];
                }
                completion(resultArray, nil);
            } else {
                completion(nil, UNKNOWN_ERROR);
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            completion(nil, UNKNOWN_ERROR);
            
        }
    }];
}

@end
