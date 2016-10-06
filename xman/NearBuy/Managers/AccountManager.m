//
//  AccountManager.m
//  Parking
//
//  Created by 罗 建镇 on 15/3/31.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import "AccountManager.h"
#import "APService.h"
@implementation AccountManager
DEF_SINGLETON(AccountManager);

- (BOOL)hasLogin{
    if (self.currentUser) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)hasOldInfo{
    
    
    
    NSDictionary *account = [SSKeychain accountsForService:kKeyChainSaveAccountService][0];
    if (account) {
        
        NSString *pwd = [SSKeychain passwordForService:kKeyChainSaveAccountService account:[account valueForKey:@"acct"]];
        if (pwd) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

- (void)autoLoginCompleted:(void (^)(void))completed{
    
    NSDictionary *account = [SSKeychain accountsForService:kKeyChainSaveAccountService][0];
    if (account) {
        
        NSString *pwd = [SSKeychain passwordForService:kKeyChainSaveAccountService account:[account valueForKey:@"acct"]];
        if (pwd) {
            [AccountManager loginWithAccount:[account valueForKey:@"acct"] withPwd:pwd withCompleted:^(id result, BOOL success, NSInteger ret) {
                if (success) {
                    [AccountManager registerPushSetting];//注册新推送
                }
                completed();
            }];
        }
        
    }
}



+ (void)registerUserWithPhone:(NSString *)phone withPwdMD5:(NSString *)pwd withNickName:(NSString *)nickname withCode:(NSString *)code withCompleted:(LoadServerDataFinishedBlock)block{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[MyUIDevice uuidValue]==nil?@"1":[MyUIDevice uuidValue] forKey:@"device_id"];
    [param setObject:phone forKey:@"phone"];
    [param setObject:@"1" forKey:@"device_type"];
    [param setObject:pwd forKey:@"password"];
    NSString*lat = [NSString stringWithFormat:@"%0.6f",[LocationManager sharedInstance].currentLocation.coordinate.latitude];
    NSString*lng = [NSString stringWithFormat:@"%0.6f",[LocationManager sharedInstance].currentLocation.coordinate.longitude];

    [param setObject:lat forKey:@"lat"];
    [param setObject:lng forKey:@"lng"];
    [param setObject:nickname forKey:@"name"];
    [param setObject:code forKey:@"code"];
    [[NetworkManager shareNetwork]POST:@"user/register" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            NSDictionary *dic = [json valueForKey:@"user"];
            NSString *userid = [dic valueForKey:@"user_id"];
            NSString *name = [dic valueForKey:@"name"];
            NSString *device_id = [dic valueForKey:@"device_id"];
            NSString *password = [dic valueForKey:@"password"];
            NSString *phone = [dic valueForKey:@"phone"];
            NSString *last_lat = [dic valueForKey:@"last_lat"];
            NSString *last_lng = [dic valueForKey:@"last_lng"];
            NSString *session_id = [dic valueForKey:@"session_id"];
            NSString *register_time = [dic valueForKey:@"register_time"];
            NSString *last_login_time = [dic valueForKey:@"last_login_time"];
            NSString *client_id = [dic valueForKey:@"client_id"];
            NSString *status = [dic valueForKey:@"status"];
            EtyUser *user = [[EtyUser alloc]init];
            user.user_id = userid;
            user.name = name;
            user.device_id= device_id;
            user.password = password;
            user.phone = phone;
            user.last_lat = last_lat;
            user.last_lng =last_lng;
            user.session_id = session_id;
            user.register_time = register_time;
            user.last_login_time = last_login_time;
            user.client_id = client_id;
            user.status = status;
            [AccountManager sharedInstance].currentUser =user;
            block(user,YES);

        }else{
            NSString*error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
    }];

}


+ (void)loginWithAccount:(NSString *)account withPwd:(NSString *)pwd withCompleted:(LoadServerDataFinishedWithRetBlock)block{
    [AccountManager loginWithAccount:account withPwd:pwd byForce:@"1" withCompleted:block];
}

+ (void)loginWithAccount:(NSString *)account withPwd:(NSString *)pwd byForce:(NSString*)force withCompleted:(LoadServerDataFinishedWithRetBlock)block{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[MyUIDevice uuidValue]==nil?@"1":[MyUIDevice uuidValue] forKey:@"device_id"];
    [param setObject:account forKey:@"phone"];
    [param setObject:@"1" forKey:@"device_type"];
    [param setObject:pwd forKey:@"password"];
    [param setObject:force forKey:@"force_login"];
    [[NetworkManager shareNetwork]POST:@"user/login" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        
        NSInteger ret = [[json valueForKey:@"ret"] integerValue];
        if (ret == 1) {
            
            NSDictionary *dic = [json valueForKey:@"user"];
            NSString *userid = [dic valueForKey:@"user_id"];
            NSString *name = [dic valueForKey:@"name"];
            NSString *device_id = [dic valueForKey:@"device_id"];
            NSString *password = [dic valueForKey:@"password"];
            NSString *phone = [dic valueForKey:@"phone"];
            NSString *last_lat = [dic valueForKey:@"last_lat"];
            NSString *last_lng = [dic valueForKey:@"last_lng"];
            NSString *session_id = [dic valueForKey:@"session_id"];
            NSString *register_time = [dic valueForKey:@"register_time"];
            NSString *last_login_time = [dic valueForKey:@"last_login_time"];
            NSString *client_id = [dic valueForKey:@"client_id"];
            NSString *status = [dic valueForKey:@"status"];
            EtyUser *user = [[EtyUser alloc]init];
            user.user_id = userid;
            user.name = name;
            user.device_id= device_id;
            user.password = password;
            user.phone = phone;
            user.last_lat = last_lat;
            user.last_lng =last_lng;
            user.session_id = session_id;
            user.register_time = register_time;
            user.last_login_time = last_login_time;
            user.client_id = client_id;
            user.status = status;
            [AccountManager sharedInstance].currentUser =user;
            
            
            [APService setAlias:userid callbackSelector:@selector(apsCallBack:) object:nil];
            
            
            block(user,YES,ret);
            
        }else if (ret == 2 || ret == 0){
            NSString *error = [json valueForKey:@"error_msg"];
            block(error,NO,ret);
        }else if (ret == 4){
            NSString *error = [json valueForKey:@"error_msg"];
            block(error,YES,ret);
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO,2);
    }];
    

}

- (void)apsCallBack:(id)obj{
    
}

+ (void)sendRegisterSMSByPhoneNumber:(NSString *)phone withCompleted:(LoadServerDataFinishedBlock)block{
    [AccountManager sendSMSByPhoneNumber:phone withIsRest:@"0" withCompleted:block];
}

+ (void)sendSMSByPhoneNumber:(NSString *)phone withIsRest:(NSString*)isreset withCompleted:(LoadServerDataFinishedBlock)block{
    NSDictionary *param = @{@"phone":phone,@"is_reset":isreset};
    [[NetworkManager shareNetwork]POST:@"user/get_code" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        NSInteger ret = [[json valueForKey:@"ret"] integerValue];
        if (ret == 1) {
            block(@"Message has been sent",YES);
        }else if (ret == 3){
            NSString *error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
    }];

}

+ (void)checkAuthCodeValidByPhone:(NSString *)phone byCode:(NSString *)code withCompleted:(LoadServerDataFinishedBlock)block{
    NSDictionary *param = @{@"phone":phone,@"code":code};
    [[NetworkManager shareNetwork]POST:@"user/check_code" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            block(nil,YES);
        }else{
            NSString *error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
    }];
}

+ (void)changePasswordWithOld:(NSString *)pwd1 withNew:(NSString *)pwd2 withCompleted:(LoadServerDataFinishedBlock)block{
    
    NSMutableDictionary*param = [NSMutableDictionary dictionary];
    [param setObject:pwd1 forKey:@"old_pwd"];
    [param setObject:pwd2 forKey:@"new_pwd"];
    [param setObject:[AccountManager sharedInstance].currentUser.session_id forKey:@"session_id"];
    [[NetworkManager shareNetwork]POST:@"user/modiy_pwd" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            block(nil,YES);
        }else{
            NSString *error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
    }];
    
}

+ (void)changeMobilePhoneWithPhone:(NSString *)phone withCode:(NSString *)code withCompleted:(LoadServerDataFinishedBlock)block{
    NSMutableDictionary*param = [NSMutableDictionary dictionary];
    [param setObject:phone forKey:@"phone"];
    [param setObject:code forKey:@"code"];
    [param setObject:[AccountManager sharedInstance].currentUser.session_id forKey:@"session_id"];
    [[NetworkManager shareNetwork]POST:@"user/modify_phone" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            block(nil,YES);
        }else{
            NSString *error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
    }];

}

+ (void)resetPasswordByPhone:(NSString *)phone withCode:(NSString *)code withPassword:(NSString *)pwd withCompleted:(LoadServerDataFinishedBlock)block{
    NSMutableDictionary*param = [NSMutableDictionary dictionary];
    [param setObject:phone forKey:@"phone"];
    [param setObject:code forKey:@"code"];
    [param setObject:pwd forKey:@"new_pwd"];
    
    [[NetworkManager shareNetwork]POST:@"user/forget_pwd" parameters:param success:^(NSURLSessionDataTask *task, id json) {
        NSInteger ret = [[json valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            block(nil,YES);
        }else{
            NSString *error = [json valueForKey:@"error_msg"];
            block(error,NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
    }];

}
- (void)sendFeedbackWithContent:(NSString *)content withCompleted:(LoadServerDataFinishedBlock)block{
    NSDictionary *param = @{@"content":content,@"session_id":self.currentUser?self.currentUser.session_id:@""};
    [[NetworkManager shareNetwork]POST:@"ad_feedback/addAdFeedbacks" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSInteger ret = [[responseObject valueForKey:@"ret"]integerValue];
        if (ret == 1) {
            block([responseObject valueForKey:@"msg"],YES);
        }else{
            NSString *error = [responseObject valueForKey:@"error_msg"];
            block(error,NO);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(LOADDATAERRORCOMMON,NO);
    }];
}
+ (void)registerPushSetting{
    if ([AccountManager sharedInstance].currentUser) {
        
        NSMutableDictionary*param = [NSMutableDictionary dictionary];
        [param setObject:[AccountManager sharedInstance].currentUser.session_id forKey:@"session_id"];

        [[NetworkManager shareNetwork]POST:@"/ad_comment/uploadPushStatus" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }
}

@end
