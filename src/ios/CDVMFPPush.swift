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

@objc(CDVMFPPush) class CDVMFPPush : CDVPlugin {
    
    let push = IMFPushClient.sharedInstance()
    
    func getSubscriptionStatus(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.runInBackground({
            self.push.retrieveSubscriptionsWithCompletionHandler { (response:IMFResponse!, error:NSError!) -> Void in
                let tags = response.availableTags()
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsArray: tags)
                // call success callback
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            }
        })
    }
    
    func retrieveAvailableTags(command: CDVInvokedUrlCommand) {
        self.commandDelegate!.runInBackground({
            self.push.retrieveAvailableTagsWithCompletionHandler { (response:IMFResponse!, error:NSError!) -> Void in
                let tags = response.availableTags()
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAsArray: tags)
                self.commandDelegate!.sendPluginResult(pluginResult, callbackId:command.callbackId)
            }
        })
    }
}