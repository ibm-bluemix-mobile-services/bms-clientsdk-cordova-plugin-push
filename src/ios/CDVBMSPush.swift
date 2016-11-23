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
import BMSCore
import BMSAnalytics
import BMSPush
import UIKit
#if swift(>=3.0)
import UserNotifications
import UserNotificationsUI
#endif

@objc(CDVBMSPush) class CDVBMSPush : CDVPlugin {

    let push = BMSPushClient.sharedInstance;
    static let sharedInstance = CDVBMSPush()
    static var pushUserId = String();
    var registerCallbackId: String?
    var registerCommandDelegate: CDVCommandDelegate?

    var notifCallbackId: String?
    var notifCommandDelegate: CDVCommandDelegate?

    /*
     * Initialize the SDK with appGUID and ClientSecret
     */
   
    #if swift(>=3.0)


    func initialize(_ command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
    
            guard let appGUID  = command.arguments[0] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: CustomErrorMessages.invalidGuid)
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }
            guard let clientSecret  = command.arguments[1] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Invalid Push service clientSecret.")
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }
            
            //use category to handle objective-c exception
            let push = BMSPushClient.sharedInstance;
            
            push.initializeWithAppGUID(appGUID: appGUID, clientSecret: clientSecret);
            
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "")
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            
        })
        
    }
    
    
    func registerNotificationsCallback(_ command: CDVInvokedUrlCommand) {
        CDVBMSPush.sharedInstance.notifCallbackId = command.callbackId
        CDVBMSPush.sharedInstance.notifCommandDelegate = self.commandDelegate
    }
    
    func registerDevice(_ command: CDVInvokedUrlCommand) {
        
        CDVBMSPush.sharedInstance.registerCallbackId = command.callbackId
        CDVBMSPush.sharedInstance.registerCommandDelegate = self.commandDelegate
        
        guard let settings = command.arguments[0] as? NSDictionary else {
            
            let message = "Registering for Push Notifications failed. Options parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            return
        }
        if (settings.count != 0) {
            CDVBMSPush.pushUserId = settings["userId"] as! String
        }
        
        self.commandDelegate!.run(inBackground: {
            
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
                { (granted, error) in
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                // Fallback on earlier versions
                let settings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
                UIApplication.shared.registerForRemoteNotifications()
            }
        })
    }
    
    
    func unregisterDevice(_ command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            
            BMSPushClient.sharedInstance.unregisterDevice(completionHandler: { (response, statusCode, error) -> Void in
                
                if error.isEmpty {
                    
                    let message = response?.description
                    // call success callback
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: message)
                    // call success callback
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    
                    UIApplication.shared.unregisterForRemoteNotifications()
                }
                else{
                    print( "Error during unregistering device \(error) ")
                    let message = error.description
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                    // call success callback
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                }
            })
            
        })
        
    }
    
    func retrieveSubscriptions(_ command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            
            BMSPushClient.sharedInstance.retrieveSubscriptionsWithCompletionHandler { (response, statusCode, error) -> Void in
                
                if error.isEmpty {
                    
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: response?.description)
                    // call success callback
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    
                }
                else {
                    
                    print( "Error during retrieveSubscriptions \(error) ")
                    let message = error.description
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                    // call success callback
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                }
            }
            
        })
    }
    
    func retrieveAvailableTags(_ command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            BMSPushClient.sharedInstance.retrieveAvailableTagsWithCompletionHandler(completionHandler: { (response, statusCode, error) -> Void in
                
                if error.isEmpty {
                    
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: response?.description)
                    // call success callback
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    
                }
                else{
                    
                    print( "Error during retrieveAvailableTags \(error) ")
                    let message = error.description
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                    // call success callback
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                }
            });
        })
    }
    
    func subscribe(_ command: CDVInvokedUrlCommand){
        self.commandDelegate!.run(inBackground: {
            
            guard let tag  = command.arguments[0] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Tag Parameter is Invalid.")
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }
            let tagsArray = [tag]
            BMSPushClient.sharedInstance.subscribeToTags(tagsArray: tagsArray as NSArray, completionHandler: { (response, statusCode, error) -> Void in
                
                if error.isEmpty {
                    
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: response!.description)
                    // call success callback
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    
                }else{
                    
                    print( "Error during subscribe Tags \(error) ")
                    let message = error.description
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                    // call success callback
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                }
            });
        })
    }
    
    func unsubscribe(_ command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            
            guard let tag  = command.arguments[0] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Tag Parameter is Invalid.")
                // call success callback
                self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                return
            }
            let tagsArray = [tag]
            BMSPushClient.sharedInstance.unsubscribeFromTags(tagsArray: tagsArray as NSArray, completionHandler: { (response, statusCode, error) -> Void in
                
                if error.isEmpty {
                    
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: response!.description)
                    // call success callback
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    
                }else{
                    
                    print( "Error during unsubscribe Tags \(error) ")
                    let message = error.description
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                    // call success callback
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                }
            });
        })
    }
    
    func didRegisterForRemoteNotifications(deviceToken: Data) {
        
        if (CDVBMSPush.sharedInstance.registerCallbackId == nil) {
            return
        }
        
        CDVBMSPush.sharedInstance.registerCommandDelegate!.run(inBackground: {
            
            if CDVBMSPush.pushUserId.isEmpty{
                BMSPushClient.sharedInstance.registerWithDeviceToken(deviceToken: deviceToken) { (response, statusCode, error) -> Void in
                    
                    if (!error.isEmpty) {
                        let message = error.description
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                        // call error callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.send(pluginResult, callbackId:self.registerCallbackId)
                    }
                    else {
                        
                        
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: response)
                        // call success callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.send(pluginResult, callbackId:self.registerCallbackId)
                    }
                }
            } else{
                BMSPushClient.sharedInstance.registerWithDeviceToken(deviceToken: deviceToken, WithUserId: CDVBMSPush.pushUserId) { (response, statusCode, error) -> Void in
                    
                    if (!error.isEmpty) {
                        let message = error.description
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                        // call error callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.send(pluginResult, callbackId:self.registerCallbackId)
                    }
                    else {
                        
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: response)
                        // call success callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.send(pluginResult, callbackId:self.registerCallbackId)
                    }
                }
            }
            

            
        })
    }
    
    func didFailToRegisterForRemoteNotifications(error: Error) {
        
        if (CDVBMSPush.sharedInstance.registerCallbackId == nil) {
            return
        }
        
        CDVBMSPush.sharedInstance.registerCommandDelegate!.run(inBackground: {
            
            let message = error.localizedDescription
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
            // call error callback
            CDVBMSPush.sharedInstance.registerCommandDelegate!.send(pluginResult, callbackId:self.registerCallbackId)
        })
    }
    
    func didReceiveRemoteNotification(notification: NSDictionary?) {
        
        var notif: [String : AnyObject] = [:]
        notif["message"] = ((notification?.value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as AnyObject?
        
        notif["payload"] = notification?.value(forKey: "payload") as AnyObject?
        notif["url"] = notification?.value(forKey: "url") as AnyObject?
        notif["sound"] = (notification?.value(forKey: "aps") as! NSDictionary).value(forKey: "sound") as AnyObject?
        notif["badge"] = (notification?.value(forKey: "aps") as! NSDictionary).value(forKey: "badge") as AnyObject?
        
        notif["action-loc-key"] = ((notification?.value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "action-loc-key") as AnyObject?
        
        if (CDVBMSPush.sharedInstance.notifCallbackId == nil) {
            return
        }
        
        CDVBMSPush.sharedInstance.notifCommandDelegate!.run(inBackground: {
            
            if (notification == nil) {
                let message = "Error in receiving notification"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                pluginResult?.setKeepCallbackAs(true)
                // call error callback
                CDVBMSPush.sharedInstance.notifCommandDelegate!.send(pluginResult, callbackId:self.notifCallbackId)
            }
            else {
                let message = notif
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: message )
                pluginResult?.setKeepCallbackAs(true)
                // call success callback
                CDVBMSPush.sharedInstance.notifCommandDelegate!.send(pluginResult, callbackId:self.notifCallbackId)
            }
            
        })
    }
    
    func hasPushEnabled() -> Bool {
        let settings = UIApplication.shared.currentUserNotificationSettings
        return (settings?.types.contains(.alert))!
    }
    
    func didReceiveRemoteNotificationOnLaunch(launchOptions: NSDictionary?) {
        
        let remoteNotification = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] as! NSDictionary
        if remoteNotification.allKeys.count > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                CDVBMSPush.sharedInstance.didReceiveRemoteNotification(notification: remoteNotification)
            }
        }
    }

#else

    func initialize(command: CDVInvokedUrlCommand) {
        self.commandDelegate.runInBackground({
            
            guard let appGUID  = command.arguments[0] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: CustomErrorMessages.invalidGuid)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            guard let clientSecret  = command.arguments[1] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid Push service clientSecret.")
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            
            //use category to handle objective-c exception
            BMSPushClient.sharedInstance.initializeWithAppGUID(appGUID:appGUID, clientSecret:clientSecret)
            
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: "SuccesFully initialized")
            // call success callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
        })
    }
    func registerNotificationsCallback(command: CDVInvokedUrlCommand) {
        CDVBMSPush.sharedInstance.notifCallbackId = command.callbackId
        CDVBMSPush.sharedInstance.notifCommandDelegate = self.commandDelegate
    }
    
    func registerDevice(command: CDVInvokedUrlCommand){
        
        CDVBMSPush.sharedInstance.registerCallbackId = command.callbackId
        CDVBMSPush.sharedInstance.registerCommandDelegate = self.commandDelegate
        
        guard let settings = command.arguments[0] as? NSDictionary else {
            
            let message = "Registering for Push Notifications failed. Options parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        if (settings.count != 0) {
            CDVBMSPush.pushUserId = settings["userId"] as! String
        }
        
        self.commandDelegate.runInBackground({
            
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
            
        })
    }
    
    func unregisterDevice(command: CDVInvokedUrlCommand){
        self.commandDelegate.runInBackground({
    
            BMSPushClient.sharedInstance.unregisterDevice({ (response, statusCode, error) -> Void in
    
                if error.isEmpty {
    
                    let message = response
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                    // call success callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    UIApplication.sharedApplication().unregisterForRemoteNotifications()
                }
                else{
                    print( "Error during unregistering device \(error) ")
                    let message = error
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    // call error callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            })
            
        })
    }
    func retrieveSubscriptions(command: CDVInvokedUrlCommand){
        self.commandDelegate.runInBackground({
            
            BMSPushClient.sharedInstance.retrieveSubscriptionsWithCompletionHandler { (response, statusCode, error) -> Void in
                
                if error.isEmpty {
                    
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsArray: response! as [AnyObject])
                    // call success callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
                else{
                    
                    print( "Error during unregistering device \(error) ")
                    let message = error
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    // call error callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            }
        })
    }
    
    func retrieveAvailableTags(command: CDVInvokedUrlCommand) {
        self.commandDelegate.runInBackground({
            
            BMSPushClient.sharedInstance.retrieveSubscriptionsWithCompletionHandler { (response, statusCode, error) -> Void in
                
                if error.isEmpty {
                    
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsArray: response! as [AnyObject])
                    // call success callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
                else{
                    
                    print( "Error during retrieveAvailableTags device \(error) ")
                    let message = error
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    // call error callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            }
            
        })
    }
    
    func subscribe(command: CDVInvokedUrlCommand) {
        self.commandDelegate.runInBackground({
            
            guard let tag  = command.arguments[0] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Tag Parameter is Invalid.")
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            let tagsArray = [tag]
            BMSPushClient.sharedInstance.subscribeToTags(tagsArray, completionHandler: { (response, statusCode, error) -> Void in
                if error.isEmpty{
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsArray: [response!.description])
                    // call success callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
                else{
                    
                    print( "Error during subscribe Tags  \(error) ")
                    let message = error
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    // call error callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            });
            
        })
    }
    
    func unsubscribe(command: CDVInvokedUrlCommand){
        self.commandDelegate.runInBackground({
            
            guard let tag  = command.arguments[0] as? String else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Tag Parameter is Invalid.")
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                return
            }
            let tagsArray = [tag]
            BMSPushClient.sharedInstance.unsubscribeFromTags(tagsArray, completionHandler: { (response, statusCode, error) -> Void in
                if error.isEmpty{
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsArray:[response!.description])
                    // call success callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
                else{
                    
                    print( "Error during unsubscribe Tags  \(error) ")
                    let message = error
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                    // call error callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                }
            });
            
        })
    }
    
    func didRegisterForRemoteNotifications(deviceToken: NSData) {
        
        if (CDVBMSPush.sharedInstance.registerCallbackId == nil) {
            return
        }
        
        CDVBMSPush.sharedInstance.registerCommandDelegate!.runInBackground({
    
            
            if CDVBMSPush.pushUserId.isEmpty{
                BMSPushClient.sharedInstance.registerWithDeviceToken(deviceToken) { (response, statusCode, error) -> Void in
                    
                    if error.isEmpty {
                        
                        let message = response
                        
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                        // call success callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.sendPluginResult(pluginResult, callbackId:self.registerCallbackId)
                    }
                    else{
                        
                        let message = error
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                        // call error callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.sendPluginResult(pluginResult, callbackId:self.registerCallbackId)
                    }
                    
                }
            } else{
               BMSPushClient.sharedInstance.registerWithDeviceToken(deviceToken, WithUserId: CDVBMSPush.pushUserId) { (response, statusCode, error) -> Void in
                    
                    if error.isEmpty {
                        
                        let message = response
                        
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                        // call success callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.sendPluginResult(pluginResult, callbackId:self.registerCallbackId)
                    }
                    else{
                        
                        let message = error
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                        // call error callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.sendPluginResult(pluginResult, callbackId:self.registerCallbackId)
                    }
                }
            }
        })
    }
    
    func didFailToRegisterForRemoteNotifications(error: NSError) {
        
        if (CDVBMSPush.sharedInstance.registerCallbackId == nil) {
            return
        }
        
        CDVBMSPush.sharedInstance.registerCommandDelegate!.runInBackground({
            
            let message = error.description
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            CDVBMSPush.sharedInstance.registerCommandDelegate!.sendPluginResult(pluginResult, callbackId:self.registerCallbackId)
        })
    }
    
    /*
     * Function called after registered for remote notifications. Registers device token from APNs with BMSPush Server.
     * Called by sharedInstance
     * Uses command delegate stored in sharedInstance for callback
     */
    func didReceiveRemoteNotification(notification: NSDictionary?) {
        
        var notif: [String : AnyObject] = [:]
        
        notif["message"] = notification?.valueForKey("aps")?.valueForKey("alert")?.valueForKey("body");
        notif["payload"] = notification?.valueForKey("payload")
        notif["url"] = notification?.valueForKey("url")
        notif["sound"] = notification?.valueForKey("aps")?.valueForKey("sound")
        notif["badge"] = notification?.valueForKey("aps")?.valueForKey("badge")
        notif["action-loc-key"] = notification?.valueForKey("aps")?.valueForKey("alert")?.valueForKey("action-loc-key")
        
        if (CDVBMSPush.sharedInstance.notifCallbackId == nil) {
            return
        }
        
        CDVBMSPush.sharedInstance.notifCommandDelegate!.runInBackground({
            
            if (notification == nil) {
                let message = "Error in receiving notification"
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                pluginResult.setKeepCallbackAsBool(true)
                // call error callback
                CDVBMSPush.sharedInstance.notifCommandDelegate!.sendPluginResult(pluginResult, callbackId:self.notifCallbackId)
            }
            else {
                let message = notif
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsDictionary: message )
                pluginResult.setKeepCallbackAsBool(true)
                // call success callback
                CDVBMSPush.sharedInstance.notifCommandDelegate!.sendPluginResult(pluginResult, callbackId:self.notifCallbackId)
            }
            
        })
    }
    
    /*
     * Function to verify if user permit or blocked notifications to app.
     * Called by registerDevice
     */
    func hasPushEnabled() -> Bool {
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        return (settings?.types.contains(.Alert))!
    }
    
    /*
     * Function to receive notification by launchOptions on start of app.
     */
    func didReceiveRemoteNotificationOnLaunch(launchOptions: NSDictionary?) {
        if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                // Executed with a delay
                CDVBMSPush.sharedInstance.didReceiveRemoteNotification(remoteNotification)
            }
        }
    }

    #endif
}
