//
//  SCHTTPNetwork.h
//  PushTest
//
//  Created by Otávio Lima on 10/28/15.
//  Copyright © Starcut. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SCHTTPNetworkSuccessHandler)(NSData *responseData);
typedef void(^SCHTTPNetworkFailureHandler)(NSError *error, NSData *responseObject);

@interface SCHTTPNetwork : NSObject

- (void)startResquest:(NSURLRequest *)request success:(SCHTTPNetworkSuccessHandler)success failure:(SCHTTPNetworkFailureHandler)failure;

@end
