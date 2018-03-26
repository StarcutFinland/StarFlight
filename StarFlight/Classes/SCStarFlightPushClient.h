//
//  StarFlightPushClient.h
//
//  Created by Starcut Software on 4/30/13.
//  Copyright (c) Starcut. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const SCStarFlightClientUUIDNotification;

@interface SCStarFlightPushClient : NSObject <NSURLConnectionDelegate>

- (instancetype)initWithAppID:(NSString *)appID clientSecret:(NSString *)clientSecret;

- (void)registerWithToken:(NSString *)token;
- (void)registerWithToken:(NSString *)token clientUUID:(nullable NSString *)clientUUID tags:(nullable NSArray<NSString *> *)tags timePreferences:(nullable NSDictionary *)timePreferencesDict;
- (void)registerWithToken:(NSString *)token tags:(NSArray<NSString *> *)tags;
- (void)unregisterWithToken:(NSString *)token tags:(nullable NSArray<NSString *> *)tags;
- (void)openedMessageWithUUID:(NSString *)messageUUID deviceToken:(NSString *)deviceToken;

NS_ASSUME_NONNULL_END

@end
