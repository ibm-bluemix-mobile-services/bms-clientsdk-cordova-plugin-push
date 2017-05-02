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
     var pushUserId = String();
     var bluemixDeviceId = String();
     var shouldRegister:Bool = false
     var registerParams = CDVInvokedUrlCommand()

    #if swift(>=3.0)
     var bmsPushToken = Data()
    #else
     var bmsPushToken = NSData()
    #endif
    var registerCallbackId: String?
    var registerCommandDelegate: CDVCommandDelegate?

    var notifCallbackId: String?
    var notifCommandDelegate: CDVCommandDelegate?

    /*
     * Initialize the SDK with appGUID , ClientSecret and BMSPushClientOptions
     */

    #if swift(>=3.0)

    func initialize(_ command: CDVInvokedUrlCommand) {
        self.commandDelegate!.run(inBackground: {
            if command.arguments.count > 2 && (command.arguments[2] as! NSDictionary).count > 0{

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

                guard let bmsNotifOptions  = command.arguments[2] as? NSDictionary else {
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Invalid BMSPush Options.")
                    // call success callback
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    return
                }

                if bmsNotifOptions.count > 0{

                    var categoryArray = [BMSPushNotificationActionCategory]()
                    let notifOptions = BMSPushClientOptions();

                    if let value = bmsNotifOptions["categories"] {
                        guard let result = bmsNotifOptions.value(forKey:"categories") as? [String:AnyObject] else {
                            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Invalid BMSPush Options")
                            // call success callback
                            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                            return
                        }


                        if(result.count > 0){
                            for name in result{

                                let identifiers:NSArray = (name.value) as! NSArray
                                var actionArray = [BMSPushNotificationAction]()
                                for identifier in identifiers {

                                    let resultJson = identifier as? NSDictionary
                                    let identifierName = resultJson?.value(forKey: "IdentifierName");
                                    let actionName = resultJson?.value(forKey: "actionName");

                                    actionArray.append(BMSPushNotificationAction(identifierName: identifierName as! String, buttonTitle:actionName as! String, isAuthenticationRequired: false, defineActivationMode: UIUserNotificationActivationMode.background))
                                }
                                let category = BMSPushNotificationActionCategory(identifierName: name.key , buttonActions: actionArray)
                                categoryArray.append(category)
                            }
                            notifOptions.setInteractiveNotificationCategories(categoryName: categoryArray)
                        }
                    }else{
                        for name in bmsNotifOptions {

                            let identifiers:NSArray = (name.value) as! NSArray
                            var actionArray = [BMSPushNotificationAction]()
                            for identifier in identifiers {
                                actionArray.append(BMSPushNotificationAction(identifierName: (identifier as? NSDictionary)?.allKeys.first as! String, buttonTitle: (identifier as? NSDictionary)?.allValues.first as! String, isAuthenticationRequired: false, defineActivationMode: UIUserNotificationActivationMode.background))
                            }

                            let category = BMSPushNotificationActionCategory(identifierName: name.key as! String, buttonActions: actionArray)

                            let notifOptions = BMSPushClientOptions(categoryName: [category])

                            let push = BMSPushClient.sharedInstance;

                            push.initializeWithAppGUID(appGUID: appGUID, clientSecret: clientSecret, options: notifOptions);

                            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "")
                            // call success callback
                            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                        }
                    }
                    if(bmsNotifOptions.count == 2){
                        guard let deviceId = bmsNotifOptions.value(forKey:"deviceId") as? String else {
                            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Invalid BMSPush Options")
                            // call success callback
                            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                            return
                        }
                        notifOptions.setDeviceId(deviceId: deviceId)
                    }

                    let push = BMSPushClient.sharedInstance;

                        push.initializeWithAppGUID(appGUID: appGUID, clientSecret: clientSecret, options: notifOptions);

                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "")
                        // call success callback
                        self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)


                }else{
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Invalid BMSPush Options")
                    // call success callback
                    self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
                    return
                }


                //use category to handle objective-c exception


            }else{


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
            }

        })

    }


    func registerNotificationsCallback(_ command: CDVInvokedUrlCommand) {
        CDVBMSPush.sharedInstance.notifCallbackId = command.callbackId
        CDVBMSPush.sharedInstance.notifCommandDelegate = self.commandDelegate
    }

    func registerDevice(_ command: CDVInvokedUrlCommand) {

        CDVBMSPush.sharedInstance.registerCallbackId = command.callbackId
        CDVBMSPush.sharedInstance.registerCommandDelegate = self.commandDelegate
       CDVBMSPush.sharedInstance.registerParams = command
        if ( CDVBMSPush.sharedInstance.shouldRegister == true &&  CDVBMSPush.sharedInstance.bmsPushToken.isEmpty == false){

            registerDeviceAfterTokenRecieve(command)
        }
    }
    func registerDeviceAfterTokenRecieve(_ command: CDVInvokedUrlCommand) {


        guard let settings = command.arguments[0] as? NSDictionary else {

            let message = "Registering for Push Notifications failed. Options parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
            // call success callback
            self.commandDelegate!.send(pluginResult, callbackId:command.callbackId)
            return
        }
        if (settings.count != 0) {
            CDVBMSPush.sharedInstance.pushUserId = settings["userId"] as! String
        }

        CDVBMSPush.sharedInstance.registerCommandDelegate!.run(inBackground: {

            if CDVBMSPush.sharedInstance.pushUserId.isEmpty{
                BMSPushClient.sharedInstance.registerWithDeviceToken(deviceToken: CDVBMSPush.sharedInstance.bmsPushToken) { (response, statusCode, error) -> Void in

                    if (!error.isEmpty) {
                        let message = error.description
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                        // call error callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.send(pluginResult, callbackId:CDVBMSPush.sharedInstance.registerCallbackId)
                    }
                    else {


                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: response)
                        // call success callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.send(pluginResult, callbackId:CDVBMSPush.sharedInstance.registerCallbackId)
                    }
                }
            } else{
                BMSPushClient.sharedInstance.registerWithDeviceToken(deviceToken: CDVBMSPush.sharedInstance.bmsPushToken, WithUserId: CDVBMSPush.sharedInstance.pushUserId) { (response, statusCode, error) -> Void in

                    if (!error.isEmpty) {
                        let message = error.description
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
                        // call error callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.send(pluginResult, callbackId:CDVBMSPush.sharedInstance.registerCallbackId)
                    }
                    else {

                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: response)
                        // call success callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.send(pluginResult, callbackId:CDVBMSPush.sharedInstance.registerCallbackId)
                    }
                }
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

        CDVBMSPush.sharedInstance.shouldRegister = true;
        CDVBMSPush.sharedInstance.bmsPushToken = deviceToken;
        if (CDVBMSPush.sharedInstance.registerCallbackId == nil) {
            return
        }
        registerDeviceAfterTokenRecieve(CDVBMSPush.sharedInstance.registerParams)
    }

    func didFailToRegisterForRemoteNotifications(error: Error) {

        if (CDVBMSPush.sharedInstance.registerCallbackId == nil) {
            return
        }

        CDVBMSPush.sharedInstance.registerCommandDelegate!.run(inBackground: {

            let message = error.localizedDescription
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
            // call error callback
            CDVBMSPush.sharedInstance.registerCommandDelegate!.send(pluginResult, callbackId:CDVBMSPush.sharedInstance.registerCallbackId)
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
            if command.arguments.count > 2 && (command.arguments[2] as! NSDictionary).count > 0{

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

                guard let bmsNotifOptions  = command.arguments[2] as? NSDictionary else {

                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid BMSPush Options.")
                    // call success callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    return
                }

                if bmsNotifOptions.count > 0{
                    var categoryArray = [BMSPushNotificationActionCategory]()
                    let notifOptions = BMSPushClientOptions();

                    if let result = bmsNotifOptions["categories"] as? NSDictionary{

                        if(result.count > 0){

                            for name in result {

                                let identifiers:NSArray = (name.value) as! NSArray
                                var actionArray = [BMSPushNotificationAction]()
                                for identifier in identifiers {

                                    let resultJson = identifier as? NSDictionary
                                    let identifierName = resultJson?.valueForKey("IdentifierName");
                                    let actionName = resultJson?.valueForKey("actionName");

                                    actionArray.append(BMSPushNotificationAction(identifierName: identifierName as! String, buttonTitle: actionName as! String, isAuthenticationRequired: false, defineActivationMode: UIUserNotificationActivationMode.Background))
                                }

                                let category = BMSPushNotificationActionCategory(identifierName: name.key as! String, buttonActions: actionArray)
                                categoryArray.append(category)
                            }
                            notifOptions.setInteractiveNotificationCategories(categoryName: categoryArray)

                        }
                    }else{
                            for name in bmsNotifOptions {

                                let identifiers:NSArray = (name.value) as! NSArray
                                var actionArray = [BMSPushNotificationAction]()
                                for identifier in identifiers {
                                    actionArray.append(BMSPushNotificationAction(identifierName: (identifier as? NSDictionary)?.allKeys.first as! String, buttonTitle: (identifier as? NSDictionary)?.allValues.first as! String, isAuthenticationRequired: false, defineActivationMode: UIUserNotificationActivationMode.Background))
                                }

                                let category = BMSPushNotificationActionCategory(identifierName: name.key as! String, buttonActions: actionArray)

                                let notifOptions = BMSPushClientOptions(categoryName: [category])

                                //use category to handle objective-c exception
                                BMSPushClient.sharedInstance.initializeWithAppGUID(appGUID, clientSecret:clientSecret,options:notifOptions)

                                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: "SuccesFully initialized")
                                // call success callback
                                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                            }

                    }

                    if bmsNotifOptions.count == 2 ,let deviceId = bmsNotifOptions["deviceId"] as? String{
                        notifOptions.setDeviceIdValue(deviceId)
                    }


                    //use category to handle objective-c exception
                    BMSPushClient.sharedInstance.initializeWithAppGUID(appGUID, clientSecret:clientSecret,options:notifOptions)

                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: "SuccesFully initialized")
                    // call success callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)


                }else{
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid BMSPush Options.")
                    // call success callback
                    self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    return
                }

            }else{
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
            }
        })
    }
    func registerNotificationsCallback(command: CDVInvokedUrlCommand) {
        CDVBMSPush.sharedInstance.notifCallbackId = command.callbackId
        CDVBMSPush.sharedInstance.notifCommandDelegate = self.commandDelegate
    }


    func registerDevice(command: CDVInvokedUrlCommand) {

        CDVBMSPush.sharedInstance.registerCallbackId = command.callbackId
        CDVBMSPush.sharedInstance.registerCommandDelegate = self.commandDelegate
        CDVBMSPush.sharedInstance.registerParams = command
        if ( CDVBMSPush.sharedInstance.shouldRegister == true &&  CDVBMSPush.sharedInstance.bmsPushToken.length > 0){

              registerDeviceAfterTokenRecieve(command)
        }
    }

    func registerDeviceAfterTokenRecieve(command: CDVInvokedUrlCommand){


        guard let settings = command.arguments[0] as? NSDictionary else {

            let message = "Registering for Push Notifications failed. Options parameter is Invalid."
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            return
        }
        if (settings.count != 0) {
            CDVBMSPush.sharedInstance.pushUserId = settings["userId"] as! String
        }

        CDVBMSPush.sharedInstance.registerCommandDelegate!.runInBackground({

            if CDVBMSPush.sharedInstance.pushUserId.isEmpty{
                BMSPushClient.sharedInstance.registerWithDeviceToken(CDVBMSPush.sharedInstance.bmsPushToken) { (response, statusCode, error) -> Void in

                    if error.isEmpty {

                        let message = response

                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                        // call success callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.sendPluginResult(pluginResult, callbackId:CDVBMSPush.sharedInstance.registerCallbackId)
                    }
                    else{

                        let message = error
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                        // call error callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.sendPluginResult(pluginResult, callbackId:CDVBMSPush.sharedInstance.registerCallbackId)
                    }
                }
            } else{

                BMSPushClient.sharedInstance.registerWithDeviceToken(CDVBMSPush.sharedInstance.bmsPushToken, WithUserId: CDVBMSPush.sharedInstance.pushUserId) { (response, statusCode, error) -> Void in

                    if error.isEmpty {

                        let message = response

                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: message)
                        // call success callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
                    }
                    else{

                        let message = error
                        let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
                        // call error callback
                        CDVBMSPush.sharedInstance.registerCommandDelegate!.sendPluginResult(pluginResult, callbackId:CDVBMSPush.sharedInstance.registerCallbackId)
                    }
                }
            }
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

        CDVBMSPush.sharedInstance.shouldRegister = true;
        CDVBMSPush.sharedInstance.bmsPushToken = deviceToken;
        if (CDVBMSPush.sharedInstance.registerCallbackId == nil) {
            return
        }
        registerDeviceAfterTokenRecieve(CDVBMSPush.sharedInstance.registerParams)
    }

    func didFailToRegisterForRemoteNotifications(error: NSError) {

        if (CDVBMSPush.sharedInstance.registerCallbackId == nil) {
            return
        }

        CDVBMSPush.sharedInstance.registerCommandDelegate!.runInBackground({

            let message = error.description
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: message)
            // call error callback
            CDVBMSPush.sharedInstance.registerCommandDelegate!.sendPluginResult(pluginResult, callbackId:CDVBMSPush.sharedInstance.registerCallbackId)
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
