//
//  AppDelegate.h
//  xman
//
//  Created by Liu Ming on 26/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICKeyChainStore.h"
#import "User.h"
#import<MapKit/MapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic) CLLocation* curLocation;

-(bool)checkUserLogin;
-(UICKeyChainStore*)getAppChainStore;

-(void) saveLoginUser :(User* )aUser;

@end

