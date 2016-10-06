//
//  Member.m
//  xman
//
//  Created by Liu Ming on 28/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "Member.h"

@implementation Member

NSString *const MemberFieldName = @"name";
NSString *const MemberFieldUid= @"uid";
NSString *const MemberFieldBirthday=@"birthday";
NSString *const MemberFieldHeight=@"height";
NSString *const MemberFieldWeight=@"weight";
NSString *const MemeberFieldHaircolor=@"haircolor";
NSString *const MemberFieldEyecolor=@"eyecolor";
NSString *const MemberFieldSize=@"size";
NSString *const MemeberFieldPhonenum=@"phonenum";
NSString *const MemeberFieldAllowsms=@"allowsms";
NSString *const MemberFieldPics=@"pics";
NSString *const MemberFieldOptions=@"options";

-(instancetype)initFromDictionary: (NSDictionary*) member{
    self = [super init];
    if(self){
        self.uid = member[MemberFieldUid];
        self.name = member[MemberFieldName];
        self.birthday = member[MemberFieldBirthday];
        self.height = member[MemberFieldHeight];
        self.weight = member[MemberFieldWeight];
        self.haircolor = member[MemeberFieldHaircolor];
        self.eyecolor = member[MemberFieldEyecolor];
        self.size = member[MemberFieldSize];
        self.phonenum = member[MemeberFieldPhonenum];
        self.allowsms = member[MemeberFieldAllowsms];
        self.pics = member[MemberFieldPics];
        self.options = member[MemberFieldOptions];
    }
    return self;
}

-(NSDictionary*) toDictionary{
    NSMutableDictionary* member = [[NSMutableDictionary alloc]init];
    
    member[MemberFieldUid]=self.uid;
    member[MemberFieldName]=self.name;
    member[MemberFieldBirthday]=self.birthday;
    member[MemberFieldHeight]=self.height ;
    member[MemberFieldWeight]=self.weight ;
    member[MemeberFieldHaircolor]=self.haircolor;
    member[MemberFieldEyecolor]=self.eyecolor ;
    member[MemberFieldSize]=self.size ;
    member[MemeberFieldPhonenum]=self.phonenum ;
    member[MemeberFieldAllowsms]=self.allowsms;
    member[MemberFieldPics]=self.pics;
    member[MemberFieldOptions]=self.options ;
    
    return member;
}


@end
