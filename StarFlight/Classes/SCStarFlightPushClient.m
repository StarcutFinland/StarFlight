//
//  StarFlightPushClient.m
//
//  Created by Starcut Software on 4/30/13.
//  Copyright (c) Starcut. All rights reserved.
//

#import "SCStarFlightPushClient.h"

#import "SCHTTPNetwork.h"

@interface SCStarFlightPushClient ()

@property (strong, nonatomic) SCHTTPNetwork *connection;
@property (strong, nonatomic) NSString *appID;
@property (strong, nonatomic) NSString *clientSecret;

- (NSURL *)starFlightAPIURL;

@end

@implementation SCStarFlightPushClient

NSString *const SCStarFlightClientUUIDNotification = @"com.starcut.starflight.clientUUIDNotification";

- (instancetype)initWithAppID:(NSString *)appID clientSecret:(NSString *)clientSecret
{
    self = [super init];

    if (self)
    {
        _appID = appID;
        _clientSecret = clientSecret;
    }

    return self;
}

- (void)registerWithToken:(NSString *)token
{
    [self registerWithToken:token clientUUID:nil tags:nil];
}

- (void)registerWithToken:(NSString *)token tags:(NSArray<NSString *> *)tags
{
    [self registerWithToken:token clientUUID:nil tags:tags];
}

- (void)registerWithToken:(NSString *)token clientUUID:(NSString *)clientUUID tags:(NSArray<NSString *> *)tags
{
    if (self.appID && self.clientSecret && token)
    {
        NSString *post = [NSString stringWithFormat:@"action=register&appId=%@&clientSecret=%@&type=ios&token=%@", self.appID, self.clientSecret, token];

        if (clientUUID)
        {
            post = [post stringByAppendingString:[NSString stringWithFormat:@"&clientUuid=%@", clientUUID]];
        }

        NSString *tagsToRegister = @"";
        for (NSString *tag in tags)
        {
            tagsToRegister = [tagsToRegister stringByAppendingString:[NSString stringWithFormat:@",%@", tag]];
        }

        tagsToRegister = [tagsToRegister stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@", "]];

        if (tagsToRegister && ![tagsToRegister isEqualToString:@""])
        {
            post = [post stringByAppendingString:[NSString stringWithFormat:@"&tags=%@", tagsToRegister]];
        }

        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[self starFlightAPIURL]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];

        self.connection = [[SCHTTPNetwork alloc] init];
        [self.connection startResquest:request success:^(NSData *responseData) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:responseData options: NSJSONReadingMutableContainers error:NULL];

            if (responseObject)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:SCStarFlightClientUUIDNotification object:self userInfo:responseObject];
            }

        } failure:^(NSError *error, NSData *responseObject) {
            NSLog(@"%@", [error localizedDescription]);
        }];
    }
    else
    {
        NSLog(@"Please configure the app when initializing the client");
    }
}

- (void)unregisterWithToken:(NSString *)token tags:(NSArray<NSString *> *)tags;
{
    if (self.appID && self.clientSecret && token)
    {
        NSString *post = [NSString stringWithFormat:@"action=unregister&appId=%@&clientSecret=%@&type=ios&token=%@", self.appID, self.clientSecret, token];

        NSString *tagsToRemove = @"";
        for (NSString *tag in tags)
        {
            tagsToRemove = [tagsToRemove stringByAppendingString:[NSString stringWithFormat:@",%@", tag]];
        }

        tagsToRemove = [tagsToRemove stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@", "]];

        if (tagsToRemove && ![tagsToRemove isEqualToString:@""])
        {
            post = [post stringByAppendingString:[NSString stringWithFormat:@"&tags=%@", tagsToRemove]];
        }

        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[self starFlightAPIURL]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];

        self.connection = [[SCHTTPNetwork alloc] init];
        [self.connection startResquest:request success:^(NSData *responseData) {
            NSLog(@"Client unregistered");
        } failure:^(NSError *error, NSData *responseObject) {
            NSLog(@"%@", [error localizedDescription]);
        }];
    }
    else
    {
        NSLog(@"Please configure the app when initializing the client");
    }
}

- (void)openedMessageWithUUID:(NSString *)messageUUID deviceToken:(NSString *)deviceToken;
{
    if (self.appID && self.clientSecret && messageUUID && deviceToken)
    {
        NSString *post = [NSString stringWithFormat:@"action=message_opened&appId=%@&clientSecret=%@&type=ios&token=%@&uuid=%@", self.appID, self.clientSecret, deviceToken,  messageUUID];

        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[self starFlightAPIURL]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];

        self.connection = [[SCHTTPNetwork alloc] init];
        [self.connection startResquest:request success:^(NSData *responseData) {
            NSLog(@"Message opened");
        } failure:^(NSError *error, NSData *responseObject) {
            NSLog(@"%@", [error localizedDescription]);
        }];
    }
    else
    {
        NSLog(@"Please configure the app when initializing the client");
    }
}

- (NSURL *)starFlightAPIURL
{
    return [NSURL URLWithString:@"https://starflight.starcloud.us/push"];
}

@end
