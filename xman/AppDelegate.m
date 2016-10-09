//
//  AppDelegate.m
//  xman
//
//  Created by Liu Ming on 26/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"

@import Firebase;

@interface AppDelegate ()

@property(nonatomic,strong) User* curUser;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.curUser = [self loadExistingUser];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    [self startSignificantChangeUpdates];
    
    [FIRApp configure];
    
    return YES;
}

- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    
    CLLocationManager* locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    self.curLocation = [locations lastObject];
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

-(UICKeyChainStore *)getAppChainStore
{
    return [UICKeyChainStore keyChainStoreWithService:@"com.newworld.xman.xman"];
}

-(User *) loadExistingUser{
    
    UICKeyChainStore *store = [self getAppChainStore];
    
    User *user = [[User alloc] init];
    
    user.ID =  [store stringForKey:USER_ID];
    user.account_num = [store stringForKey:USER_NUMBER];
    user.password = [store stringForKey:USER_PASSWORD];
    
    if(user.account_num !=nil && user.ID != nil){
//        [[FIRAuth auth] signInWithEmail:user. password:<#(nonnull NSString *)#> completion:<#^(FIRUser * _Nullable user, NSError * _Nullable error)completion#>
//        
        return user;
    }
    return nil;
}

-(void) saveLoginUser :(User* )aUser{
    UICKeyChainStore *store = [self getAppChainStore];
    
    if(aUser.account_num !=nil && aUser.ID != nil){
        [store setString:aUser.ID forKey:USER_ID];
        [store setString:aUser.account_num forKey:USER_NUMBER];
        [store setString:aUser.password forKey:USER_PASSWORD];
        
        [store synchronize];
        self.curUser = aUser;
    }
}

-(bool)checkUserLogin{
    return (self.curUser!=nil);
//    return true;
}

-(NSString*)getUserID{
    if(self.curUser){
        return self.curUser.ID;
    }
    return nil;
}

@end
