//
//  UserRegisterSecondController.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/20.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "UserRegisterSecondController.h"
#import "UserRegisterThirdController.h"
#import "ResetPasswordController.h"
typedef NS_ENUM(NSInteger, Change_Type) {
    changetype_register = 0,
    changetype_changephone,
    changetype_resetpwd
};

@interface UserRegisterSecondController ()
@property (strong, nonatomic) IBOutlet UILabel *phonelb;
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong, nonatomic) IBOutlet UIView *codeBackView;

@property (strong, nonatomic) IBOutlet UITextField *codeTf;
@end

@implementation UserRegisterSecondController
{
    Change_Type currentType;
}

- (id)initWithPhone:(NSString *)phone{
    self = [super initWithTitle:@"Enter Code"];
    if (self) {
        NSString *firstChar = [phone substringToIndex:1];
        if ([firstChar isEqualToString:@"0"]) {
            phone = [phone substringFromIndex:1];
        }
        [PublicFunction setInputBackViewBorder:_codeBackView];
        [PublicFunction setButtonBorder:self.submitBtn];
        _phonelb.text = phone;
        currentType = changetype_register;
    }
    return self;
}

- (id)initWithChangePhone:(NSString *)phone{
    self = [super initWithTitle:@"Enter Code"];
    if (self) {
        NSString *firstChar = [phone substringToIndex:1];
        if ([firstChar isEqualToString:@"0"]) {
            phone = [phone substringFromIndex:1];
        }

        [PublicFunction setInputBackViewBorder:_codeBackView];
        [PublicFunction setButtonBorder:self.submitBtn];
        _phonelb.text = phone;
        currentType = changetype_changephone;
    }
    return self;
}

- (id)initWithResetPwdWithPhone:(NSString *)phone{
    self = [super initWithTitle:@"Enter Code"];
    if (self) {
        NSString *firstChar = [phone substringToIndex:1];
        if ([firstChar isEqualToString:@"0"]) {
            phone = [phone substringFromIndex:1];
        }

        [PublicFunction setInputBackViewBorder:_codeBackView];
        [PublicFunction setButtonBorder:self.submitBtn];
        _phonelb.text = phone;
        currentType = changetype_resetpwd;
    }
    return self;

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_codeTf resignFirstResponder];
}
- (IBAction)submitAction:(id)sender {
    if (currentType == changetype_changephone) {
        [self changeMobileStep];
    }else{
        [self registerSecondStep];
    }
}

- (void)registerSecondStep{
    NSString*code = _codeTf.text;
    if (code == nil || [code isEqualToString:@""]) {
        [LZAlertView showMessage:@"Please enter code" byStyle:Alert_Error];
        return;
    }
    
    SHOW_LOADING_MESSAGE(@"checking", self.view);
    [AccountManager checkAuthCodeValidByPhone:_phonelb.text byCode:code withCompleted:^(id result, BOOL success) {
        if (success) {
            if (currentType == changetype_register) {
                UserRegisterThirdController *vc = [[UserRegisterThirdController alloc]initWithPhone:_phonelb.text withCode:code];
                PUSH_CONTROLLER(vc);
            }else if (currentType == changetype_resetpwd){
                ResetPasswordController *vc = [[ResetPasswordController alloc]initWithPhone:_phonelb.text byCode:code];
                PUSH_CONTROLLER(vc);
            }
        }else{
            [LZAlertView showMessage:result byStyle:Alert_Error];
        }
        DISMISS_LOADING;
    }];
}
- (void)changeMobileStep{
    NSString*code = _codeTf.text;
    if (code == nil || [code isEqualToString:@""]) {
        [LZAlertView showMessage:@"Please enter code" byStyle:Alert_Error];
        return;
    }
    
    SHOW_LOADING_MESSAGE(@"checking", self.view);
    [AccountManager changeMobilePhoneWithPhone:_phonelb.text withCode:code withCompleted:^(id result, BOOL success) {
        if (success) {
            [LZAlertView showMessage:@"change success" byStyle:Alert_Success];
            [AccountManager sharedInstance].currentUser.phone = _phonelb.text;
            [MAIN_NAVI_CONTROLLER popToRootViewControllerAnimated:YES];
        }else{
            [LZAlertView showMessage:result byStyle:Alert_Error];
        }
        DISMISS_LOADING;
    }];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
