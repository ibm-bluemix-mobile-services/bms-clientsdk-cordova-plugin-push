# IBM Bluemix Mobile Services - Cordova Plugin Push SDK

[![](https://img.shields.io/badge/bluemix-powered-blue.svg)](https://bluemix.net)
[![Build Status](https://travis-ci.org/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-push.svg?branch=master)](https://travis-ci.org/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-push)
[![npm](https://img.shields.io/npm/v/bms-push.svg)](https://www.npmjs.com/package/bms-push)
[![npm](https://img.shields.io/npm/dm/bms-push.svg)](https://www.npmjs.com/package/bms-push)

[![npm package](https://nodei.co/npm/bms-push.png?downloads=true&downloadRank=true&stars=true)](https://nodei.co/npm/bms-push/)

Cordova Plugin for the IBM Bluemix Mobile Services Push SDK

## Installation

### Installing necessary libraries

You should already have Node.js/npm and the Cordova package installed. If you don't, you can download and install Node from [https://nodejs.org/en/download/](https://nodejs.org/en/download/).

The Cordova library is also required to use this plugin. You can find instructions to install Cordova and set up your Cordova app at [https://cordova.apache.org/#getstarted](https://cordova.apache.org/#getstarted).

## Installing the Cordova Plugin for Bluemix Mobile Services Push SDK

### Creating a Cordova application

1. Run the following commands to create a new Cordova application. Alternatively you can use an existing application as well.

	```Bash
	cordova create {your_app_name}
	cd {your_app_name}
	```

1. Edit `config.xml` file and set the desired application name in the `<name>` element instead of a default HelloCordova.

1. Continue editing `config.xml`. Update the `<platform name="ios">` element with a deployment target declaration as shown in the code snippet below.

	```XML
	<platform name="ios">
		<preference name="deployment-target" value="8.0" />
		<!-- add deployment target declaration -->
	</platform>
	```

1. Continue editing `config.xml`. Update the `<platform name="android">` element with a minimum and target SDK versions as shown in the code snippet below.

	```XML
	<platform name="android">
		<preference name="android-minSdkVersion" value="15" />
		<preference name="android-targetSdkVersion" value="23" />
		<!-- add minimum and target Android API level declaration -->
	</platform>
	```

	> The minSdkVersion should be above 15.

	> The targetSdkVersion should always reflect the latest Android SDK available from Google.

### Adding Cordova platforms

Run the following commands according to which platform you want to add to your Cordova application

```Bash
cordova platform add ios

cordova platform add android
```
**IMPORTANT: Make sure you use this iOS version for the cordova platform. It is required for the cordova app to build.**

### Adding the Cordova plugin

From your Cordova application root directory, enter the following command to install the Cordova Push plugin.

```Bash
cordova plugin add bms-push
```

This also installs the Cordova Core plug-in, which initializes your connection to Bluemix.

From your app root folder, verify that the Cordova Core and Push plugin were installed successfully, using the following command.

```Bash
cordova plugin list
```

>Note: Existing 3rd party push notification plugins (e.g., phonegap) may interfere with bms-push. Be sure to remove these plugins to ensure proper funcitonality.

## Configuration

### Configuring Your iOS Development Environment

1. Follow the `Configuring Your iOS Development Environment` instructions from [Bluemix Mobile Services Core SDK plugin](https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-core#4configuring-your-platform)

#### Updating your client application to use the Push SDK

By default, Cordova creates a native iOS project built with iOS, therefore you will need to import an automatically generated Swift header to use the Push SDK. Add the following Objective-C code snippets to your application delegate class.

At the top of your AppDelegate.m:

```Objective-C
#import "[your-project-name]-Swift.h"
```

If your project name has spaces or hyphens, replace them with underscores in the import statement. Example:

```Objective-C
// Project name is "Test Project" or "Test-Project"
#import "Test_Project-Swift.h"
```

Add the code below to your application delegate:

#### Objective-C:

```Objective-C
// Register device token with Bluemix Push Notification Service
- (void)application:(UIApplication *)application
	 didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{

	   [[CDVBMSPush sharedInstance] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// Handle error when failed to register device token with APNs
- (void)application:(UIApplication*)application
	 didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {

	  [[CDVBMSPush sharedInstance] didFailToRegisterForRemoteNotificationsWithError:error];
}

// Handle receiving a remote notification
-(void)application:(UIApplication *)application
	didReceiveRemoteNotification:(NSDictionary *)userInfo
	fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

	[[CDVBMSPush sharedInstance] didReceiveRemoteNotificationWithNotification:userInfo];
}

// Handle receiving a remote notification on launch
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {

  -----------
    if (!launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [[CDVBMSPush sharedInstance] didReceiveRemoteNotificationOnLaunchWithLaunchOptions:launchOptions];
    }
  -----------
}
```

#### Swift:

```Swift
// Register device token with Bluemix Push Notification Service
func application(application: UIApplication,
	didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {

	CDVBMSPush.sharedInstance().didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
}

// Handle error when failed to register device token with APNs
func application(application: UIApplication,
	didFailToRegisterForRemoteNotificationsWithError error: NSErrorPointer) {

	CDVBMSPush.sharedInstance().didReceiveRemoteNotificationWithNotification(error)
}

// Handle receiving a remote notification
func application(application: UIApplication,
	didReceiveRemoteNotification userInfo: [NSObject : AnyObject], 	fetchCompletionHandler completionHandler: ) {

	CDVBMSPush.sharedInstance().didReceiveRemoteNotificationWithNotification(userInfo)
}

// Handle receiving a remote notification on launch
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

  ----------
  let remoteNotif = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary

  if remoteNotif != nil {
    CDVBMSPush.sharedInstance().didReceiveRemoteNotificationOnLaunchWithLaunchOptions(launchOptions)
  }
  --------
}
```

### Configuring Your Android Development Environment

Download your Firebase google-services.json for android, and place them in the root folder of your cordova project: `[your-app-name]/platforms/android`

Go to `[your-app-name]/platforms/android`,

1.) Open file `build.gradle` (Path : platform > android > build.gradle)

2.) find `buildscript` text in `build.gradle` file.

3.) There you will find one classpath line, after that line, please add this line :

	classpath 'com.google.gms:google-services:3.0.0'

4.) Then find "dependencies" .Select that dependencies where you have text `compile` and where that dependecies is getting ended, just after that, add this line :

	apply plugin: 'com.google.gms.google-services'


5.) Prepare and build your cordova Android project

	cordova prepare android
	cordova build android

6.) Run your Cordova android project either opening in android studion or using cordova CLI

    cordova run android


## Usage

The following BMSPush Javascript functions are available:

Javascript Function | Description
--- | ---
initialize(pushAppGUID, clientSecret,category) | Initialize the Push SDK.
registerDevice(options, success, failure) | Registers the device with the Push Notifications Service.
unregisterDevice(success, failure) | Unregisters the device from the Push Notifications Service
retrieveSubscriptions(success, failure) | Retrieves the tags device is currently subscribed to
retrieveAvailableTags(success, failure) | Retrieves all the tags available in a push notification service instance.
subscribe(tag, success, failure) | Subscribes to a particular tag.
unsubscribe(tag, success, failure) | Unsubscribes from a particular tag.
registerNotificationsCallback(callback) | Registers a callback for when a notification arrives on the device.

**Android (Native)**
The following native Android function is available.

 Android function | Description
--- | ---
CDVBMSPush. setIgnoreIncomingNotifications(boolean ignore) | By default, push notifications plugin handles all incoming Push Notification by tunnelling them to JavaScript callback. Use this method to override the plugin's default behavior in case you want to manually handle incoming push notifications in native code.


## Examples

### Using BMSPush

#### Register for Push Notifications


```Javascript

// initialize BMSCore SDK
BMSClient.initialize("Your Push service region");

// initialize BMSPush SDK
var appGUID = "Your Push service appGUID";
var clientSecret = "Your Push service clientSecret";

// Initialize for normal push notifications
var options = {}
BMSPush.initialize(appGUID,clientSecret,options);

// Initialize for iOS actionable push notifications and custom deviceId
var options ={"categories":{
                      "Category_Name1":[
                        {
                          "IdentifierName":"IdentifierName_1",
                          "actionName":"actionName_1",
                          "IconName":"IconName_1"
                        },
                        {
                          "IdentifierName":"IdentifierName_2",
                          "actionName":"actionName_2",
                          "IconName":"IconName_2"
                        }
                      ]},
                    "deviceId":"mydeviceId"
                  };

BMSPush.initialize(appGUID, clientSecret, options);


var success = function(response) { console.log("Success: " + response); };
var failure = function(response) { console.log("Error: " + response); };


// Register device for push notification without UserId
var options = {};
BMSPush.registerDevice(options, success, failure);

// Register device for push notification with UserId
var options = {"userId": "Your User Id value"};
BMSPush.registerDevice(options, success, failure);
```

**IMPORTANT: Deprecated this way of adding Category in the Initialize method :- var category = {"Category_Name":[{"IdentifierName_1":"actionName_1"},{"IdentifierName_2":"actionName_2"}]}
.**


You can access the contents of the success response parameter in Javascript using `JSON.parse`:

```Javascript
var token = JSON.parse(response).token
```

Available keys |
--- |
token |
userId |
deviceId |

To unregister for push notifications, simply call the following:

```Javascript
BMSPush.unregisterDevice(success, failure);
```

#### Retrieving Tags

In the following examples, the function parameter is a success callback that receives an array of tags. The second parameter is a callback function called on error.

To retrieve an array of tags to which the user is currently subscribed, use the following Javascript function:

```Javascript
BMSPush.retrieveSubscriptions(function(tags) {
	alert(tags);
}, failure);
```

To retrieve an array of tags that are available to subscribe, use the following Javascript function:

```Javascript
BMSPush.retrieveAvailableTags(function(tags) {
	alert(tags);
}, failure);
```

#### Subscribe and Unsubscribe to/from Tags

```Javascript
var tag = "YourTag";
BMSPush.subscribe(tag, success, failure);
BMSPush.unsubscribe(tag, success, failure);
```

### Receiving a Notification

```Javascript
var handleNotificationCallback = function(notification) {
	// notification is a JSON object
	alert(notification.message);
}

BMSPush.registerNotificationsCallback(handleNotificationCallback);
```

The following table describes the properties of the notification object:

Property | Description
--- | ---
message | Push notification message text
payload | JSON object containing additional notification payload.
sound | The name of a sound file in the app bundle or in the Library/Sounds folder of the app’s data container (iOS only).
badge | The number to display as the badge of the app icon. If this property is absent, the badge is not changed. To remove the badge, set the value of this property to 0 (iOS only).
action-loc-key | The string is used as a key to get a localized string in the current localization to use for the right button’s title instead of “View” (iOS only).

Example Notification structure:

```Javascript
// iOS
notification = {
	message: "Something has happened",
	payload: {
		customProperty:12345
	},
	sound: "mysound.mp3",
	badge: 7,
	action-loc-key: "Click me"
}

// Android
notification = {
	message: "Something has happened",
	payload: {
		customProperty:12345
	},
	id: <id>,
	url: <url>
}
```

## Release Notes

Copyright 2016-17 IBM Corp.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
