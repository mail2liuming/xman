//
//  UserLoginController.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/19.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "UserLoginController.h"
#import "UserRegisterFirstController.h"
@interface UserLoginController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *accountTf;
@property (strong, nonatomic) IBOutlet UITextField *pwdTf;

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UILabel *forgotPwdLb;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@end

@implementation UserLoginController

- (id)initController{
    self = [super initWithTitle:@"Login"];
    if (self) {
        self.pwdTf.delegate = self.accountTf.delegate = self;
        self.loginBtn.layer.cornerRadius =3.0;
        self.registerBtn.layer.cornerRadius =3.0;
        [PublicFunction setInputBackViewBorder:self.topView];
    }
    return self;
}
- (IBAction)gotoRegister:(id)sender {
    UserRegisterFirstController *vc = [[UserRegisterFirstController alloc]initController];
    PUSH_CONTROLLER(vc);
}
- (IBAction)loginAction:(id)sender {
    NSString *account = _accountTf.text;
    NSString*pwd = _pwdTf.text;
    if (account == nil || [account isEqualToString:@""]) {
        [LZAlertView showMessage:@"Please enter your username" byStyle:Alert_Error];
        return;
    }
    NSString *firstChar = [account substringToIndex:1];
    if ([firstChar isEqualToString:@"0"]) {
        account = [account substringFromIndex:1];
    }

    if (pwd == nil || [pwd isEqualToString:@""]) {
        [LZAlertView showMessage:@"Please enter your password" byStyle:Alert_Error];
        return;
    }
    SHOW_LOADING_MESSAGE(@"login", self.view);
    [AccountManager loginWithAccount:account withPwd:pwd withCompleted:^(id result, BOOL success, NSInteger ret) {
        DISMISS_LOADING;
        if (success) {

            [[SSKeychain accountsForService:kKeyChainSaveAccountService] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"%@",obj);
               BOOL delete = [SSKeychain deletePasswordForService:kKeyChainSaveAccountService account:[obj valueForKey:@"acct"]];
                if (delete) {
                    NSLog(@"删除密码成功");
                }else{
                    NSLog(@"删除密码失败");
                    
                }
            }];

            
            if (ret == 4) {
                
                [LZAlertControl showAlertWithTitle:@"Warning" withRemark:@"Your account has been logged in on a different device,Select Confirm to log in from this device,you will be logged out from the previous device automatically" withBlock:^(BOOL confirm) {
                    if (confirm) {
                        SHOW_LOADING_MESSAGE(@"login", self.view);
                        [AccountManager loginWithAccount:account withPwd:pwd byForce:@"1" withCompleted:^(id result, BOOL success, NSInteger ret) {
                            DISMISS_LOADING;
                            if (success) {
                                [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_NOTIFICATION_POST object:nil];
                                [SSKeychain setPassword:pwd forService:kKeyChainSaveAccountService account:account];
                                [LZAlertView showMessage:@"Welcome to Swoop" byStyle:Alert_Success];
                                POP_CONTROLLER;
                            }else{
                                [LZAlertView showMessage:result byStyle:Alert_Error];
                            }
                        }];
                        
                    }
                }];
                
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_NOTIFICATION_POST object:nil];
                [SSKeychain setPassword:pwd forService:kKeyChainSaveAccountService account:account];
                [LZAlertView showMessage:@"Welcome to Swoop" byStyle:Alert_Success];
                POP_CONTROLLER;
            }
        }else{
            [LZAlertView showMessage:result byStyle:Alert_Error];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.accountTf) {
        [_pwdTf becomeFirstResponder];
    }else{
        [_pwdTf resignFirstResponder];
        [_accountTf resignFirstResponder];
    }
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_accountTf resignFirstResponder];
    [_pwdTf resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _forgotPwdLb.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoResetPwd)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired =1;
    [_forgotPwdLb addGestureRecognizer:tap];

}

- (void)gotoResetPwd{
    UserRegisterFirstController *vc = [[UserRegisterFirstController alloc]initWithForgotPwd];
    PUSH_CONTROLLER(vc);
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
