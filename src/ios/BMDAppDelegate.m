//
//  BMDAppDelegate.m
//  HelloCordova
//
//  Created by Anantha Krishnan K G on 11/02/19.
//

#import "BMDAppDelegate.h"
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@implementation BMDAppDelegate

static IMP didRegisterOriginalMethod = NULL;
static IMP didFailOriginalMethod = NULL;
static IMP didReceiveOriginalMethod = NULL;
static IMP didReceiveOriginalMethodWithHandler = NULL;
static IMP handleActionWithIdentifierOriginalMethod = NULL;
    
NSString *const CDVBMDPushDidRegisterForRemoteNotificationsWithDeviceToken = @"CDVBMDPushDidRegisterForRemoteNotificationsWithDeviceToken";
NSString *const CDVBMDushDidFailToRegisterForRemoteNotificationsWithError = @"CDVBMDushDidFailToRegisterForRemoteNotificationsWithError";
NSString *const CDVBMDPushDidReceiveRemoteNotifications = @"CDVBMDPushDidReceiveRemoteNotifications";
NSString *const CDVBMDPushHandleActionWithIdentifier = @"CDVBMDPushHandleActionWithIdentifier";
NSString *const CDVBMDPushSendPushNotifications = @"CDVBMDPushSendPushNotifications";
NSString *const CDVBMDUIApplicationDidFinishLaunchingNotifications = @"UIApplicationDidFinishLaunchingNotification";
    
- (BMDAppDelegate *)init {
    return [super init];
}
    
+(void)load {
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self swizzleMethods];
        [self didFinishLaunchingWithOptions:note];
    }];
}
    
+(void) swizzleMethods {
    
    id delegate = [UIApplication sharedApplication].delegate;
    if (!delegate) {
        NSLog(@"App delegate not set, unable to perform automatic setup.");
        return;
    }
    Class swizzleClass = [delegate class];
    
    [self swizzle:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:) implementation:@selector(didRegisterForRemoteNotificationsWithDeviceToken:token:) handler:didRegisterOriginalMethod swizzleClass:swizzleClass];
    
    [self swizzle:@selector(application:didFailToRegisterForRemoteNotificationsWithError:) implementation:@selector(didFailToRegisterForRemoteNotifications:error:) handler:didFailOriginalMethod swizzleClass:swizzleClass];
    
    [self swizzle:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:) implementation:@selector(didReceiveRemoteNotification:userinfo:fetchCompletionHandler:) handler:didReceiveOriginalMethodWithHandler swizzleClass:swizzleClass];
    
    [self swizzle:@selector(application:didReceiveRemoteNotification:) implementation:@selector(didReceiveRemoteNotification:userinfo:) handler:didReceiveOriginalMethod swizzleClass:swizzleClass];
    
    [self swizzle:@selector(application:handleActionWithIdentifier:forRemoteNotification:completionHandler:) implementation:@selector(handleActionWithIdentifier:identifier:forRemoteNotification:completionHandler:) handler:handleActionWithIdentifierOriginalMethod swizzleClass:swizzleClass];
}
    
- (void) didRegisterForRemoteNotificationsWithDeviceToken:(UIApplication *) application token:(NSData *)deviceToken {
    
    if (didRegisterOriginalMethod) {
        void (*originalImp)(id, SEL, UIApplication *, NSData *) = didRegisterOriginalMethod;
        originalImp(self, @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:), application, deviceToken);
    }
    
    NSLog(@"APNS Token : %@", deviceToken);
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVBMDPushDidRegisterForRemoteNotificationsWithDeviceToken object:deviceToken];
}
    
- (void) didFailToRegisterForRemoteNotifications:(UIApplication*)application error: (NSError*) error {
    
    NSLog(@"didFailToRegisterForRemoteNotifications");
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVBMDushDidFailToRegisterForRemoteNotificationsWithError object:error];
}
    
- (void)didReceiveRemoteNotification:(UIApplication *)application userinfo:(NSDictionary *)userInfo {
    
    if (didReceiveOriginalMethod) {
        void (*originalImp)(id, SEL, UIApplication *, NSDictionary *) = didReceiveOriginalMethod;
        originalImp(self, @selector(application:didReceiveRemoteNotification:), application, userInfo);
    }
    NSLog(@"didReceiveRemoteNotification");
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVBMDPushDidReceiveRemoteNotifications object:nil userInfo:userInfo];
}
    
- (void) didReceiveRemoteNotification:(UIApplication *)application
                             userinfo:(NSDictionary *)userInfo
               fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    if (didReceiveOriginalMethodWithHandler) {
        void (*originalImp)(id, SEL, UIApplication *, NSDictionary *) = didReceiveOriginalMethodWithHandler;
        originalImp(self, @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:), application, userInfo);
    }
    NSLog(@"didReceiveRemoteNotification fetchCompletionHandler");
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVBMDPushDidReceiveRemoteNotifications object:nil userInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
    
- (void)handleActionWithIdentifier:(UIApplication *)application identifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    
    NSLog(@"handleActionWithIdentifier");
    NSMutableDictionary *userInf = [[NSMutableDictionary alloc] init];
    [userInf addEntriesFromDictionary:userInfo];
    [userInf setValue:identifier forKey:@"identifierName"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVBMDPushHandleActionWithIdentifier object:nil userInfo:userInf];
    completionHandler();
}
    
    
+(void) didFinishLaunchingWithOptions:(NSNotification *)notification {
    
    if (notification)
    {
        NSDictionary *launchOptions = [notification userInfo];
        if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
            NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
            if (userInfo) {
                double delayInSeconds = 7.0;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:CDVBMDPushDidReceiveRemoteNotifications object:nil userInfo:userInfo];
                });
            }
        }
        
    }
}
+(void) swizzle:(SEL)selector implementation:(SEL)implementation handler:(IMP) handler swizzleClass:(Class) swizzleClass {
    
    Method didRegisterMethod = class_getInstanceMethod([self class], implementation);
    IMP didRegisterMethodImp = method_getImplementation(didRegisterMethod);
    const char* didRegisterTypes = method_getTypeEncoding(didRegisterMethod);
    
    Method didRegisterOriginal = class_getInstanceMethod(swizzleClass, selector);
    if (didRegisterOriginal) {
        handler = method_getImplementation(didRegisterOriginal);
        method_exchangeImplementations(didRegisterOriginal, didRegisterMethod);
    } else {
        class_addMethod(swizzleClass, selector, didRegisterMethodImp, didRegisterTypes);
    }
}
@end
