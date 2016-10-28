//
//  Member.m
//  xman
//
//  Created by Liu Ming on 28/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "Member.h"
#import "PhotoWrapper.h"

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

-(instancetype)init{
    self = [super init];
    if(self){
        self.uid = nil;
        self.name = @"eva";
        self.birthday = @"1990";
        self.height = @"170";
        self.weight = @"100";
        self.haircolor = @"red";
        self.eyecolor = @"red";
        self.size = @"38d";
        self.phonenum = @"123456";
        self.allowsms = @"yes";
        self.pics = [[NSArray alloc]init];
        self.options = [[NSArray alloc]init];
    }
    return self;
}

-(instancetype)initFromDictionary: (NSDictionary*) member withUid: (NSString*)uid{
    self = [super init];
    if(self){
//        self.uid = member[MemberFieldUid];
        self.uid = uid;
        self.name = member[MemberFieldName];
        self.birthday = member[MemberFieldBirthday];
        self.height = member[MemberFieldHeight];
        self.weight = member[MemberFieldWeight];
        self.haircolor = member[MemeberFieldHaircolor];
        self.eyecolor = member[MemberFieldEyecolor];
        self.size = member[MemberFieldSize];
        self.phonenum = member[MemeberFieldPhonenum];
        self.allowsms = member[MemeberFieldAllowsms];
        self.pics = [PhotoWrapper fromUrlArray:  member[MemberFieldPics]];
        self.options = member[MemberFieldOptions];
    }
    return self;
}

-(NSDictionary*) toDictionary{
    NSMutableDictionary* girl = [[NSMutableDictionary alloc]init];
    NSMutableDictionary* member = [[NSMutableDictionary alloc]init];
    
//    member[MemberFieldUid]=self.uid;
    member[MemberFieldName]=self.name;
    member[MemberFieldBirthday]=self.birthday;
    member[MemberFieldHeight]=self.height ;
    member[MemberFieldWeight]=self.weight ;
    member[MemeberFieldHaircolor]=self.haircolor;
    member[MemberFieldEyecolor]=self.eyecolor ;
    member[MemberFieldSize]=self.size ;
    member[MemeberFieldPhonenum]=self.phonenum ;
    member[MemeberFieldAllowsms]=self.allowsms;
    member[MemberFieldPics]=[PhotoWrapper toUrlArray:self.pics];
    member[MemberFieldOptions]=self.options ;
    
//    girl[self.uid]=member;
    
    return member;
}


@end
