//
//  UserRegisterFirstController.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/19.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "UserRegisterFirstController.h"
#import "DBManager.h"
#import "CountrySelectView.h"
#import "UserRegisterSecondController.h"
#import "AboutController.h"
#import "ChangeMobileController.h"
#define agree @"by register you agree with our terms and conditions"

typedef NS_ENUM(NSInteger, Controller_Type) {
    controller_Register = 0,
    controller_ChangeMobile,
    controller_ResetPassword
};

@interface UserRegisterFirstController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *inputPhoneTf;
@property (strong, nonatomic) IBOutlet UIView *view1;

@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) IBOutlet UILabel *conditionLb;
@property (strong, nonatomic) IBOutlet UILabel *countryCodeLb;
@property (strong, nonatomic) IBOutlet UILabel *countryNameLb;
@property (strong, nonatomic) IBOutlet UILabel *areaCodeLb;

@property (nonatomic,strong)CountrySelectView *countryView;
@property (nonatomic,strong)UIView *overlayView;
@property (nonatomic,assign)Controller_Type cType;

@property (strong, nonatomic) IBOutlet UILabel *tLb1;
@property (strong, nonatomic) IBOutlet UILabel *tLb2;
@end

@implementation UserRegisterFirstController

- (id)initController{
    self = [super initWithTitle:@"Registration"];
    if (self) {
        [PublicFunction setInputBackViewBorder:self.view1];
        [PublicFunction setInputBackViewBorder:self.view2];
        [PublicFunction setButtonBorder:self.registerBtn];
        _cType = controller_Register;
        _inputPhoneTf.delegate = self;
        CLPlacemark *place = [LocationManager sharedInstance].currentPlacemark;
        if (place) {
            [[DBManager sharedInstance]getCountryCodeByName:place.country completed:^(id result, BOOL success) {
                if (success) {
                    NSString *code = result;
                    self.areaCodeLb.text = [NSString stringWithFormat:@"+%@",code];
                    self.countryNameLb.text = place.country;
                }
            }];

        }
    }
    return self;
}

- (id)initWithChangeMobile{
    self = [super initWithTitle:@"Change Mobile Number"];
    if (self) {
        [PublicFunction setInputBackViewBorder:self.view1];
        [PublicFunction setInputBackViewBorder:self.view2];
        [PublicFunction setButtonBorder:self.registerBtn];
        _cType = controller_ChangeMobile;
        [self.registerBtn setTitle:@"Next" forState:UIControlStateNormal];
    }
    return self;

}
- (id)initWithForgotPwd{
    self = [super initWithTitle:@"Reset Password"];
    if (self) {
        [PublicFunction setInputBackViewBorder:self.view1];
        [PublicFunction setInputBackViewBorder:self.view2];
        [PublicFunction setButtonBorder:self.registerBtn];
        _cType = controller_ResetPassword;
        [self.registerBtn setTitle:@"Next" forState:UIControlStateNormal];
    }
    return self;

}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.inputPhoneTf resignFirstResponder];
}
- (IBAction)showSelectCountryAction:(id)sender {

    [self showCountryView];
}

- (void)showCountryView{
    
    [self.view addSubview:self.countryView];
    [self.view insertSubview:self.overlayView belowSubview:self.countryView];
    [UIView animateWithDuration:0.3 animations:^{
        self.countryView.top = UIScreenHeight - 269;
        self.overlayView.alpha = 0.4;
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)dismissCountryView{
    [UIView animateWithDuration:0.3 animations:^{
        self.countryView.top = UIScreenHeight;
        self.overlayView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.overlayView removeFromSuperview];
        [self.countryView removeFromSuperview];
    }];
}
- (void)showCondition{
    AboutController *vc = [[AboutController alloc]initWithTitle:@"Terms & Condition" withType:TermPage];
    PUSH_CONTROLLER(vc);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (DEVICE_IS_IPHONE_5 || DEVICE_IS_IPHONE_4) {
        _tLb1.font = FONT(18);
        _tLb2.font = FONT(18);
    }
    
    NSMutableAttributedString*condition = [[NSMutableAttributedString alloc]initWithString:agree];
    NSDictionary *atts = @{NSForegroundColorAttributeName:UI_NAVIBAR_COLOR};
    NSDictionary *atts1 = @{NSForegroundColorAttributeName:RGB(138, 138, 138)};
    [condition setAttributes:atts range:NSMakeRange(31, 20)];
    [condition setAttributes:atts1 range:NSMakeRange(0, 30)];
    _conditionLb.attributedText = condition;
    _conditionLb.textAlignment = NSTextAlignmentCenter;
    _conditionLb.userInteractionEnabled = YES;
    if (DEVICE_IS_IPHONE_4 || DEVICE_IS_IPHONE_5) {
        _conditionLb.font = FONT(13);
    }
    UITapGestureRecognizer*tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCondition)];
    tap1.numberOfTapsRequired = 1;
    tap1.numberOfTouchesRequired =1;
    [_conditionLb addGestureRecognizer:tap1];
    
    __weak typeof(self) weakself= self;
    [[DBManager sharedInstance]getAllCountry:^(id result, BOOL success) {
        if (success) {
            self.countryView = [[CountrySelectView alloc]initWithDatas:result];
            self.countryView.frame = CGRectMake(0, UIScreenHeight, UIScreenWidth, 269);
            self.countryView.dismissBlock=^{
                [weakself dismissCountryView];
            };
            self.countryView.confirmBlock=^(NSString *name){
                [weakself dismissCountryView];
                [weakself findCodeByName:name];
            };
        }
    }];
    self.overlayView =[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.alpha = 0.0;
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissCountryView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.overlayView addGestureRecognizer:tap];
    
}
- (IBAction)registerAction:(id)sender {
    NSString*phone = _inputPhoneTf.text;

    if (phone == nil || [phone isEqualToString:@""]) {
        [LZAlertView showMessage:@"Please enter your mobile number." byStyle:Alert_Error];
        return;
    }
    NSString *firstChar = [phone substringToIndex:1];
    if ([firstChar isEqualToString:@"0"]) {
        phone = [phone substringFromIndex:1];
    }

    NSString *fullPhone = [NSString stringWithFormat:@"%@%@",_areaCodeLb.text,phone];
    NSString *notice = [NSString stringWithFormat:@"Is this number correct? We will send a verification code to %@",fullPhone];
    [LZAlertControl showAlertWithTitle:@"Confirm your number" withRemark:notice withBlock:^(BOOL confirm) {
        if (confirm) {
            
            SHOW_LOADING_MESSAGE(@"sending", self.view);
            
            if (_cType == controller_Register || _cType == controller_ChangeMobile) {
                [AccountManager sendRegisterSMSByPhoneNumber:fullPhone withCompleted:^(id result, BOOL success) {
                    if (success) {
                        if (_cType == controller_ChangeMobile) {
                            //if change mobile
//                            ChangeMobileController *vc = [[ChangeMobileController alloc]initWithPhone:fullPhone];
//                            PUSH_CONTROLLER(vc);
                            UserRegisterSecondController *vc = [[UserRegisterSecondController alloc]initWithChangePhone:fullPhone];
                            PUSH_CONTROLLER(vc);

                        }else if(_cType == controller_Register){
                            UserRegisterSecondController *vc = [[UserRegisterSecondController alloc]initWithPhone:fullPhone];
                            PUSH_CONTROLLER(vc);
                        }
                    }else{
                        [LZAlertView showMessage:result byStyle:Alert_Error];
                    }
                    DISMISS_LOADING;
                }];

            }else if (_cType == controller_ResetPassword){
                [AccountManager sendSMSByPhoneNumber:fullPhone withIsRest:@"1" withCompleted:^(id result, BOOL success) {
                    if (success) {
                        UserRegisterSecondController *vc = [[UserRegisterSecondController alloc]initWithResetPwdWithPhone:fullPhone];
                        PUSH_CONTROLLER(vc);

                    }else{
                        [LZAlertView showMessage:result byStyle:Alert_Error];
                    }
                    DISMISS_LOADING;
                }];
            }
            
        }
    }];
    
}

- (void)findCodeByName:(NSString *)name{
    self.countryNameLb.text= name;
    [[DBManager sharedInstance]getCountryCodeByName:name completed:^(id result, BOOL success) {
        if (success) {
            NSString *code = result;
            self.areaCodeLb.text = [NSString stringWithFormat:@"+%@",code];
        }
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *tobestring = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _inputPhoneTf) {
        if (tobestring.length == 1 && [tobestring isEqualToString:@"0"]) {
            return NO;
        }else{
            return YES;
        }
    }
    
    return YES;
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
