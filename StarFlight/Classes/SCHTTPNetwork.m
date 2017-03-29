//
//  SCHTTPNetwork.m
//  PushTest
//
//  Created by Otávio Lima on 10/28/15.
//  Copyright © Starcut. All rights reserved.
//

#import "SCHTTPNetwork.h"

@interface SCHTTPNetwork ()

@property (assign, nonatomic) NSInteger statusCode;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (copy, nonatomic) SCHTTPNetworkSuccessHandler successBlock;
@property (copy, nonatomic) SCHTTPNetworkFailureHandler failureBlock;

@end

@implementation SCHTTPNetwork

- (void)startResquest:(NSURLRequest *)request success:(SCHTTPNetworkSuccessHandler)success failure:(SCHTTPNetworkFailureHandler)failure
{
    self.statusCode = 0;
    self.receivedData = [NSMutableData data];
    self.successBlock = success;
    self.failureBlock = failure;

    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    self.statusCode = [response statusCode];
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.statusCode > 299)
    {
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: @"Server side error"
                                   };

        NSError *error = [NSError errorWithDomain:@"com.starcut.PushTest" code:-1 userInfo:userInfo];
        [self onError:error];
    }
    else
    {
        [self onSuccess];
    }
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    [self onError:error];
}

- (void)onSuccess
{
    if (self.successBlock)
    {
        self.successBlock(self.receivedData);
    }
}

- (void)onError:(NSError *)error
{
    if (self.failureBlock)
    {
        self.failureBlock(error, nil);
    }
}

@end
