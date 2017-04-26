Bluemix Push Notifications Cordova Plugin Push SDK
===================================================

[![](https://img.shields.io/badge/bluemix-powered-blue.svg)](https://bluemix.net)
[![Build Status](https://travis-ci.org/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-push.svg?branch=master)](https://travis-ci.org/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-push)
[![npm](https://img.shields.io/npm/v/bms-push.svg)](https://www.npmjs.com/package/bms-push)
[![npm](https://img.shields.io/npm/dm/bms-push.svg)](https://www.npmjs.com/package/bms-push)

[![npm package](https://nodei.co/npm/bms-push.png?downloads=true&downloadRank=true&stars=true)](https://nodei.co/npm/bms-push/)

The [Bluemix Push Notifications service](https://console.ng.bluemix.net/catalog/services/push-notifications) provides a unified push service to send real-time notifications to mobile and web applications. The plugin enables Cordova apps to receive push notifications sent from the service. Before starting to configure Cordova Plugin follow the [Bluemix Push service setup guide](https://console.ng.bluemix.net/docs/services/mobilepush/index.html#gettingstartedtemplate)

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
  - [Creating a Cordova application](#creating-a-cordova-application)
  - [Adding Cordova platforms](#adding-cordova-platforms)
  - [Adding the Cordova Bluemix Push plugin](#adding-the-cordova-bluemix-push-plugin)
- [Setup Client Application](#setup-client-application)
  - [Setup App environments](#setup-app-environments)
    - [iOS App](#ios-app)
    - [Android App](#android-app)
  - [Initialize](#initialize)
    - [Initializing the Core Plugin](#initializing-the-core-plugin)
    - [Initializing the Push Plugin](#initializing-the-push-plugin)
  - [Register to Push Service](#register-to-push-service)
   - [Register Without UserId](#register-without-userid)
   - [Register With UserId](#register-with-userid)
   - [Unregistering the Device from Push Notification](#unregistering-the-device-from-push-notification)
   - [Unregistering the Device from UserId](#unregistering-the-device-from-userid)
   - [Receiving a Notification](#receiving-a-notification)
 - [Push Notification service tags](#bluemix-tags)
   - [Retrieve Available tags](#retrieve-available-tags)
   - [Subscribe to Available tags](#subscribe-to-available-tags)
   - [Retrieve Subscribed tags](#retrieve-subscribed-tags)
   - [Unsubscribing from tags](#unsubscribing-from-tags)
 - [Notification Options](#notification-options)
   - [Enable Interactive push notifications](#enable-interactive-push-notifications)
   - [Adding custom DeviceId for registration](#ddding-custom-deviceid-for-registration)
- [Samples and Videos](#samples-and-videos)


## Requirements

* Android Studio
* Xcode
* Cordova CLI (Get it from [here](https://cordova.apache.org/docs/en/latest/guide/cli/))
* Node.js/npm (Get it from [here](https://docs.npmjs.com/getting-started/installing-node))

## Installation

  Before adding the Bluemix Push Notifications Cordova plugin, create Cordova project and add platforms.

### Creating a Cordova application

1. Run the following commands to create a new Cordova application. Alternatively you can use an existing application as well.

	```Bash
	cordova create {your_app_name}
	cd {your_app_name}
	```

1. Edit `config.xml` file and set the desired application name in the `<name>` element instead of a default HelloCordova.

2. Continue editing `config.xml`. Update the `<platform name="ios">` element with a deployment target declaration as shown in the code snippet below.

	```XML
	<platform name="ios">
		<preference name="deployment-target" value="8.0" />
		<!-- add deployment target declaration -->
	</platform>
	```

3. Continue editing `config.xml`. Update the `<platform name="android">` element with a minimum and target SDK versions as shown in the code snippet below.

	```XML
	<platform name="android">
		<preference name="android-minSdkVersion" value="15" />
		<preference name="android-targetSdkVersion" value="23" />
		<!-- add minimum and target Android API level declaration -->
	</platform>
	```

>**Note**: The minSdkVersion should be above 15.

>**Note**: The targetSdkVersion should always reflect the latest Android SDK available from Google.

### Adding Cordova platforms

Run the following commands according to which platform you want to add to your Cordova application

```
cordova platform add ios

cordova platform add android

```
**IMPORTANT: Make sure you use this iOS version for the Cordova platform. It is required for the Cordova app to build.**

### Adding the Cordova Bluemix Push plugin

From your Cordova application root directory, enter the following command to install the Cordova Push plugin.

```
cordova plugin add bms-push

```

This also installs the `Cordova Core plug-in`, which initializes your connection to Bluemix.

From your app root folder, verify that the Cordova `Core plugin` and `Push plugin` were installed successfully, using the following command.

```
cordova plugin list

```

>Note: Existing 3rd party push notification plugins (e.g., phonegap) may interfere with bms-push. Be sure to remove these plugins to ensure proper funcitonality.


## Setup Client Application

### Setup App environments

#### iOS App

1. Add the project name in the following way at the top of your `AppDelegate.m`

  ```
  #import "[your-project-name]-Swift. h"
  ```
  If your project name has spaces or hyphens, replace them with underscores in the import statement. Example,

  ```
  // Project name is "Test Project" or "Test-Project"

  #import "Test_Project-Swift.h"
  ```

2. Add the code below to your application delegate,

  ```
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
3. In the Capabilities enable `push notifications` and `Background modes`. Under `Background modes` enable the `Remote notification` and `background fetch`.

#### Android App

Download your Firebase google-services.json for android, and place them in the root folder of your cordova project: `[your-app-name]/platforms/android`

Go to `[your-app-name]/platforms/android`,

1) Open file `build.gradle` (Path : platform > android > build.gradle)

2) find `buildscript` text in `build.gradle` file.

3) There you will find one classpath line, after that line, please add this line ,

```
classpath 'com.google.gms:google-services:3.0.0'
```

4) Then find "dependencies" .Select that dependencies where you have text `compile` and where that dependecies is getting ended, just after that, add this line :

```
	apply plugin: 'com.google.gms.google-services'
```

### Initialize

#### Initializing the Core plugin

Initialize the `bms-core` plugin following way,

```
onDeviceReady: function() {
    app.receivedEvent('deviceready');
    BMSClient.initialize("YOUR APP REGION");
    }
```
For the region pass one of the following ,

* REGION_US_SOUTH // ".ng.bluemix.net";
* REGION_UK //".eu-gb.bluemix.net";
* REGION_SYDNEY // ".au-syd.bluemix.net";

For example,

```
BMSClient.initialize(BMSClient.REGION_US_SOUTH);

```

#### Initializing the Push Plugin

Initialize the `BMSPush` in the following way,

```
var options =  {};
BMSPush.initialize(appGUID,clientSecret,options);

```
##### appGUID

- The Push service instance Id value.

##### clientSecret

- The Push service instance client secret value.

##### options

- Push notification options (Interactive notifiaction and custom deviceId)


### Register to Push Service

#### Register Without UserId

To register without userId use the following pattern

```
var success = function(response) { console.log("Success: " + response); };
var failure = function(response) { console.log("Error: " + response); };

var options = {};
BMSPush.registerDevice(options, success, failure);

```

#### Register With UserId

The `userId` can be specified while registering the device with Push Notifications service. The register method will accept one more parameter - `userId`

```
var success = function(response) { console.log("Success: " + response); };
var failure = function(response) { console.log("Error: " + response); };

var options = {"userId": "Your User Id value"};
BMSPush.registerDevice(options, success, failure);

```

##### userId

- The user identifier value you want to register the device in the push service instance.

>**Note**: If userId is provided the client secret value must be provided.


#### Unregistering the Device from Push Notification

Use the following code snippets to unregister the device from push notification service instance

```
var success = function(response) { console.log("Success: " + response); };
var failure = function(response) { console.log("Error: " + response); };
BMSPush.unregisterDevice(options, success, failure);

```

#### Unregistering the Device from UserId

To unregister from the `UserId` based registration you have to call the registration method [without userId](#register-without-userid).


#### Receiving a Notification

Add the following code snippet to receive push notification call back.

```
var handleNotificationCallback = function(notification) {
	// notification is a JSON object
	alert(notification.message);
}

BMSPush.registerNotificationsCallback(handleNotificationCallback);

```

### Push Notification service tags

#### Retrieve Available tags

The `retrieveAvailableTags()` API returns the list of tags to which the device
can subscribe. After the device is subscribes to a particular tag, the device can receive notifications
that are sent for that tag.

Use the following code snippets into your Swift mobile application to get a list of tags to which the
device can subscribe.

```
var failure = function(response) { console.log("Error: " + response); };

BMSPush.retrieveAvailableTags(function(tags) {
	alert(tags);
}, failure);

```

#### Subscribe to tags

The `subscribe()` API will subscribe the iOS device for the list of given tags. After the device is subscribed to a particular tag, the device can receive any push notifications
that are sent for that tag.

Use the following code snippets into your Swift mobile application to subscribe a list of tags.

```
var success = function(response) { console.log("Success: " + response); };
var failure = function(response) { console.log("Error: " + response); };

var tag = "YourTag";
BMSPush.subscribe(tag, success, failure);

```

#### Retrieve Subscribed tags

The `retrieveSubscriptions()` API will return the list of tags to which the device is subscribed.

Use the following code snippets into your Swift mobile application to get the  subscription list.

```
var failure = function(response) { console.log("Error: " + response); };

BMSPush.retrieveSubscriptions(function(tags) {
	alert(tags);
}, failure);

```

#### Unsubscribing from tags

The `unsubscribe()` API will remove the device subscription from the list tags.

Use the following code snippets to unsubsribe from tags

```
var success = function(response) { console.log("Success: " + response); };
var failure = function(response) { console.log("Error: " + response); };

var tag = "YourTag";
BMSPush.unsubscribe(tag, success, failure);

```


### Notification Options

#### Enable Interactive push notifications

To enable interactive push notifications, the notification action parameters must be passed in as part of the notification object.  The following is a sample code to enable interactive notifications.

```
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
                      ]
                  };

BMSPush.initialize(appGUID, clientSecret, options);
```

#### Adding custom DeviceId for registration

To send `DeviceId` use the `options` parameter in `initialize method` of `BMSPush` class.

```
var options ={
  "devieID":"mydeviceId"
};

BMSPush.initialize(appGUID, clientSecret, options);
```

## Samples and Videos

* Please visit for samples - [Github Sample](https://github.com/ibm-bluemix-mobile-services/bms-samples-cordova-hellopush)

* Video Tutorials Available here - [Bluemix Push Notifications](https://www.youtube.com/channel/UCRr2Wou-z91fD6QOYtZiHGA)

=======================

Copyright 2016-17 IBM Corp.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
