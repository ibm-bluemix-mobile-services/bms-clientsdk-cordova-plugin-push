# IBM Bluemix Mobile Services - Push SDK Cordova

Cordova Plugin for the IBM Bluemix Mobile Services Push SDK

## Contents
- <a href="#installation">Installation</a>
- <a href="#configuration">Configuration</a>
    - <a href="#configure-ios">Configuring Your iOS Development Environment</a>
    - <a href="#configure-android">Configuring Your Android Development Environment</a>
- <a href="#usage">Usage</a>
    - <a href="#usage">MFPPush</a>
    - <a href="#sequence-diagrams">SDK Sequence Diagrams</a>
- <a href="#examples">Examples</a> 
    - <a href="#ex-register">Registering for Push Notifications</a>
    - <a href="#ex-retrieve">Retrieving Tags</a>
    - <a href="#ex-subscribe">Subscribing and Unsubscribe to/from Tags</a>
    - <a href="#ex-notification">Receiving a Notification</a>
- <a href="#release-notes">Release Notes</a> 

<h2 id="installation">Installation</h2>

### Adding the Cordova plugin

From your Cordova application root directory, enter the following command to install the Cordova Push plugin.

    $ cordova plugin install ibm-mfp-push

From your app root folder, verify that the Cordova Core and Push plugin were installed successfully, using the following command.

    $ cordova plugin list

<h2 id="configuration">Configuration</h2>

<h3 id="configure-ios">Configuring Your iOS Development Environment</h3>

Follow the instructions here to configure your Xcode environment [https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-core/tree/development#configure-ios](https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-core/tree/development#configure-ios)

Go to Build Settings > Search Paths > Framework Search Paths and verify that the following parameter was added:

    "[your-app-name]/Plugins/ibm-mfp-push"

#### Updating your client application to use the Push SDK

Add the following Objective-C code snippets to your application delegate class.

At the top of your AppDelegate.m:

    #import "[your-app-name]-Swift.h"

Objective-C:

    // Register device token with Bluemix Push Notification Service
    - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
        
        [[CDVMFPPush sharedInstance] didRegisterForRemoteNotifications:deviceToken];
    }
    
    // Handle error when failed to register device token with APNs
    - (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    
        [[CDVMFPPush sharedInstance] didFailToRegisterForRemoteNotifications:error];
    }
    
    // Handle receiving a remote notification
    -(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
        
        [[CDVMFPPush sharedInstance] didReceiveRemoteNotification:userInfo];
    }
    
Swift:
    
    // Register device token with Bluemix Push Notification Service
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        CDVMFPPush.sharedInstance().didRegisterForRemoteNotifications(deviceToken)
    }
    
    // Handle error when failed to register device token with APNs
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSErrorPointer) {
        
        CDVMFPPush.sharedInstance().didFailToRegisterForRemoteNotifications(error)
    }
    
    // Handle receiving a remote notification
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: ) {
        
        CDVMFPPush.sharedInstance().didReceiveRemoteNotification(userInfo)
    }

<h3 id="configure-android">Configuring Your Android Development Environment</h3>

Follow the instructions here to configure your Android environment [https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-core/tree/development#configure-android](https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-core/tree/development#configure-android)

<h2 id="usage">Usage</h2>

The following MFPPush Javascript functions are available:

Javascript Function | Description
--- | ---
`retrieveSubscriptions(success, failure)` | Retrieves the tags that are subscribed by the device.
`retrieveAvailableTags(success, failure)` | Retrieves all the available tags for the backend mobile application.
`subscribe(tag, success, failure)` | Subscribes to a particular backend mobile application tag.
`unsubscribe(tag, success, failure)` | Unsubscribes from an backend mobile application tag.
`registerDevice(settings, success, failure)` | Registers the device with the IMFPush Notification Server.
`unregisterDevice(success, failure)` | Unregisters the device from the IMFPush Notification Server.
`registerNotificationsCallback(callback)` | Registers a callback for when a notification arrives on the device.

**Android (Native)**
The following native Android function is available.

 Android function | Description
--- | ---
`CDVMFPPush.setIgnoreIncomingNotifications(boolean ignore)` | By default, the Javascript API delegates Push Notification handling to the Push plugin. Use this method to override the plugin's default behavior -- ignore the notifications.

<h3 id="sequence-diagrams">SDK Sequence Diagrams</h3>

<img src="https://raw.githubusercontent.com/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-push/development/Sequence%20diagrams/Push%20Notifications%20SDK%20flows%20for%20hybrid%20iOS%20Apps.png">

<img src="https://raw.githubusercontent.com/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-push/development/Sequence%20diagrams/Push%20Notifications%20SDK%20flows%20for%20hybrid%20Android%20apps.png">

<h2 id="examples">Examples</h2>

<h3 id="using-mfppush">Using MFPPush</h3>

<h4 id="ex-register">Register for Push Notifications</h4>

    var settings = {
        ios: {
            alert: true,
            badge: true,
            sound: true
        }
    }
    
    var success = function(message) { console.log("Success: " + message); };
    var failure = function(message) { console.log("Error: " + message); };
    
    MFPPush.registerDevice(settings, success, failure);

The settings structure contains the settings that you want to enable for push notifications. You must use the defined structure and should only change the boolean value of each notification setting.


**Note**:
Android does NOT make use of the settings parameter, but you must supply an empty object, e.g:
    
    MFPPush.registerDevice({}, success, failure);

To unregister for push notifications simply call the following:

    MFPPush.unregisterDevice(success, failure);
    
<h4 id="ex-retrieve">Retrieving Tags</h4>

In the following examples, the function parameter is a success callback that receives an array of tags. The second parameter is a callback function called on error.

To return an array of tags to which the user is currently subscribed, use the following Javascript function:

    MFPPush.retrieveSubscriptions(function(tags) {
        // alert(tags);
    }, failure);
    
To return an array of tags that are available to subscribe, use the following Javascript function:

    MFPPush.retrieveAvailableTags(function(tags) {
        // alert(tags);
    }, failure);
    
<h4 id="ex-subscribe">Subscribe and Unsubscribe to/from Tags</h4>

    var tag = "YourTag";

    MFPPush.subscribe(tag, success, failure);
    
    MFPPush.unsubscribe(tag, success, failure);
    
<h4 id="ex-notification">Receiving a Notification</h4>

    var handleNotification = function(notif) {
        // notif is a JSON object containing your notification
    }

    MFPPush.registerNotificationsCallback(handleNotification);

The following table describes the properties of the notification object:

Property | Description
--- | ---
`message` | Push notification message.
`payload` | JSON object containing notification payload.
`sound` | The name of a sound file in the app bundle or in the Library/Sounds folder of the app’s data container. (iOS only).
`badge` | The number to display as the badge of the app icon. If this property is absent, the badge is not changed. To remove the badge, set the value of this property to 0. (iOS only).
`action-loc-key` | The string is used as a key to get a localized string in the current localization to use for the right button’s title instead of “View”. (iOS only).

Example Notification:

    // iOS
    notif = {
        message: "Message",
        payload: {},
        sound: null,
        badge: null,
        action-loc-key: null
    }
    
    // Android
    notif = {
        message: "Message",
        payload: {},
        id: <id>,
        url: <url>
    }

<h2 id="release-notes">Release Notes</h2>

Copyright 2015 IBM Corp.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
