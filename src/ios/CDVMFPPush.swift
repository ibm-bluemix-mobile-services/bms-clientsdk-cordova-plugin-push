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

import Foundation
import IMFCore
import IMFPush
import UIKit


@objc(CDVMFPPush) class CDVMFPPush : CDVPlugin {
    
    static let sharedInstance = CDVMFPPush()
    
    let push = IMFPushClient.sharedInstance()

    var registerCallbackId: String?
    var registerCommandDelegate: CDVCommandDelegate?
    
    var notifCallbackId: String?
    var notifCommandDelegate: CDVCommandDelegate?
    
    /*
    * Registers the device with APNs
    */
    func registerDevice(command: CDVInvokedUrlCommand) {
        
        CDVMFPPush.sharedInstance.registerCallbackId = command.callbackId
        CDVMFPPush.sharedInstance.registerCommandDelegate = self.commandDelegate

        self.commandDelegate!.runInBackground({
            
            var types = UIUserNotificationType()
            
            // If settings parameter is null then use default settings
            if (command.arguments[0] is NSNull) {
                types.insert(.Alert)
                types.insert(.Badge)
                types.insert(.Sound)
            }
            
            // Settings parameter not null
            else {
                
                guard let settings = command.arguments[0] as? NSDictionary else {
                    
                    let message = "Registering for Push Notifications failed. Settings parameter is Invalid."
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    // call error callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    return
                }
                
                // Empty settings object passed: {}
                if (settings.count == 0) {
                    types.insert(.Alert)
                    types.insert(.Badge)
                    types.insert(.Sound)
                }
                // Check which settings the user enabled
                else {
                
                    guard let ios = settings["ios"] as? NSDictionary else {
                        let errorMessage = "Registering for Push Notifications failed. Settings ios parameter is Invalid."
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errorMessage)
                        // call error callback
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                        return
                    }
                    
                    guard let alert = ios["alert"] as? Bool else {
                        let errorMessage = "Registering for Push Notifications failed. Settings alert parameter is Invalid."
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errorMessage)
                        // call error callback
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                        return
                    }
                    
                    guard let badge = ios["badge"] as? Bool else {
                        let errorMessage = "Registering for Push Notifications failed. Settings badge parameter is Invalid."
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errorMessage)
                        // call error callback
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                        return
                    }
                    
                    guard let sound = ios["sound"] as? Bool else {
                        let errorMessage = "Registering for Push Notifications failed. Settings sound parameter is Invalid."
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: errorMessage)
                        // call error callback
                        self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                        return
                    }
                    
                    if (alert) {
                        types.insert(.Alert)
                    }
                    if (badge) {
                        types.insert(.Badge)
                    }
                    if (sound) {
                        types.insert(.Sound)
                    }
                }
            }
            
            let notificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        })
    }
    
    /*
    * Unregisters the device with IMFPush Notification Server
    */
    func unregisterDevice(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            self.push.unregisterDevice({ (response:IMFResponse!, error:NSError!) -> Void in
                if (error != nil) {
                    let message = error.description
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    // call error callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
                else {
                    let message = response.description
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                    // call success callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            })
        })
    }
    
    func registerNotificationsCallback(command: CDVInvokedUrlCommand) {
        
        CDVMFPPush.sharedInstance.notifCallbackId = command.callbackId
        CDVMFPPush.sharedInstance.notifCommandDelegate = self.commandDelegate
        
    }
    
    /*
    * Gets the Tags that are subscribed by the device
    */
    func retrieveSubscriptions(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            self.push.retrieveSubscriptionsWithCompletionHandler { (response:IMFResponse!, error:NSError!) -> Void in
                if (error != nil) {
                    let message = error.description
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    // call error callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
                else {
                    let tags = response.subscriptions() as [NSObject : AnyObject]
                    let tagsArray = tags["subscriptions"] as! [AnyObject]
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsArray: tagsArray)
                    // call success callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            }
            
        })
    }
    
    /*
    * Gets all the available Tags for the backend mobile application
    */
    func retrieveAvailableTags(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            self.push.retrieveAvailableTagsWithCompletionHandler { (response:IMFResponse!, error:NSError!) -> Void in
                if (error != nil) {
                    let message = error.description
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    // call error callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
                else {
                    let tags = response.availableTags() as! [String]
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsArray: tags)
                    // call success callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            }
            
        })
    }
    
    /*
    * Subscribes to a particular backend mobile application Tag(s)
    */
    func subscribe(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            guard let tag = command.arguments[0] as? String else {
                let message = "Tag Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                // call error callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            let tagsArray = [tag]
            self.push.subscribeToTags(tagsArray, completionHandler: { (response:IMFResponse!, error:NSError!) -> Void in
                
                if (error != nil) {
                    let message = error.description
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    // call error callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
                else {
                    let message = response.responseText
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                    // call success callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            })
            
        })
    }
    
    /*
    * Unsubscribes from particular backend mobile application Tag(s)
    */
    func unsubscribe(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            guard let tag = command.arguments[0] as? String else {
                let message = "Tag Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                // call error callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            let tagsArray = [tag]
            self.push.unsubscribeFromTags(tagsArray, completionHandler: { (response:IMFResponse!, error:NSError!) -> Void in
                
                if (error != nil) {
                    let message = error.description
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    // call error callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
                else {
                    let message = response.responseText
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                    // call success callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            })
            
        })
    }
    
    // Internal functions
    
    /*
    * Function called after registered for remote notifications. Registers device token from APNs with IMFPush Server.
    * Called by sharedInstance
    * Uses command delegate stored in sharedInstance for callback
    */
    func didRegisterForRemoteNotifications(deviceToken: NSData) {
        
        if (CDVMFPPush.sharedInstance.registerCallbackId == nil) {
            return
        }
        
        CDVMFPPush.sharedInstance.registerCommandDelegate!.runInBackground({

            self.push.registerDeviceToken(deviceToken, completionHandler: { (response:IMFResponse!, error:NSError!) -> Void in
                
                if (error != nil) {
                    let message = error.description
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    // call error callback
                    CDVMFPPush.sharedInstance.registerCommandDelegate!.sendPluginResult(pluginResult, callbackId:self.registerCallbackId)
                }
                else {
                    let message = response.responseText
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                    // call success callback
                    CDVMFPPush.sharedInstance.registerCommandDelegate!.sendPluginResult(pluginResult, callbackId:self.registerCallbackId)
                }
            })
            
        })
    }
    
    func didFailToRegisterForRemoteNotifications(error: NSError) {
        
        if (CDVMFPPush.sharedInstance.registerCallbackId == nil) {
            return
        }
        
        CDVMFPPush.sharedInstance.registerCommandDelegate!.runInBackground({
            
            let message = error.description
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            CDVMFPPush.sharedInstance.registerCommandDelegate!.sendPluginResult(pluginResult, callbackId:self.registerCallbackId)
        })
    }
    
    /*
    * Function called after registered for remote notifications. Registers device token from APNs with IMFPush Server.
    * Called by sharedInstance
    * Uses command delegate stored in sharedInstance for callback
    */
    func didReceiveRemoteNotification(notification: NSDictionary?) {
        
        var notif: [String : AnyObject] = [:]
        
        notif["message"] = notification?.valueForKey("aps")?.valueForKey("alert")?.valueForKey("body");
        notif["payload"] = notification?.valueForKey("payload")
        notif["sound"] = notification?.valueForKey("aps")?.valueForKey("sound")
        notif["badge"] = notification?.valueForKey("aps")?.valueForKey("badge")
        notif["action-loc-key"] = notification?.valueForKey("aps")?.valueForKey("alert")?.valueForKey("action-loc-key")
        
        if (CDVMFPPush.sharedInstance.notifCallbackId == nil) {
            return
        }
        
        CDVMFPPush.sharedInstance.notifCommandDelegate!.runInBackground({

            if (notification == nil) {
                let message = "Error in receiving notification"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                pluginResult.setKeepCallbackAsBool(true)
                // call error callback
                CDVMFPPush.sharedInstance.notifCommandDelegate!.sendPluginResult(pluginResult, callbackId:self.notifCallbackId)
            }
            else {
                let message = notif
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: message as! [String : AnyObject])
                pluginResult.setKeepCallbackAsBool(true)
                // call success callback
                CDVMFPPush.sharedInstance.notifCommandDelegate!.sendPluginResult(pluginResult, callbackId:self.notifCallbackId)
            }
            
        })
    }
}