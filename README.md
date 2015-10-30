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
    - <a href="#using-mfppush">Using MFPPush</a>
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

<h3 id="bmsclient">MFPPush</h3>

    var success = function(message) { console.log("Success: " + messgae); };
    var failure = function(message) { console.log("Error: " + message); };
    
    MFPPush.register(success, failure);
    

MFPPush functions available:

Function | Use
--- | ---
`getSubscriptionStatus(success, failure)` | Gets the Tags that are subscribed by the device.
`retrieveAvailableTags(success, failure)` | Gets all the available Tags for the backend mobile application.
`subscribe(tags, success, failure)` | Subscribes to a particular backend mobile application Tag(s).
`unsubscribe(tags, success, failure)` | Unsubscribes from an backend mobile application Tag(s).
`register(settings, success, failure)` | Registers the device on to the IMFPush Notification Server.
`unregister(success, failure)` | Unregisters the device from the IMFPush Notification Server.
`registerIncomingNotificationListener(callback)` | description

