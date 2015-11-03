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
    
    let push = IMFPushClient.sharedInstance()
    
    /*
    * Registers the device on to the IMFPush Notification Server
    */
    func register(command: CDVInvokedUrlCommand) {
        
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
    func getSubscriptionStatus(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            self.push.retrieveSubscriptionsWithCompletionHandler { (response:IMFResponse!, error:NSError!) -> Void in
                let tags = response.subscriptions() as [NSObject : AnyObject]
                let tagsArray = tags["subscriptions"] as! [AnyObject]
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsArray: tagsArray)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            }
            
        })
    }
    
    /*
    * Gets all the available Tags for the backend mobile application
    */
    func retrieveAvailableTags(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            self.push.retrieveAvailableTagsWithCompletionHandler { (response:IMFResponse!, error:NSError!) -> Void in
                let tags = response.availableTags() as! [String]
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsArray: tags)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            }
            
        })
    }
    
    /*
    * Subscribes to a particular backend mobile application Tag(s)
    */
    func subscribeToTags(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            guard let tagsArray = command.arguments[0] as? [AnyObject] else {
                let message = "Tags Array Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                // call error callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            self.push.subscribeToTags(tagsArray, completionHandler: { (response:IMFResponse!, error:NSError!) -> Void in
                
                let message = "Subscribed to the following tags: " + tagsArray.description
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
            
        })
    }
    
    /*
    * Unsubscribes from particular backend mobile application Tag(s)
    */
    func unsubscribeFromTags(command: CDVInvokedUrlCommand) {
        
        self.commandDelegate!.runInBackground({
            
            guard let tagsArray = command.arguments[0] as? [AnyObject] else {
                let message = "Tags Array Parameter is Invalid."
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                // call error callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            self.push.unsubscribeFromTags(tagsArray, completionHandler: { (response:IMFResponse!, error:NSError!) -> Void in
                
                let message = "Unsubscribed from the following tags: " + tagsArray.description
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            })
            
        })
    }
}