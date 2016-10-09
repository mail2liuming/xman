//
//  Member.h
//  xman
//
//  Created by Liu Ming on 28/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Member : NSObject

extern NSString *const MemberFieldName;
extern NSString *const MemberFieldUid;
extern NSString *const MemberFieldBirthday;
extern NSString *const MemberFieldHeight;
extern NSString *const MemberFieldWeight;
extern NSString *const MemeberFieldHaircolor;
extern NSString *const MemberFieldEyecolor;
extern NSString *const MemberFieldSize;
extern NSString *const MemeberFieldPhonenum;
extern NSString *const MemeberFieldAllowsms;
extern NSString *const MemberFieldPics;
extern NSString *const MemberFieldOptions;



@property (nonatomic,strong)NSString* uid;
@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* birthday;
@property (nonatomic,strong)NSString* height;
@property (nonatomic,strong)NSString* weight;
@property (nonatomic,strong)NSString* haircolor;
@property (nonatomic,strong)NSString* eyecolor;
@property (nonatomic,strong)NSString* size;
@property (nonatomic,strong)NSString* phonenum;
@property (nonatomic,strong)NSString* allowsms;
@property (nonatomic,strong)NSArray* pics;
@property (nonatomic,strong)NSArray* options;

-(instancetype)initFromDictionary: (NSDictionary*) member withUid: (NSString*)uid;
-(NSDictionary*) toDictionary;

@end
