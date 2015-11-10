# IBM Bluemix Mobile Services - Push SDK Cordova

Cordova Plugin for the IBM Bluemix Mobile Services Push SDK

## Contents
- <a href="#installation">Installation</a>
- <a href="#configuration">Configuration</a>
    - <a href="#configure-ios">Configure Your iOS Development Environment</a>
    - <a href="#configure-android">Configure Your Android Development Environment</a>
- <a href="#usage">Usage</a>
    - <a href="#mfppush">MFPPush</a>
- <a href="#examples">Examples</a> 
    - <a href="#ex-register">Register for Push Notifications</a>
    - <a href="#ex-subscribe">Subscribe and Unsubscribe to/from Tags</a>
    - <a href="#ex-retrieve">Retrieve Tags</a>
    - <a href="#ex-notification">Receiving a Notification</a>
- <a href="#release-notes">Release Notes</a> 

<h3 id="mfppush">MFPPush</h3>

MFPPush provides methods to let you set up your application for registering and receiving push notifications.

<h2 id="installation">Installation</h2>

### Add the Cordova plugin

Run the following command from your Cordova application's root directory to add the ibm-mfp-push plugin:

    $ cordova plugin install ibm-mfp-push

You can check if the plugin installed successfully by running the following command, which lists your installed Cordova plugins:

    $ cordova plugin list

<h2 id="configuration">Configuration</h2>

<h3 id="configure-ios">Configure Your iOS Development Environment</h3>

Follow the instructions here to configure your Xcode environment [https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-core/tree/development#configure-ios](https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-cordova-plugin-core/tree/development#configure-ios)

<h3 id="configure-android">Configure Your Android Development Environment</h3>

Add the notification intent settings for the activity. This setting starts the application when the user clicks the received notification from the notification area. 

    !--Notification Intent -->
    <intent-filter>
        <action android:name="YOUR.PKG.NAME.IBMPushNotification>
        <category  android:name="android.intent.category.DEFAULT
    </intent-filter>"
  
Add the Google Cloud Messaging (GCM) intent service and intent filters for the RECEIVE event notifications. 

    <!-- Add GCM Intent Service and intent-filters for RECEIVE and REGISTRATION of notifications -->
    <service android:name="com.ibm.mobilefirstplatform.clientsdk.android.push.api.MFPPushIntentService" />
        <receiver
            android:name="com.ibm.mobilefirstplatform.clientsdk.android.push.internal.MFPPushBroadcastReceiver"
            android:permission="com.google.android.c2dm.permission.SEND" >
        <intent-filter>
            <action android:name="com.google.android.c2dm.intent.RECEIVE" />
    
            <category android:name="YOUR.PKG.NAME" />
        </intent-filter>
        <intent-filter>
            <action android:name="android.intent.action.BOOT_COMPLETED" />
    
            <category android:name="YOUR.PKG.NAME" />
        </intent-filter>
    </receiver>
    <!-- Push Settings End -->

<h2 id="usage">Usage</h2>

MFPPush functions available:

Function | Use
--- | ---
`retrieveSubscriptions(success, failure)` | Retrieves the tags that are subscribed by the device.
`retrieveAvailableTags(success, failure)` | Retrieves all the available tags for the backend mobile application.
`subscribe(tag, success, failure)` | Subscribes to a particular backend mobile application tag.
`unsubscribe(tag, success, failure)` | Unsubscribes from an backend mobile application tag.
`registerDevice(settings, success, failure)` | Registers the device with the IMFPush Notification Server.
`unregisterDevice(success, failure)` | Unregisters the device from the IMFPush Notification Server.
`registerNotificationsCallback(callback)` | Registers a callback for when a notification arrives on the device.

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

The settings structure contains the settings that you want to enable for push notifications. You must use the defined structure and only changed the boolean value of each notification setting.

To unregister for push notifications simply call the following:

    MFPPush.unregisterDevice(success, failure);
    
<h4 id="ex-retrieve">Retrieve Tags</h4>

Return an array of tags the the user is currently subscribed using the following:

    MFPPush.retrieveSubscriptions(function(tags) {
        // alert(tags);
    }, failure);
    
Return an array of tags that are available to subscribe to using the following:

    MFPPush.retrieveAvailableTags(function(tags) {
        // alert(tags);
    }, failure);
    
In both examples the success callback contains a parameter for the array of tags which is returned. The second null parameter is callback function called on error.

<h4 id="ex-subscribe">Subscribe and Unsubscribe to/from Tags</h4>

    var tag = "YourTag";

    MFPPush.subscribe(tag, success, failure);
    
    MFPPush.unsubscribe(tag, success, failure);
    
<h4 id="ex-notification">Receiving a Notification</h4>

    var handleNotification = function(notif) {
        // notif is a dictionary containing your notification 
    }

    MFPPush.registerNotificationsCallback(handleNotification);
    
<h2 id="release-notes">Release Notes</h2>

Copyright 2015 IBM Corp.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
