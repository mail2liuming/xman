//
//  ChangePasswordController.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/22.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "ChangePasswordController.h"

@interface ChangePasswordController ()
@property (strong, nonatomic) IBOutlet UIView *view2;

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIButton *finishBtn;
@property (strong, nonatomic) IBOutlet UITextField *currentPwdTf;
@property (strong, nonatomic) IBOutlet UITextField *newpwd1;
@property (strong, nonatomic) IBOutlet UITextField *newpwd2tf;
@end

@implementation ChangePasswordController

- (id)initController{
    self = [super initWithTitle:@"Change Password"];
    if (self) {
        
    }
    return self;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_currentPwdTf resignFirstResponder];
    [_newpwd1 resignFirstResponder];
    [_newpwd2tf resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [PublicFunction setButtonBorder:_finishBtn];
    [PublicFunction setInputBackViewBorder:_view1];
    [PublicFunction setInputBackViewBorder:_view2];
    [PublicFunction setInputBackViewBorder:_view3];
}
- (IBAction)finishAction:(id)sender {
    NSString *currentPwd = _currentPwdTf.text;
    NSString*pwd1 = _newpwd1.text;
    NSString*pwd2 = _newpwd2tf.text;
    
    if (currentPwd == nil || [currentPwd isEqualToString:@""]) {
        [LZAlertView showMessage:@"Please enter current password" byStyle:Alert_Error];
        return;
    }
    if (pwd1 == nil || [pwd1 isEqualToString:@""]|| pwd2 ==nil || [pwd2 isEqualToString:@""]) {
        [LZAlertView showMessage:@"Please enter new password" byStyle:Alert_Error];
        return;
        
    }
    if (![pwd1 isEqualToString:pwd2]) {
        [LZAlertView showMessage:@"Password not matched" byStyle:Alert_Error];
        return;
    }
    
    SHOW_LOADING_MESSAGE(@"", self.view);
    [AccountManager changePasswordWithOld:currentPwd withNew:pwd2 withCompleted:^(id result, BOOL success) {
        if (success) {
            [LZAlertView showMessage:@"Change Success" byStyle:Alert_Success];
            EtyUser *user = [AccountManager sharedInstance].currentUser;
            
            [SSKeychain setPassword:pwd2 forService:kKeyChainSaveAccountService account:user.name];
            POP_CONTROLLER;
        }else{
            [LZAlertView showMessage:result byStyle:Alert_Error];
        }
        DISMISS_LOADING;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
