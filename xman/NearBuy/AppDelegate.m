//
//  AppDelegate.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/16.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "AppDelegate.h"
#import "GAITracker.h"
#import "GAI.h"
#import "GAIFields.h"
#import "APService.h"
#import "AdCommentController.h"
#import "NewAdDetailController.h"
//#import <Google/Analytics.h>

#import "GAITracker.h"

static NSString *const kTrackingId = @"UA-49716901-1";//
static NSString *const kAllowTracking = @"allowTracking";

@interface AppDelegate ()

@property(nonatomic, strong) id<GAITracker> tracker;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];

    [[GAI sharedInstance] setDispatchInterval:20];
    [[GAI sharedInstance] setDryRun:NO];
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
//    [GAI sharedInstance].dispatchInterval = 1;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
//    [GAI sharedInstance].logger.logLevel  = kGAILogLevelVerbose;
//    self.tracker = [[GAI sharedInstance]trackerWithName:@"Swoop Projects" trackingId:kTrackingId];
//    self.tracker = [[GAI sharedInstance]trackerWithTrackingId:@"UA-49716901-5"];

    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    [self.tracker set:kGAIAppVersion value:version];
    [self.tracker set:kGAISampleRate value:@"50.0"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"appview", kGAIHitType, @"Home Screen", kGAIScreenName, nil];
    [self.tracker send:params];
    
//    self.tracker.allowIDFACollection = YES;

    // Configure tracker from GoogleService-Info.plist.
//    NSError *configureError;
//    [[GGLContext sharedInstance] configureWithError:&configureError];
//    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
//    
//    // Optional: configure GAI options.
//    GAI *gai = [GAI sharedInstance];
//    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
//    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release

    
    if (SYSTEM_VERSION_LATER_THAN_7_0) {
        [[UINavigationBar appearance]setBarTintColor:UI_NAVIBAR_COLOR];
    }
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [NSThread sleepForTimeInterval:2];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.naviController = [BaseNavigationController shareNaviController];
    [Base sharedInstance].currentNavi = self.naviController;
    self.window.rootViewController = self.naviController;
    
    [self.window makeKeyAndVisible];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerPushSuccess) name:kJPFNetworkDidRegisterNotification object:nil];
    
    if (SYSTEM_VERSION_LATER_THAN_8_0) {
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }else{
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    [APService setupWithOption:launchOptions];
    
    if (launchOptions) {
//        [self handlePushInfo:launchOptions];
    }
    
//    application.applicationIconBadgeNumber = 0;
    return YES;
}

- (void)registerPushSuccess{
    NSLog(@"推送注册成功");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [APService registerDeviceToken:deviceToken];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        [APService handleRemoteNotification:userInfo];
        NSLog(@"userinfo %@",userInfo);
        application.applicationIconBadgeNumber = 0;
        [self handlePushInfo:userInfo];

    }


}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"userinfo %@",userInfo);
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
//        [[PushManager sharedInstance]handlePushMessage:userInfo];
        [self handlePushInfo:userInfo];

    }
    application.applicationIconBadgeNumber = 0;


}

- (void)handlePushInfo:(NSDictionary *)userinfo{
    if ([userinfo isKindOfClass:[NSDictionary class]]) {
        
        NSString *adid = [userinfo valueForKey:@"ad_id"];
        NSString *title = [userinfo valueForKey:@"content"];
        
        EtyAd *ad = [[EtyAd alloc]init];
        ad.ad_id = adid;
        ad.name = title;
        
        
        [EtyAd getAdDetailById:adid withFinish:^(id result, BOOL success) {
            if (success) {
                if ([result isKindOfClass:[NSArray class]]) {
                    NSArray *array = result;
                    if (array.count>0) {
                        NewAdDetailController *vc = [[NewAdDetailController alloc]initWithAd:array[0] withFunction:NORMAL_FUNCTION];
                        PUSH_CONTROLLER(vc);

                    }
                }
            }
        }];
        
//        AdCommentController *vc = [[AdCommentController alloc]initWithEty:ad];
//        PUSH_CONTROLLER(vc);
        
    }
}

@end
