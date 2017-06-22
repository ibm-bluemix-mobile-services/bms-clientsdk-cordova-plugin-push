Bluemix Push Notifications Cordova SDK
===================================================

[![](https://img.shields.io/badge/bluemix-powered-blue.svg)](https://bluemix.net)
[![Build Status](https://travis-ci.org/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-push.svg?branch=master)](https://travis-ci.org/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-push)
[![npm](https://img.shields.io/npm/v/bms-push.svg)](https://www.npmjs.com/package/bms-push)
[![npm](https://img.shields.io/npm/dm/bms-push.svg)](https://www.npmjs.com/package/bms-push)

[![npm package](https://nodei.co/npm/bms-push.png?downloads=true&downloadRank=true&stars=true)](https://nodei.co/npm/bms-push/)

The [Bluemix Push Notifications service](https://console.ng.bluemix.net/catalog/services/push-notifications) provides a unified push service to send real-time notifications to mobile and web applications. The Push Notifications Cordova Plugin Push SDK enables Cordova apps to receive notifications sent from the service. 

Ensure that you go through [Bluemix Push Notifications service documentation](https://console.ng.bluemix.net/docs/services/mobilepush/index.html#gettingstartedtemplate) before you start.

## Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Initialize SDK](#initialize-sdk)
  - [Initialize the core plugin](#initialize-the-core-plugin)
  - [Initialize the Push plugin](#initialize-the-push-plugin)
- [Register for notifications](#register-for-notifications)
  - [Receiving notifications](#receiving-notifications)
- [Push Notification service tags](#push-notification-service-tags)
  - [Retrieve available tags](#retrieve-available-tags)
  - [Subscribe to tags](#subscribe-to-tags)
  - [Retrieve subscribed tags](#retrieve-subscribed-tags)
  - [Unsubscribing from tags](#unsubscribing-from-tags)
- [Notification Options](#notification-options)
  - [Interactive notifications](#interactive-notifications)
  - [Adding custom DeviceId for registration](#adding-custom-deviceid-for-registration)
- [Samples and Videos](#samples-and-videos)


## Prerequisites 

* [Android Studio](https://developer.android.com/studio/index.html)
* Xcode
* [Cordova CLI](https://cordova.apache.org/docs/en/latest/guide/cli/))
* [Node.js/npm](https://docs.npmjs.com/getting-started/installing-node))

## Installation

You need to create a Cordova project and add platforms before adding the Bluemix Push Notifications Cordova Plugin Push SDK. Complete the following steps:

1. Create a Cordova application:

	1. Run the following commands to create a new Cordova application. Alternatively, you can use an existing application as well.
		```Bash
		cordova create {your_app_name}
		cd {your_app_name}
		```
	2. Edit `config.xml` file and set the desired application name in the `<name>` element instead of a default `HelloCordova`.
	3. In the `config.xml` file, update the `<platform name="ios">` element with a deployment target declaration. See the code snippet.
		```XML
		<platform name="ios">
			<preference name="deployment-target" value="8.0" />
			<!-- add deployment target declaration -->
		</platform>
		```
	3. In the `config.xml` file update the `<platform name="android">` element with a minimum and target SDK versions as shown in the code snippet below.
		```XML
		<platform name="android">
			<preference name="android-minSdkVersion" value="15" />
			<preference name="android-targetSdkVersion" value="23" />
			<!-- add minimum and target Android API level declaration -->
		</platform>
		```

	>**Note**: The minSdkVersion should be above 15 and the targetSdkVersion should always reflect the latest Android SDK available from Google.

2. Add the Cordova platforms. Run either of the following commands, based on your platform:
	- For iOS: `cordova platform add ios`
	- For Android: `cordova platform add android`
	
	Ensure that you use the iOS version specified through this command for the Cordova platform. It is required to build the Cordova app.

3. Add the Cordova Bluemix Push plugin. From your Cordova application root directory, enter the following command to install the Cordova Push plugin.
	```
	cordova plugin add bms-push
	```

	This also installs the `Cordova Core plug-in`, which initializes your connection to Bluemix.

4. From your app root folder, verify that the Cordova `Core plugin` and `Push plugin` were installed successfully, using the command:
	```
	cordova plugin list
	```

>**Note**: Existing vendor-acquired Push Notification plugins (e.g., phonegap) may interfere with bms-push. Remove these plugins to ensure proper functionality.


## Initialize SDK

Choose either of the following steps, based on your platform:

- For iOS: 

	1. Add the project name in the following way at the top of your `AppDelegate.m`.
	
		  ```
		  #import "[your-project-name]-Swift. h"
		  ```
	
		  If your project name has spaces or hyphens, replace them with underscores in the import statement. For example:
	
		  ```
		  // Project name is "Test Project" or "Test-Project"
		  #import "Test_Project-Swift.h"
		  ```
	2. Add the code below to your application delegate:  
			```
			//Register device token with Bluemix Push Notification Service
		 	 - (void)application:(UIApplication *)application
	  	 		didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
		  	   [[CDVBMSPush sharedInstance] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
	 		 	}
			//Handle error when failed to register device token with APNs
		  	- (void)application:(UIApplication*)application
	  			 didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
		  	  [[CDVBMSPush sharedInstance] didFailToRegisterForRemoteNotificationsWithError:error];
	 		 }
	 		//Handle receiving a remote notification
			  -(void)application:(UIApplication *)application
	  		didReceiveRemoteNotification:(NSDictionary *)userInfo
	  		fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	  		[[CDVBMSPush sharedInstance] didReceiveRemoteNotificationWithNotification:userInfo];
	  			}
	 		//Handle receiving a remote notification on launch
			  - (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
	   		 -----------
	     	 if (!launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
	          [[CDVBMSPush sharedInstance] didReceiveRemoteNotificationOnLaunchWithLaunchOptions:launchOptions];
	     		 }
	    		-----------
	 			 }
	  		```
	3. In the Capabilities, enable `push notifications` and `Background modes`. Under `Background modes` enable the `Remote notification` and `background fetch`.

- For Android App

	1. Download your Firebase google-services.json for android, and place them in the root folder of your cordova project -`[your-app-name]/platforms/android`.
	2. Open the `[your-app-name]/platforms/android`folder.
	3. Open file `build.gradle`. You can access this file at platforms/android/build.gradle.
	4. Find `buildscript` text in `build.gradle` file.
	5. Find the classpath line. Add the `classpath 'com.google.gms:google-services:3.0.0'` snippet. 
	6. Find "dependencies". Select dependencies where you have text `compile` and where that dependencies is getting ended. Add the line:
	  ```
	apply plugin: 'com.google.gms.google-services'
	```

### Initialize the core plugin

Initialize the `bms-core` plugin. Run the following snippet:

```
onDeviceReady: function() {
    app.receivedEvent('deviceready');
    BMSClient.initialize("YOUR APP REGION");
    }
```
For the region, pass any of the following:

* `REGION_US_SOUTH` // ".ng.bluemix.net";
* `REGION_UK` //".eu-gb.bluemix.net";
* `REGION_SYDNEY` // ".au-syd.bluemix.net";

For example:
```
  BMSClient.initialize(BMSClient.REGION_US_SOUTH);
```

### Initialize the Push plugin

Initialize the `BMSPush`. Run the following snippet:

```
var options =  {};
BMSPush.initialize(appGUID,clientSecret,options);
```

Where `appGUID` is the Push service instance Id value, clientSecret` is the Push service instance client secret value and `options`can be notification options such as interactive notifiaction and custom deviceId.


## Register for notifications

Use the `BMSPush.registerDevice()` API to register the device with Push Notifications service. 

The following options are supported:


- Register without UserId

	To register without userId, use the following pattern:
	  ```
	  var success = function(response) { console.log("Success: " + response); };
	  var failure = function(response) { console.log("Error: " + response); };
	  var options = {};
	  BMSPush.registerDevice(options, success, failure);
	  ```

- Register with UserId

	The `userId` can be specified while registering the device with Push Notifications service. The register method will accept one more parameter - `userId`

	  ```
	  var success = function(response) { console.log("Success: " + response); };
	  var failure = function(response) { console.log("Error: " + response); };
	  var options = {"userId": "Your User Id value"};
	  BMSPush.registerDevice(options, success, failure);
	  ```

	Where ÙserId is the user identifier value you want to register the device in the push service instance.

	>**Note**: If userId is provided, the client secret value must be provided.

- Unregister from notifications

	Use the following code snippet to unregister the device from push notification service instance:
		```
		var success = function(response) { console.log("Success: " + response); };
		var failure = function(response) { console.log("Error: " + response); };
		BMSPush.unregisterDevice(options, success, failure);
		```

- Unregister the device from UserId

	To unregister from the `UserId` based registration you have to call the registration method - without userId.


### Receiving notifications

To receive push notification call back, add the following code snippet:

```
  var handleNotificationCallback = function(notification) {
  	// notification is a JSON object
  	alert(notification.message);
  }
  BMSPush.registerNotificationsCallback(handleNotificationCallback);
```

## Push Notification service tags

### Retrieve available tags

The `retrieveAvailableTags()` API returns the list of tags to which the device
can subscribe. After the device is subscribes to a particular tag, the device can receive notifications that are sent for that tag.

Add the following code snippets to your Swift mobile application to get a list of tags to which the device can subscribe:

```
  var failure = function(response) { console.log("Error: " + response); };
  BMSPush.retrieveAvailableTags(function(tags) {
  	alert(tags);
  }, failure);
```

### Subscribe to tags

The `subscribe()` API will subscribe the iOS device for the list of given tags. After the device is subscribed to a particular tag, the device can receive push notifications that are sent for that tag.

Add the following code snippets to your Swift mobile application to subscribe to a list of tags:

```
  var success = function(response) { console.log("Success: " + response); };
  var failure = function(response) { console.log("Error: " + response); };
  var tag = "YourTag";
  BMSPush.subscribe(tag, success, failure);
```

### Retrieve subscribed tags

The `retrieveSubscriptions()` API will return the list of tags to which the device is subscribed. 

Add the following code snippets to your Swift mobile application to get the  subscription list:
```
  var failure = function(response) { console.log("Error: " + response); };
  BMSPush.retrieveSubscriptions(function(tags) {
  	alert(tags);
  }, failure);
```

### Unsubscribing from tags

The `unsubscribe()` API will remove the device subscription from the list tags.

Use the following code snippets to unsubsribe from tags:

```
  var success = function(response) { console.log("Success: " + response); };
  var failure = function(response) { console.log("Error: " + response); };
  var tag = "YourTag";
  BMSPush.unsubscribe(tag, success, failure);
```


## Notification options

The following notification options are supported.

### Interactive notifications

To enable interactive push notifications, the notification action parameters must be passed in as part of the notification object. For example:

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

### Adding custom DeviceId for registration

To send `DeviceId`, use the `options` parameter in `initialize method` of `BMSPush` class. For example:

```
  var options ={
    "devieID":"mydeviceId"
  };
  BMSPush.initialize(appGUID, clientSecret, options);
```

## Samples and Videos

* For samples, visit - [Github Sample](https://github.com/ibm-bluemix-mobile-services/bms-samples-cordova-hellopush)

* For video tutorials, visit - [Bluemix Push Notifications](https://www.youtube.com/channel/UCRr2Wou-z91fD6QOYtZiHGA)

=======================

Copyright 2016-17 IBM Corp.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
