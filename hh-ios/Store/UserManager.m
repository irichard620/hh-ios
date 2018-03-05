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
    [StoreHelpers sendGetRequestWithEndpoint:@"/user/houses" requiresAuth:YES withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            // If no error, get json response and deserialize to house object
            NSArray *housesJson = jsonResponse[@"houses"];
            NSMutableArray *resultArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < housesJson.count; i++) {
                House *house = [House deserializeHouse:housesJson[i]];
                [resultArray addObject:house];
            }
            completion(resultArray, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)uploadProfilePic:(UIImage *)image withCompletion:(void (^)(NSString *, NSString *))completion {
    [StoreHelpers sendPutRequestWithEndpoint:@"/user/upload_link" requiresAuth:YES hasParameters:nil withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            NSString *presignedURL = jsonResponse[@"signed_url"];
            NSString *resourcURL = jsonResponse[@"resource_url"];
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
            completion(nil, errorType);
        }
    }];
}

+ (void)editUserWithName:(NSString *)name andAvatarLink:(NSString *)avatarLink withCompletion:(void (^)(User *, NSString *))completion {
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
    
    [StoreHelpers sendPutRequestWithEndpoint:@"/user/edit" requiresAuth:YES hasParameters:parameters withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            User *newUser = [User deserializeUser:jsonResponse[@"response"] isLogin:NO];
            completion(newUser, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

+ (void)getUserWithCompletion:(void (^)(User *, NSString *))completion {
    completion(nil, nil);
    [StoreHelpers sendGetRequestWithEndpoint:@"/user/info" requiresAuth:YES withCallback:^(NSDictionary *jsonResponse, NSString *errorType) {
        if (!errorType) {
            User *user = [User deserializeUser:jsonResponse[@"response"] isLogin:NO];
            completion(user, nil);
        } else {
            completion(nil, errorType);
        }
    }];
}

@end
