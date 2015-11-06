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
    
    /*
    * Registers the device with APNs
    */
    func register(command: CDVInvokedUrlCommand) {
        
        CDVMFPPush.sharedInstance.registerCallbackId = command.callbackId
        CDVMFPPush.sharedInstance.registerCommandDelegate = self.commandDelegate

        self.commandDelegate!.runInBackground({
            
            guard let settings = command.arguments[0] as? NSDictionary else {
                let message = "Settings Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                // call error callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            
            // Check which notification types the user enabled.
            // TODO: CLEAN UP
            var types = UIUserNotificationType()
            let ios: NSDictionary = settings["ios"] as! NSDictionary
            if ((ios["alert"]) as! Bool) {
                types.insert(.Alert)
            }
            if ((ios["badge"]) as! Bool) {
                types.insert(.Badge)
            }
            if ((ios["sound"]) as! Bool) {
                types.insert(.Sound)
            }
            
            let notificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        })
    }
    
    /*
    * Unregisters the device with IMFPush Notification Server
    */
    func unregister(command: CDVInvokedUrlCommand) {
        
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
    
    /*
    * Gets the Tags that are subscribed by the device
    */
    func retrieveSubscriptionStatus(command: CDVInvokedUrlCommand) {
        
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
    
    // MAY NEED TO CHANGE
    //
    // JS passes one tag as String
    // Create an array and add the one tag,
    // then call subscribe/unsubscribe
    
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
    
    /*
    * Function called after registered for remote notifications. Registers device token from APNs with IMFPush Server.
    * Called by sharedInstance
    * Uses command delegate stored in sharedInstance for callback
    */
    func didRegisterForRemoteNotifications(deviceToken: NSData) {
        
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
}