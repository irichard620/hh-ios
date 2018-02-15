//
//  AuthenticationManager.m
//  hh-ios
//
//  Created by Ian Richard on 12/31/17.
//  Copyright © 2017 Ian Richard. All rights reserved.
//

#import "AuthenticationManager.h"
#import <UNIRest.h>
#import "NSString+Security.h"

@implementation AuthenticationManager

+ (void)createNewUserWithEmail:(NSString *)email andPassword:(NSString *)password andFullName:(NSString *)fullName withCompletion:(void (^)(User *, NSString *))completion {
    // First, send request to register user with email, name, and hashed password
    NSDictionary* headers = @{@"accept": @"application/json"};
    NSString *hashedPassword = [password createSHA512];
    NSDictionary* parameters = @{@"email": email, @"name": fullName, @"password": hashedPassword };
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://honesthousemate.herokuapp.com/api/auth/register"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 201) {
                // If no error, login user
                NSDictionary *parameters2 = @{@"email": email, @"password": hashedPassword };
                [[UNIRest post:^(UNISimpleRequest *request2) {
                    [request2 setUrl:@"https://honesthousemate.herokuapp.com/api/auth/login"];
                    [request2 setHeaders:headers];
                    [request2 setParameters:parameters2];
                }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
                    if (!error) {
                        if (jsonResponse.code == 200) {
                            // If no error, get json response and deserialize to user object
                            NSDictionary *responseDict = jsonResponse.body.JSONObject;
                            User *user = [User deserializeUser:responseDict];
                            completion(user, nil);
                        } else {
                            completion(nil, @"Unknown");
                        }
                    } else {
                        completion(nil, error.localizedDescription);
                    }
                }];
            } else {
                completion(nil, @"Unknown");
            }
        } else {
            completion(nil, error.localizedDescription);
        }
    }];
}

+ (void)loginUserWithEmail:(NSString *)email andPassword:(NSString *)password withCompletion:(void (^)(User *, NSString *))completion {
    NSDictionary* headers = @{@"accept": @"application/json"};
    NSString *hashedPassword = [password createSHA512];
    NSDictionary *parameters2 = @{@"email": email, @"password": hashedPassword };
    [[UNIRest post:^(UNISimpleRequest *request2) {
        [request2 setUrl:@"https://honesthousemate.herokuapp.com/api/auth/login"];
        [request2 setHeaders:headers];
        [request2 setParameters:parameters2];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        if (!error) {
            if (jsonResponse.code == 200) {
                // If no error, get json response and deserialize to user object
                NSDictionary *responseDict = jsonResponse.body.JSONObject;
                User *user = [User deserializeUser:responseDict];
                completion(user, nil);
            } else {
                completion(nil, @"Unknown");
            }
        } else {
            completion(nil, error.localizedDescription);
        }
    }];
}

@end
