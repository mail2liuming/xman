//
//  BaseUIViewController.m
//  xman
//
//  Created by Liu Ming on 28/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "BaseUIViewController.h"

@interface BaseUIViewController ()

@end

@implementation BaseUIViewController

static const int KEYBOARD_PANEL_HEIGHT = 30;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activeField = nil;
    self.keyboardPanel = [self getKeyboardPanel];
    if(self.keyboardPanel != nil){
        [self.keyboardPanel setHidden:true];
    }
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) unregisterAllObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyboardWasShown: (NSNotification*) aNotification{
    if(self.activeField == nil)
        return;
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+KEYBOARD_PANEL_HEIGHT, 0.0);
    
    UIScrollView *scrollView = self.scrollView;
    
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    if(self.keyboardPanel){
        CGRect panelFrame = CGRectMake(0, self.view.frame.size.height - kbSize.height-KEYBOARD_PANEL_HEIGHT, self.view.frame.size.width, KEYBOARD_PANEL_HEIGHT);
        self.keyboardPanel.frame = panelFrame;
        [self.keyboardPanel setHidden:false];
        NSLog(@"the panel frame is %f %f",panelFrame.size.height,panelFrame.size.width);
    }
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height+KEYBOARD_PANEL_HEIGHT;
    
    CGRect activeRect =self.activeField.frame;
    activeRect.origin.y-=KEYBOARD_PANEL_HEIGHT;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible: activeRect animated:YES];
    }
}

-(void)keyboardWillBeHidden: (NSNotification*)aNotification{
    UIScrollView *scrollView = self.scrollView;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    [self.keyboardPanel setHidden:true];
//    [self.view layoutIfNeeded];
}

-(KeyboardPanel*) getKeyboardPanel{
    KeyboardPanel* panel = [[[NSBundle mainBundle] loadNibNamed:@"KeyboardPanel" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:panel];
    return panel;
}

-(void) goBackViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
