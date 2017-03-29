//
//  StarFlightPushClient.h
//
//  Created by Starcut Software on 4/30/13.
//  Copyright (c) Starcut. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SCStarFlightClientUUIDNotification;

@interface SCStarFlightPushClient : NSObject <NSURLConnectionDelegate>

- (instancetype)initWithAppID:(NSString *)appID clientSecret:(NSString *)clientSecret;

- (void)registerWithToken:(NSString *)token;
- (void)registerWithToken:(NSString *)token clientUUID:(NSString *)clientUUID tags:(NSArray<NSString *> *)tags;
- (void)unregisterWithToken:(NSString *)token tags:(NSArray<NSString *> *)tags;
- (void)openedMessageWithUUID:(NSString *)messageUUID deviceToken:(NSString *)deviceToken;

@end
