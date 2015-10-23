# IBM Bluemix Mobile Services - Client SDK Cordova

Cordova Plugin for IBM Bluemix Mobile Services Push SDK

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

MFPPush is... 

Example:
```
var success = function(message) { console.log("Success: " + messgae); };
var failure = function(message) { console.log("Error: " + message); };

MFPPush.register(success, failure);
```

MFPPush functions available:

Function | Use
--- | ---
`getSubscriptionStatus(success, failure)` | Gets the Tags that are subscribed by the device.
`retrieveAvailableTags(success, failure)` | Gets all the available Tags for the backend mobile application.
`subscribe(tags, success, failure)` | Subscribes to a particular backend mobile application Tag(s).
`unsubscribe(success, failure)` | Unsubscribes from an backend mobile application Tag(s)
`unregisterAuthenticationListener(realm)` | Unregisters the authentication callback for the specified realm.
