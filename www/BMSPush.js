cordova.define("bms-push.BMSPush", function(require, exports, module) {
/*
    Copyright 2015 IBM Corp.
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
        http://www.apache.org/licenses/LICENSE-2.0
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/
var exec = require('cordova/exec');


var BMSPush = function() {

    var BMSPushClientString = "BMSPushClient";
	var success = function(message) {
        console.log(BMSPushClientString + ": Success: " + message);
    };
    var failure = function(message) {
        console.log(BMSPushClientString + ": Failure: " + message);
    };

    
	this.initialize = function(pushAppGuid, clientSecret, pushOptions){
		cordova.exec(success, failure, BMSPushClientString, "initialize", [pushAppGuid, clientSecret,pushOptions]);
	};
	/**
	 * Registers the device on to the IMFPush Notification Server
	 *
	 * @param settings 
	 *        userId: user id value
	 * @param success callback
	 * @param failure callback
	 */
	this.registerDevice = function(settings,success, failure) {
		cordova.exec(success, failure, BMSPushClientString, "registerDevice", [settings]);
	};

	/**
	 * Gets the Tags that are subscribed by the device 
	 * 
	 * @param success callback - recieves array of subscribed tags
	 * @param failure callback 
	 */
	this.retrieveSubscriptions = function(success, failure) {
		cordova.exec(success, failure, BMSPushClientString, "retrieveSubscriptions", []);
	};

	/**
	 * Gets all the available Tags for the backend mobile application
	 * 
	 * @param success callback
	 * @param failure callback
	 */
	this.retrieveAvailableTags = function(success, failure) {
		cordova.exec(success, failure, BMSPushClientString, "retrieveAvailableTags", []);
	};

	/**
	 * Subscribes to a particular backend mobile application Tag(s)
	 * 
	 * @param tags - The Tag array to subscribe to.
	 * @param success callback
	 * @param failure callback
	 */

	this.subscribe = function(tag, success, failure) {
		cordova.exec(success, failure, BMSPushClientString, "subscribe", [tag]);
	};

	/**
	 * Unsubscribes from an backend mobile application Tag(s)
	 * 
	 * @param  tags - The Tag name array to unsubscribe from.
	 * @param  success callback
	 * @param  failure callback
	 */

	this.unsubscribe = function(tag, success, failure) {
		cordova.exec(success, failure, BMSPushClientString, "unsubscribe", [tag]);
	};

	

	/**
	 * Unregisters the device from the IMFPush Notification Server
	 * 
	 * @param success callback
	 * @param failure callback
	 */
	this.unregisterDevice = function(success, failure) {
		cordova.exec(success, failure, BMSPushClientString, "unregisterDevice", []);
	};

	/**
	 * [registerIncomingNotificationListener description]
	 * 
	 * @param callback [description]
	 */
	this.registerNotificationsCallback = function(callback) {
		cordova.exec(callback, failure, BMSPushClientString , "registerNotificationsCallback", []);
	};
};

module.exports = new BMSPush();

});
