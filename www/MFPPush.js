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

var success = function(message) { console.log("Success: " + messgae); };
var failure = function(message) { console.log("Error: " + message); };

var MFPPush = {

	/**
	 * Gets the Tags that are subscribed by the device 
	 * 
	 * @param success callback - recieves array of subscribed tags
	 * @param failure callback 
	 */
	getSubscriptionStatus: function(success, failure) {},

	/**
	 * Gets all the available Tags for the backend mobile application
	 * 
	 * @param success callback
	 * @param failure callback
	 */
	retrieveAvailableTags: function(success, failure) {},

	/**
	 * Subscribes to a particular backend mobile application Tag(s)
	 * 
	 * @param tagsArray - The Tag array to subscribe to.
	 * @param success callback
	 * @param failure callback
	 */
	subscribe: function(tags, success, failure) {},

	/**
	 * Unsubscribes from an backend mobile application Tag(s)
	 * 
	 * @param  tagsArray - The Tag name array to unsubscribe from.
	 * @param  success callback
	 * @param  failure callback
	 */
	unsubscribe: function(tags, success, failure) {},

	/**
	 * Registers the device on to the IMFPush Notification Server
	 * 
	 * @param success callback
	 * @param failure callback
	 */
	register: function(success, failure) {},

	/**
	 * Unregisters the device from the IMFPush Notification Server
	 * 
	 * @param success callback
	 * @param failure callback
	 */
	unregister: function(success, failure) {},

	/**
	 * [registerIncomingNotificationListener description]
	 * 
	 * @param callback [description]
	 */
	registerIncomingNotificationListener: function(callback) {}
};

module.exports = MFPPush;