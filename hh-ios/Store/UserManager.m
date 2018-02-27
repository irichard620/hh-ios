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
#import "AuthenticationManager.h"

@implementation UserManager

+ (void)getHouseListForUserWithCompletion:(void (^)(NSArray *, NSString *))completion; {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
    
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

+ (void)uploadProfilePic:(UIImage *)image withCompletion:(void (^)(NSString *, NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
    
    // Create get request to /api/user/createUploadLink
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/user/createUploadLink"];
        [request setHeaders:headers];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 201) {
                NSString *presignedURL = jsonResponse.body.JSONObject[@"signed_url"];
                NSString *resourcURL = jsonResponse.body.JSONObject[@"resource_url"];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:presignedURL]];
                request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
                [request setHTTPMethod:@"PUT"];
                [request setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
                
                // Create upload
                NSURLSessionUploadTask *uploadTask = [[[NSURLSession alloc]init]uploadTaskWithRequest:request fromFile:[StoreHelpers saveImageToFile:image] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error) {
                        completion(nil, UNKNOWN_ERROR);
                    } else {
                        completion(resourcURL, nil);
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

+ (void)editUserWithName:(NSString *)name andAvatarLink:(NSString *)avatarLink withCompletion:(void (^)(User *, NSString *))completion {
    // Accepts JSON and pass access token
    NSDictionary* headers = @{@"accept": @"application/json", @"Authorization": [NSString stringWithFormat:@"Bearer %@", [AuthenticationManager getCurrentAccessToken]]};
    
    NSDictionary *parameters;
    if (!name && !avatarLink) {
        completion(nil, MISSING_INFO_ERROR);
    } else if (!name) {
        parameters = @{@"avatar_link": avatarLink};
    } else if (!avatarLink) {
        parameters = @{@"full_name": name};
    } else {
        parameters = @{@"full_name": name, @"avatar_link": avatarLink};
    }
    
    // Create put request to /api/user/editUser
    [[UNIRest put:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/user/editUser"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 201) {
                NSDictionary *userDict = jsonResponse.body.JSONObject[@"response"];
                User *newUser = [User deserializeUser:userDict isLogin:NO];
                completion(newUser, nil);
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
