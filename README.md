IBM Cloud Push Notifications Cordova SDK
===================================================

[![](https://img.shields.io/badge/bluemix-powered-blue.svg)](https://bluemix.net)
[![Build Status](https://travis-ci.org/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-push.svg?branch=master)](https://travis-ci.org/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-push)
[![npm](https://img.shields.io/npm/v/bms-push.svg)](https://www.npmjs.com/package/bms-push)
[![npm](https://img.shields.io/npm/dm/bms-push.svg)](https://www.npmjs.com/package/bms-push)

[![npm package](https://nodei.co/npm/bms-push.png?downloads=true&downloadRank=true&stars=true)](https://nodei.co/npm/bms-push/)

The [IBM Cloud Push Notifications service](https://cloud.ibm.com/catalog/services/push-notifications) provides a unified push service to send real-time notifications to mobile and web applications. The Push Notifications Cordova Plugin Push SDK enables Cordova apps to receive notifications sent from the service. 

Ensure that you go through [IBM Cloud Push Notifications service documentation](https://cloud.ibm.com/docs/services/mobilepush?topic=mobile-pushnotification-gettingstartedtemplate#gettingstartedtemplate) before you start.

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
	- [Handling interactive notifications click](#handling-interactive-notifications-click)
  - [Adding custom DeviceId for registration](#adding-custom-deviceid-for-registration)
- [Methods usage](#usage)
- [Samples and Videos](#samples-and-videos)


## Prerequisites 

* [Android Studio](https://developer.android.com/studio/index.html)
* Xcode
* [Cordova CLI](https://cordova.apache.org/docs/en/latest/guide/cli/))
* [Node.js/npm](https://docs.npmjs.com/getting-started/installing-node))

## Installation

You need to create a Cordova project and add platforms before adding the IBM Cloud Push Notifications Cordova Plugin Push SDK. Complete the following steps:

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
			<preference name="android-targetSdkVersion" value="26" />
			<!-- add minimum and target Android API level declaration -->
		</platform>
		```

	>**Note**: The minSdkVersion should be above 15 and the targetSdkVersion should always reflect the latest Android SDK available from Google.

2. Add the Cordova platforms. Run either of the following commands, based on your platform:
	- For iOS: `cordova platform add ios`
	- For Android: `cordova platform add android`
	
	Ensure that you use the iOS version specified through this command for the Cordova platform. It is required to build the Cordova app.

3. Add the Cordova IBM Cloud Push plugin. From your Cordova application root directory, enter the following command to install the Cordova Push plugin.
	```
	cordova plugin add bms-push
	```

	This also installs the `Cordova Core plug-in`, which initializes your connection to IBM Cloud.

4. From your app root folder, verify that the Cordova `Core plugin` and `Push plugin` were installed successfully, using the command:
	```
	cordova plugin list
	```

>**Note**: Existing vendor-acquired Push Notification plugins (e.g., phonegap) may interfere with bms-push. Remove these plugins to ensure proper functionality.


## Initialize SDK

Choose either of the following steps, based on your platform:

- For iOS: 

	1. In the Capabilities, enable `push notifications` and `Background modes`. Under `Background modes` enable the `Remote notification` and `background fetch`.
    2. Add signing certificates

- For Android App

	1. Download your Firebase google-services.json for android, and place them in the root folder of your cordova project -`[your-app-name]/platforms/android`.

For `Android Studion 3.+` users, update the build.gradle file with the folowing - 

Change the,
```
debugCompile project(path: 'CordovaLib', configuration: 'debug') 
releaseCompile project(path: 'CordovaLib', configuration: 'release')
```

to 

```
compile project(':CordovaLib')
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
* `REGION_GERMANY` // ".eu-de.bluemix.net"
* `REGION_TOKYO` // ".jp-tok.bluemix.net"
* `REGION_US_EAST` // ".us-east.bluemix.net"

For example:
```
  BMSClient.initialize(BMSClient.REGION_US_SOUTH);
```

### Initialize the Push plugin

Initialize the `BMSPush`. Run the following snippet:

- Initialize without options

  ```

    // Initialize for normal push notifications
    var options =  {};
    BMSPush.initialize(appGUID,clientSecret,options);
  ```

- Initialize with options

  ```
    // Initialize for iOS actionable push notifications, custom deviceId and varibales for Parameterize Push Notifications 
    var options = {"categories":{
                "Category_Name1":[
                    { "IdentifierName":"IdentifierName_1",
                      "actionName":"actionName_1",
                      "IconName":"IconName_1"
                    },
                    { "IdentifierName":"IdentifierName_2",
                      "actionName":"actionName_2",
                      "IconName":"IconName_2"
                    }
                ]},
                "deviceId":"mydeviceId",
                "variables":{"username":"UserName","accountNumber":"536475869765475869"}
            };

    BMSPush.initialize(appGUID, clientSecret, options);
  ```

Where `appGUID` is the Push service instance Id value, clientSecret` is the Push service instance client secret value and `options`can be notification options such as interactive notifiaction and custom deviceId.


## Register for notifications

Use the `BMSPush.registerDevice()` API to register the device with Push Notifications service. 

The following options are supported:


- Register without UserId

	To register without userId, use the following pattern:
	 
  ```JS
	  var success = function(response) { console.log("Success: " + response); };
	  var failure = function(response) { console.log("Error: " + response); };
	  var options = {};
	  BMSPush.registerDevice(options, success, failure);
	```

- Register with UserId

	The `userId` can be specified while registering the device with Push Notifications service. The register method will accept one more parameter - `userId`

	```JS
	  var success = function(response) { console.log("Success: " + response); };
	  var failure = function(response) { console.log("Error: " + response); };
	  var options = {"userId": "Your User Id value"};
	  BMSPush.registerDevice(options, success, failure);
	```

	Where UserId is the user identifier value you want to register the device in the push service instance.

	>**Note**: If userId is provided, the client secret value must be provided.

- Unregister from notifications

	Use the following code snippet to unregister the device from push notification service instance:
		
  ```JS
		var success = function(response) { console.log("Success: " + response); };
		var failure = function(response) { console.log("Error: " + response); };
		BMSPush.unregisterDevice(options, success, failure);
	```

- Unregister the device from UserId

	To unregister from the `UserId` based registration you have to call the registration method - without userId.


### Receiving notifications

To receive push notification call back, add the following code snippet:

```JS
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

```JS
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

### Handling interactive notifications click

To identify which action clicked use the following,

```
var showNotification = function(notif) {
    var identifierName = notif["identifierName"];
    alert(identifierName);
};
```
### Adding custom DeviceId for registration

To send `DeviceId`, use the `options` parameter in `initialize method` of `BMSPush` class. For example:

```
  var options ={
    "devieID":"mydeviceId"
  };
  BMSPush.initialize(appGUID, clientSecret, options);
```

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


## Samples and Videos

* For samples, visit - [Github Sample](https://github.com/ibm-bluemix-mobile-services/bms-samples-cordova-hellopush)

* For video tutorials, visit - [IBM Cloud Push Notifications](https://www.youtube.com/playlist?list=PLTroxxTPN9dIZYn9IU-IOcQePO-u5r0r4)

=======================

Copyright 2020-21 IBM Corp.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
