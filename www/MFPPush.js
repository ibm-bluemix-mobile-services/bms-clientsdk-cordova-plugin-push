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

var MFPPush = {

	/**
	 * Gets the Tags that are subscribed by the device 
	 * 
	 * @param success callback - recieves array of subscribed tags
	 * @param failure callback 
	 */
	retrieveSubscriptions: function(success, failure) {
		cordova.exec(success, failure, "MFPPushPlugin", "retrieveSubscriptions", []);
	},

	/**
	 * Gets all the available Tags for the backend mobile application
	 * 
	 * @param success callback
	 * @param failure callback
	 */
	retrieveAvailableTags: function(success, failure) {
		cordova.exec(success, failure, "MFPPushPlugin", "retrieveAvailableTags", []);
	},

	/**
	 * Subscribes to a particular backend mobile application Tag(s)
	 * 
	 * @param tags - The Tag array to subscribe to.
	 * @param success callback
	 * @param failure callback
	 */

	subscribe: function(tag, success, failure) {
		cordova.exec(success, failure, "MFPPushPlugin", "subscribe", [tag]);
	},

	/**
	 * Unsubscribes from an backend mobile application Tag(s)
	 * 
	 * @param  tags - The Tag name array to unsubscribe from.
	 * @param  success callback
	 * @param  failure callback
	 */

	unsubscribe: function(tag, success, failure) {
		cordova.exec(success, failure, "MFPPushPlugin", "unsubscribe", [tag]);
	},

	/**
	 * Registers the device on to the IMFPush Notification Server
	 *
	 * @param settings:
	 *        iOS: { alert: boolean, badge: boolean, sound: boolean }
	 *        Android: { null }
	 * @param success callback
	 * @param failure callback
	 */
	registerDevice: function(settings, success, failure) {
		cordova.exec(success, failure, "MFPPushPlugin", "registerDevice", [settings]);
	},

	/**
	 * Unregisters the device from the IMFPush Notification Server
	 * 
	 * @param success callback
	 * @param failure callback
	 */
	unregisterDevice: function(success, failure) {
		cordova.exec(success, failure, "MFPPushPlugin", "unregisterDevice", []);
	},

	/**
	 * [registerIncomingNotificationListener description]
	 * 
	 * @param callback [description]
	 */
	registerNotificationsCallback: function(callback) {
		cordova.exec(callback, failure, "MFPPushPlugin", "registerNotificationsCallback", []);
	}
};

module.exports = MFPPush;