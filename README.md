# StarFlight

[![Version](https://img.shields.io/cocoapods/v/StarFlight.svg?style=flat)](http://cocoapods.org/pods/StarFlight)
[![License](https://img.shields.io/cocoapods/l/StarFlight.svg?style=flat)](http://cocoapods.org/pods/StarFlight)
[![Platform](https://img.shields.io/cocoapods/p/StarFlight.svg?style=flat)](http://cocoapods.org/pods/StarFlight)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

StarFlight is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "StarFlight"
```

## Author

Dima Osadchy, dima.osadchy@starcut.com

## License

StarFlight is available under the MIT license. See the LICENSE file for more info.

## Usage

Objective-C:
```Objective-C

in AppDelegate.m

#import "SCStarFlightPushClient.h"
#import "NSData+Conversion.h"

static NSString *const StarFlightClientID = @"<Client ID here>";
static NSString *const StarFlightClientSecret = @"<Client Secret here>";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//...    
// Let the device know we want to receive push notifications
[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

//...
return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
NSLog(@"My token is: %@", [deviceToken hexadecimalString]);

StarFlightPushClient *pushClient = [[StarFlightPushClient alloc] init];
[pushClient register:[deviceToken hexadecimalString]];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
NSLog(@"Failed to get token, error: %@", error);
}

```

Swift:
```Swift
in AppDelegate.Swift

import StarFlight

let starFlightClientID = "<Client ID here>"
let starFlightClientSecret = "<Client Secret here>"

```
