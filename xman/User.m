//
//  User.m
//  xman
//
//  Created by Liu Ming on 28/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "User.h"

@implementation User


-(instancetype)initWithUserId: (NSString*)id UserPWD: (NSString*)userpwd UserEmail: (NSString*)useremail{
    self = [super init];
    if(self){
        self.ID = id;
        self.account_num = useremail;
        self.password = userpwd;
    }
    return self;
}

@end
