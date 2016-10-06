//
//  BaseUIViewController.h
//  xman
//
//  Created by Liu Ming on 28/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "KeyboardPanel.h"

@interface BaseUIViewController : UIViewController

@property (nonatomic,weak)UIScrollView *scrollView;
@property (nonatomic,weak)UITextField *activeField;
@property (nonatomic,weak)KeyboardPanel *keyboardPanel;
@property (nonatomic,strong)AppDelegate *appDelegate;

-(void) registerForKeyboardNotifications;
-(void) unregisterAllObservers;

-(void)goBackViewController;

@end
