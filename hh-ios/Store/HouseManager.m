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
    // Pass display and unique name
    NSDictionary* parameters = @{@"display_name": displayName, @"unique_name": uniqueName};
    
    // Send request
    [StoreHelpers sendPostRequestWithEndpoint:@"/house/create" requiresAuth:YES hasParameters:parameters withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            House *house = [House deserializeHouse:jsonResponse[@"response"]];
            completion(house, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)inviteUser:(NSString *)email toHouseName:(NSString *)uniqueName withCompletion:(void (^)(NSString *))completion {
    // email and house unique name
    NSDictionary* parameters = @{@"email": email, @"unique_name": uniqueName};
    
    // Send request
    [StoreHelpers sendPutRequestWithEndpoint:@"/house/invite" requiresAuth:YES hasParameters:parameters withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        completion(errorType);
    }];
}

+ (void)joinHouseWithUnique:(NSString *)uniqueName withCompletion:(void (^)(House *, NSString *))completion {
    // Pass unique name
    NSDictionary* parameters = @{@"unique_name": uniqueName};
    
    // Send request
    [StoreHelpers sendPutRequestWithEndpoint:@"/house/join" requiresAuth:YES hasParameters:parameters withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            // If no error, get json response and deserialize to house object
            House *house = [House deserializeHouse:jsonResponse[@"response"]];
            completion(house, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)getListOfResidentsWithUniqueName:(NSString *)uniqueName withCompletion:(void (^)(NSArray *, NSString *))completion {
    [StoreHelpers sendGetRequestWithEndpoint:[NSString stringWithFormat:@"/house/%@/users",uniqueName] requiresAuth:YES withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            // If no error, return nil for error
            NSLog(@"json:%@",jsonResponse);
            NSArray *responseArray = jsonResponse[@"users"];
            NSMutableArray *usersArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < responseArray.count; i++) {
                [usersArray addObject:[User deserializeUser:responseArray[i] isLogin:NO]];
            }
            completion(usersArray, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)uploadHousePic:(UIImage *)image withUniqueName:(NSString *)uniqueName withCompletion:(void (^)(NSString *, NSString *))completion {
    // house unique name
    NSDictionary* parameters = @{@"unique_name": uniqueName};
    
    // Send request
    [StoreHelpers sendPostRequestWithEndpoint:@"/house/upload_link" requiresAuth:YES hasParameters:parameters withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            NSString *presignedURL = jsonResponse[@"signed_url"];
            NSString *resourceURL = jsonResponse[@"resource_url"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:presignedURL]];
            request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
            [request setHTTPMethod:@"PUT"];
            [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
            
            // Create upload
            NSURLSessionUploadTask *uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromFile:[StoreHelpers saveImageToFile:image] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSLog(@"%@",[response debugDescription]);
                NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                if (error) {
                    completion(nil, UNKNOWN_ERROR);
                } else {
                    completion(resourceURL, nil);
                }
            }];
            [uploadTask resume];
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)editHouseWithUniqueName:(NSString *)uniqueName withDisplayName:(NSString *)displayName andAvatarLink:(NSString *)avatarLink andFullName:(NSString *)fullName withCompletion:(void (^)(House *, NSString *))completion {
    NSDictionary *parameters;
    if (!displayName && !avatarLink) {
        completion(nil, MISSING_INFO_ERROR);
    } else if (!displayName) {
        parameters = @{@"avatar_link": avatarLink, @"unique_name": uniqueName, @"full_name": fullName};
    } else if (!avatarLink) {
        parameters = @{@"display_name": displayName, @"unique_name": uniqueName, @"full_name": fullName};
    } else {
        parameters = @{@"display_name": displayName, @"avatar_link": avatarLink, @"unique_name": uniqueName, @"full_name": fullName};
    }
    
    [StoreHelpers sendPutRequestWithEndpoint:@"/house/edit" requiresAuth:YES hasParameters:parameters withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            House *newHouse = [House deserializeHouse:jsonResponse[@"response"]];
            completion(newHouse, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)getHouseWithUniqueName:(NSString *)uniqueName withCompletion:(void (^)(House *, NSString *))completion {
    [StoreHelpers sendGetRequestWithEndpoint:[NSString stringWithFormat:@"/house/%@",uniqueName] requiresAuth:YES withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            House *house = [House deserializeHouse:jsonResponse[@"response"]];
            completion(house, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

@end
