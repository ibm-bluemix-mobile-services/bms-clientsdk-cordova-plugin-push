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

/**
 * Cordova module to handle devive requests.
 * @module BMSPush
 */

var BMSPush = function() {

    var BMSPushClientString = "BMSPushClient";
	var success = function(message) {
        console.log(BMSPushClientString + ": Success: " + message);
    };
    var failure = function(message) {
        console.log(BMSPushClientString + ": Failure: " + message);
	};
	
	
    this.REGION_US_SOUTH = ".ng.bluemix.net";
    this.REGION_UK = ".eu-gb.bluemix.net";
    this.REGION_SYDNEY = ".au-syd.bluemix.net";
    this.REGION_GERMANY = ".eu-de.bluemix.net";
    this.REGION_US_EAST = ".us-east.bluemix.net";
    this.REGION_JP_TOK = ".jp-tok.bluemix.net";

	/**
     * Sets the base URL for the authorization server.
     * <p>
     * This method should be called before you send the first request that requires authorization.
     * </p>
	 * @param {string} pushAppGuid AppGUID from IBM cloud Push Notifications instance
	 * @param {string} clientSecret ClientSecret from IBM cloud Push Notifications instance
	 * @param {string} bluemixRegion Specifies the region of the application
	 * @param {json} pushOptions  Initialize options like categories, deviceId and variable
	 * @method module:BMSPush#initialize
     */

	this.initialize = function(pushAppGuid, clientSecret, bluemixRegion, pushOptions){
		cordova.exec(success, failure, BMSPushClientString, "initialize", [pushAppGuid, clientSecret,bluemixRegion, pushOptions]);
	};
	/**
	 * Registers the device on to the IMFPush Notification Server
	 *
	 * @param {json} settings 
	 *        userId: user id value
	 * @param {Object} success callback
	 * @param {Object} failure callback
	 * @method module:BMSPush#registerDevice
	 */
	this.registerDevice = function(settings,success, failure) {
		cordova.exec(success, failure, BMSPushClientString, "registerDevice", [settings]);
	};

	/**
	 * Gets the Tags that are subscribed by the device 
	 * 
	 * @param {Object} success callback - recieves array of subscribed tags
	 * @param {Object} failure callback
	 * @method module:BMSPush#retrieveSubscriptions 
	 */
	this.retrieveSubscriptions = function(success, failure) {
		cordova.exec(success, failure, BMSPushClientString, "retrieveSubscriptions", []);
	};

	/**
	 * Gets all the available Tags for the backend mobile application
	 * 
	 * @param {Object} success callback
	 * @param {Object} failure callback
	 * @method module:BMSPush#retrieveAvailableTags 
	 */
	this.retrieveAvailableTags = function(success, failure) {
		cordova.exec(success, failure, BMSPushClientString, "retrieveAvailableTags", []);
	};

	/**
	 * Subscribes to a particular backend mobile application Tag(s)
	 * 
	 * @param {string[]} tags - The Tag array to subscribe to.
	 * @param {Object} success callback
	 * @param {Object} failure callback
	 * @method module:BMSPush#subscribe 
	 */
	this.subscribe = function(tag, success, failure) {
		cordova.exec(success, failure, BMSPushClientString, "subscribe", [tag]);
	};

	/**
	 * Unsubscribes from an backend mobile application Tag(s)
	 * 
	 * @param  {string[]} tags - The Tag name array to unsubscribe from.
	 * @param  {Object} success callback
	 * @param  {Object} failure callback
	 * @method module:BMSPush#unsubscribe 
	 */
	this.unsubscribe = function(tag, success, failure) {
		cordova.exec(success, failure, BMSPushClientString, "unsubscribe", [tag]);
	};

	

	/**
	 * Unregisters the device from the IMFPush Notification Server
	 * 
	 * @param {Object} success callback
	 * @param {Object} failure callback
	 * @method module:BMSPush#unregisterDevice
	 */
	this.unregisterDevice = function(success, failure) {
		cordova.exec(success, failure, BMSPushClientString, "unregisterDevice", []);
	};

	/**
	 * A listner to the incoming notifications 
	 * 
	 * @param {Object} callback A listner object
	 * @method module:BMSPush#registerNotificationsCallback
	 */
	this.registerNotificationsCallback = function(callback) {
		cordova.exec(callback, failure, BMSPushClientString , "registerNotificationsCallback", []);
	};

	/**
	 * A listner to changes in the notifications status
	 * 
	 * @param {Object} callback A listner object
	 * @method module:BMSPush#setNotificationStatusListener
	 */
	this.setNotificationStatusListener = function(callback) {
    	cordova.exec(callback, failure, BMSPushClientString , "setNotificationStatusListener", []);
    };
};

module.exports = new BMSPush();
