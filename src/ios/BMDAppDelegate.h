//
//  BMDAppDelegate.h
//  HelloCordova
//
//  Created by Anantha Krishnan K G on 11/02/19.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMDAppDelegate : NSObject

extern NSString *const CDVBMDPushDidRegisterForRemoteNotificationsWithDeviceToken;
extern NSString *const CDVBMDushDidFailToRegisterForRemoteNotificationsWithError;
extern NSString *const CDVBMDPushHandleActionWithIdentifier;
extern NSString *const CDVBMDPushDidReceiveRemoteNotifications;
extern NSString *const CDVBMDPushSendPushNotifications;
extern NSString *const CDVBMDUIApplicationDidFinishLaunchingNotifications;

@end

NS_ASSUME_NONNULL_END
