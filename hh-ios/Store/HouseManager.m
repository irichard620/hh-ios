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
#import "AuthenticationManager.h"

@implementation HouseManager

+ (void)createHouseWithDisplay:(NSString *)displayName andUnique:(NSString *)uniqueName withCompletion:(void (^)(House *, NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
    
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
                NSDictionary *responseDict = jsonResponse.body.JSONObject[@"response"];
                House *house = [House deserializeHouse:responseDict];
                completion(house, nil);
            } else {
                completion(nil, UNKNOWN_ERROR);
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            completion(nil, UNKNOWN_ERROR);
        }
    }];
}

+ (void)inviteUser:(NSString *)email toHouseName:(NSString *)uniqueName withCompletion:(void (^)(NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
    
    // email and house unique name
    NSDictionary* parameters = @{@"email": email, @"house_id": uniqueName};
    
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
                completion(UNKNOWN_ERROR);
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            completion(UNKNOWN_ERROR);
        }
    }];
}

+ (void)joinHouseWithUnique:(NSString *)uniqueName andJoiningUser:(User *)user withCompletion:(void (^)(NSString *))completion {
    completion(nil);
}

+ (void)getListOfResidentsWithUniqueName:(NSString *)uniqueName withCompletion:(void (^)(NSArray *, NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
    
    // Create post request to /api/house/:house_id/users
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
                    [usersArray addObject:[User deserializeUser:responseArray[i] isLogin:NO]];
                }
                completion(usersArray, nil);
            } else {
                completion(nil, UNKNOWN_ERROR);
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            completion(nil, UNKNOWN_ERROR);
        }
    }];
}

+ (void)uploadHousePic:(UIImage *)image withUniqueName:(NSString *)uniqueName withCompletion:(void (^)(NSString *, NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
    
    // house unique name
    NSDictionary* parameters = @{@"unique_name": uniqueName};
    
    // Create post request to /api/house/createUploadLink
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/house/createUploadLink"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 201) {
                NSString *presignedURL = jsonResponse.body.JSONObject[@"signed_url"];
                NSString *resourceURL = jsonResponse.body.JSONObject[@"resource_url"];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:presignedURL]];
                request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
                [request setHTTPMethod:@"PUT"];
                [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
                
                // Create upload
                NSURLSessionUploadTask *uploadTask = [[[NSURLSession alloc]init]uploadTaskWithRequest:request fromFile:[StoreHelpers saveImageToFile:image] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error) {
                        completion(nil, UNKNOWN_ERROR);
                    } else {
                        completion(resourceURL, nil);
                    }
                }];
                [uploadTask resume];
            } else {
                completion(nil, UNKNOWN_ERROR);
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
            completion(nil, UNKNOWN_ERROR);
        }
    }];
}

+ (void)editHouseWithUniqueName:(NSString *)uniqueName withDisplayName:(NSString *)displayName andAvatarLink:(NSString *)avatarLink withCompletion:(void (^)(House *, NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
    
    NSDictionary *parameters;
    if (!displayName && !avatarLink) {
        completion(nil, MISSING_INFO_ERROR);
    } else if (!displayName) {
        parameters = @{@"avatar_link": avatarLink, @"unique_name": uniqueName};
    } else if (!avatarLink) {
        parameters = @{@"display_name": displayName, @"unique_name": uniqueName};
    } else {
        parameters = @{@"display_name": displayName, @"avatar_link": avatarLink, @"unique_name": uniqueName};
    }
    
    // Create put request to /api/house/editHouse
    [[UNIRest put:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/house/editHouse"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 201) {
                NSDictionary *houseDict = jsonResponse.body.JSONObject[@"response"];
                House *newHouse = [House deserializeHouse:houseDict];
                completion(newHouse, nil);
            } else if (jsonResponse.code == 422) {
                completion(nil, MISSING_INFO_ERROR);
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
