//
//  HouseManager.m
//  hh-ios
//
//  Created by Ian Richard on 1/30/18.
//  Copyright © 2018 Ian Richard. All rights reserved.
//

#import "HouseManager.h"
#import <UNIRest.h>
#import "House.h"

@implementation HouseManager

+ (void)createHouseWithDisplay:(NSString *)displayName andUnique:(NSString *)uniqueName andCreator:(User *)creator withCompletion:(void (^)(House *, NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", creator.accessToken]};
    
    // Pass display and unique name
    NSDictionary* parameters = @{@"displayName": displayName, @"uniqueName": uniqueName};
    
    // Create post request to /api/house/create
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/house/create"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 201) {
                // If no error, get json response and deserialize to house object
                NSDictionary *responseDict = jsonResponse.body.JSONObject;
                House *house = [House deserializeHouse:responseDict];
                completion(house, nil);
            } else {
                completion(nil, @"Unknown");
            }
        } else {
            completion(nil, error.localizedDescription);
        }
    }];
}

+ (void)inviteUser:(NSString *)email toHouse:(House *)house fromUser:(User *)fromUser withCompletion:(void (^)(NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", fromUser.accessToken]};
    
    // email and house unique name
    NSDictionary* parameters = @{@"email": email, @"house_id": house.uniqueName};
    
    // Create post request to /api/house/invite
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/house/invite"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 201) {
                // If no error, return nil for error
                completion(nil);
            } else {
                completion(@"Unknown");
            }
        } else {
            completion(error.localizedDescription);
        }
    }];
}

+ (void)joinHouseWithUnique:(NSString *)uniqueName andJoiningUser:(User *)user withCompletion:(void (^)(NSString *))completion {
    completion(nil);
}

+ (void)getListOfResidents:(User *)user withUniqueName:(NSString *)uniqueName withCompletion:(void (^)(NSArray *, NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", user.accessToken]};
    
    // Create post request to /api/house/invite
    [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:[NSString stringWithFormat:@"https://honesthousemate.herokuapp.com/api/house/%@/users",uniqueName]];
        [request setHeaders:headers];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 200) {
                // If no error, return nil for error
                NSDictionary *responseDict = jsonResponse.body.JSONObject;
                NSArray *responseArray = responseDict[@"users"];
                NSMutableArray *usersArray = [[NSMutableArray alloc]init];
                for (int i = 0; i < responseArray.count; i++) {
                    [usersArray addObject:[User deserializeUser:responseArray[i]]];
                }
                completion(usersArray, nil);
            } else {
                completion(nil, @"Unknown");
            }
        } else {
            completion(nil, error.localizedDescription);
        }
    }];
}

@end
