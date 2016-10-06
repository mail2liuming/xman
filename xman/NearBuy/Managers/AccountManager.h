//
//  AccountManager.h
//  Parking
//
//  Created by 罗 建镇 on 15/3/31.
//  Copyright (c) 2015年 L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EtyUser.h"
@interface AccountManager : NSObject

AS_SINGLETON(AccountManager);

@property (nonatomic,strong)EtyUser*currentUser;

@property (nonatomic,assign)BOOL hasLogin;

@property (nonatomic,assign)BOOL hasOldInfo;

- (void)autoLoginCompleted:(void(^)(void))completed;

+ (void)registerUserWithPhone:(NSString *)phone withPwdMD5:(NSString *)pwd withNickName:(NSString*)nickname withCode:(NSString*)code withCompleted:(LoadServerDataFinishedBlock)block;

+ (void)loginWithAccount:(NSString*)account withPwd:(NSString *)pwd withCompleted:(LoadServerDataFinishedWithRetBlock)block;

+ (void)loginWithAccount:(NSString *)account withPwd:(NSString *)pwd byForce:(NSString*)force withCompleted:(LoadServerDataFinishedWithRetBlock)block;


+ (void)sendRegisterSMSByPhoneNumber:(NSString*)phone withCompleted:(LoadServerDataFinishedBlock)block;

+ (void)sendSMSByPhoneNumber:(NSString *)phone withIsRest:(NSString*)isreset withCompleted:(LoadServerDataFinishedBlock)block;

+ (void)checkAuthCodeValidByPhone:(NSString *)phone byCode:(NSString *)code withCompleted:(LoadServerDataFinishedBlock)block;

+ (void)changePasswordWithOld:(NSString*)pwd1 withNew:(NSString*)pwd2 withCompleted:(LoadServerDataFinishedBlock)block;

+ (void)changeMobilePhoneWithPhone:(NSString *)phone withCode:(NSString *)code withCompleted:(LoadServerDataFinishedBlock)block;

+ (void)resetPasswordByPhone:(NSString*)phone withCode:(NSString *)code withPassword:(NSString *)pwd withCompleted:(LoadServerDataFinishedBlock)block;

+ (void)registerPushSetting;

- (void)sendFeedbackWithContent:(NSString *)content withCompleted:(LoadServerDataFinishedBlock)block;


@end
