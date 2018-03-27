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

Starcut Developers, starcutdev@gmail.com

## License

StarFlight is available under the MIT license. See the LICENSE file for more info.

## Usage

Swift:
```Swift
in AppDelegate.Swift

import UIKit
import StarFlight

struct KamuPushNotificationConstants{
    static let starFlightClientID = "<Client ID here>"
    static let starFlightClientSecret = "<Client Secret here>"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //MARK: - Application delegate methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        configurePushNotification(launchOptions: launchOptions)

        registerForPushNotification(application: application)

        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(application.applicationState)

        if application.applicationState == .background {
            pushNotificationReceived(userInfo, markAsRead: true)
        } else if application.applicationState == .active {
            pushNotificationReceived(userInfo, markAsRead: true)
        }
        else {
            pushNotificationHandler(notification: userInfo)
            pushNotificationReceived(userInfo, markAsRead: true)
        }
    }

    func application(_ application: UIApplication, didRegister  : UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

        print(self.deviceToken)
        //if deviceTokenString != self.deviceToken {
        let pushClient: SCStarFlightPushClient = SCStarFlightPushClient(appID: PushNotificationConstants.starFlightClientID, clientSecret: PushNotificationConstants.starFlightClientSecret)
        saveDeviceToken(deviceTokenString)

                   pushClient.register(withToken: self.deviceToken,
                                clientUUID: (clientUUID != "" ? clientUUID : nil),
                                tags: nil,
                                timePreferences: nil)

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }

    //MARK: - Push Notification Configutation

    func configurePushNotification(launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        //configuring the push notification
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable : Any] {
            pushNotificationHandler(notification: notification)
            pushNotificationReceived(notification, markAsRead: true)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.handleClientUUIDNotification(_:)), name: NSNotification.Name.SCStarFlightClientUUID, object: nil)
    }

    func registerForPushNotification(application: UIApplication){

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
                application.registerForRemoteNotifications()
            })
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }

    }

    func pushNotificationReceived (_ notification: [AnyHashable : Any], markAsRead: Bool) {

        if let messageUUID: String = notification["uuid"] as? String {
            if markAsRead {
                self.messageUUID = ""
                let pushClient: SCStarFlightPushClient = SCStarFlightPushClient(appID: PushNotificationConstants.starFlightClientID, clientSecret: PushNotificationConstants.starFlightClientSecret)
                pushClient.openedMessage(withUUID: messageUUID, deviceToken: deviceToken)
            } else {
                self.messageUUID = messageUUID
            }
        }
    }

    var deviceToken: String {
        let prefs = UserDefaults.standard
        if let token = prefs.string(forKey: "deviceToken") {
            return token
        } else {
            return ""
        }
    }

    func saveDeviceToken (_ deviceToken: String) {
        let prefs = UserDefaults.standard
        prefs.set(deviceToken, forKey: "deviceToken")
        prefs.synchronize()
    }

    var clientUUID: String {
        let prefs = UserDefaults.standard
        if let uuid = prefs.string(forKey: "clientUUID") {
            print(uuid)
            return uuid
        } else {
            return ""
        }
    }

    func saveClientUUID (_ clientUUID: String) {
        let prefs = UserDefaults.standard
        prefs.set(clientUUID, forKey: "clientUUID")
        prefs.synchronize()
    }

    func handleClientUUIDNotification(_ notification: Notification) {
        if let clientUuid = (notification as NSNotification).userInfo?["clientUuid"] as? String{
            saveClientUUID(clientUuid)
        }
    }
}

```

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
