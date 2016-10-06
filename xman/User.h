//
//  User.h
//  xman
//
//  Created by Liu Ming on 28/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

//User Object Constants
static NSString * const USER_ID = @"memberID";
static NSString * const USER_NUMBER = @"number";
static NSString * const USER_PASSWORD = @"password";

@interface User : NSObject

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *account_num;
@property (nonatomic,strong) NSString *password;

-(instancetype)initWithUserId: (NSString*)id UserPWD: (NSString*)userpwd UserEmail: (NSString*)useremail;

@end
