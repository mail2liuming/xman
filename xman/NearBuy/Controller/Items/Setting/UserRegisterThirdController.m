//
//  UserRegisterThirdController.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/20.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "UserRegisterThirdController.h"

@interface UserRegisterThirdController ()

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;


@property (strong, nonatomic) IBOutlet UILabel *lb;
@property (strong, nonatomic) IBOutlet UITextField *nicknameTf;
@property (strong, nonatomic) IBOutlet UITextField *pwd1Tf;

@property (strong, nonatomic) IBOutlet UITextField *pwd2tf;
@property (strong, nonatomic) IBOutlet UIButton *finishBtn;

@property (nonatomic,strong)NSString*attachPhone;
@property (nonatomic,strong)NSString *attachCode;
@end

@implementation UserRegisterThirdController

- (id)initWithPhone:(NSString *)phone withCode:(NSString *)code{
    self = [super initWithTitle:@"Registration"];
    if (self) {
        self.attachCode = code;
        self.attachPhone = phone;
        
    }
    return self;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nicknameTf resignFirstResponder];
    [self.pwd1Tf resignFirstResponder];
    [self.pwd2tf resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _lb.clipsToBounds = YES;
    _lb.layer.cornerRadius = 3.0;
    [PublicFunction setButtonBorder:self.finishBtn];
    [PublicFunction setInputBackViewBorder:self.view1];
    [PublicFunction setInputBackViewBorder:self.view2];
    [PublicFunction setInputBackViewBorder:self.view3];
    
}
- (IBAction)finishAction:(id)sender {
    
    NSString *nickName = _nicknameTf.text;
    NSString*pwd1 = _pwd1Tf.text;
    NSString*pwd2 = _pwd2tf.text;
    if (![PublicFunction checkStringIsValid:nickName]) {
        [LZAlertView showMessage:@"Please enter your nickname" byStyle:Alert_Error];
        return;
    }
    if (![PublicFunction checkStringIsValid:pwd1] || ![PublicFunction checkStringIsValid:pwd2]) {
        [LZAlertView showMessage:@"Please check your password" byStyle:Alert_Error];
        return;
    }
    if (![pwd2 isEqualToString:pwd1]) {
        [LZAlertView showMessage:@"Two password do not match" byStyle:Alert_Error];
        return;
    }
    SHOW_LOADING_MESSAGE(@"Registering", self.view);
    [AccountManager registerUserWithPhone:_attachPhone withPwdMD5:[pwd1 MD5Hash] withNickName:nickName withCode:_attachCode withCompleted:^(id result, BOOL success) {
        if (success) {
            [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_NOTIFICATION_POST object:nil];
            [SSKeychain setPassword:pwd1 forService:kKeyChainSaveAccountService account:nickName];
            [LZAlertView showMessage:@"Registration Successful!" byStyle:Alert_Success];
            [MAIN_NAVI_CONTROLLER popToRootViewControllerAnimated:YES];
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
