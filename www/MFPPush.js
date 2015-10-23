var exec = require('cordova/exec');

var MFPPush = {

	getSubscriptionStatus: function(success, failure) {},
	retrieveAvailableTags: function(success, failure) {},
	subscribe: function(tags, success, failure) {},
	unsubscribe: function(tags, success, failure) {},
	register: function(success, failure) {},
	unregister: function(success, failure) {},
	registerIncomingNotificationListener: function(callback) {}
};

module.exports = MFPPush;