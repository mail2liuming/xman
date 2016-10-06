//
//  ResetPasswordController.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/22.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "ResetPasswordController.h"

@interface ResetPasswordController ()
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIButton *finishBtn;
@property (strong, nonatomic) IBOutlet UITextField *pwd1Tf;
@property (strong, nonatomic) IBOutlet UITextField *pwd2tf;

@property (nonatomic,strong)NSString *attachPhone;
@property (nonatomic,strong)NSString *attachCode;
@end

@implementation ResetPasswordController

- (id)initWithPhone:(NSString *)phone byCode:(NSString *)code{
    self = [super initWithTitle:@"New Password"];
    if (self) {
        self.attachCode = code;
        self.attachPhone = phone;
        
        [PublicFunction setButtonBorder:self.finishBtn];
        [PublicFunction setInputBackViewBorder:_view1];
        [PublicFunction setInputBackViewBorder:_view2];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)finishAction:(id)sender {
    NSString *pwd1 = _pwd1Tf.text;
    NSString *pwd2 = _pwd2tf.text;
    if ([pwd1 isEqualToString:@""] || [pwd2 isEqualToString:@""]) {
        [LZAlertView showMessage:@"Please input new password" byStyle:Alert_Error];
        return;
    }
    if (![pwd1 isEqualToString:pwd2]) {
        [LZAlertView showMessage:@"Password not matched" byStyle:Alert_Error];
        return;
    }
    
    SHOW_LOADING_MESSAGE(nil, nil);
    [AccountManager resetPasswordByPhone:_attachPhone withCode:_attachCode withPassword:pwd2 withCompleted:^(id result, BOOL success) {
        if (success) {
            
            [LZAlertView showMessage:@"Reset Success" byStyle:Alert_Success];
//            POP_CONTROLLER_BY_BACKINDEX(3);
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
