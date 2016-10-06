//
//  CellOfGirlList.m
//  xman
//
//  Created by Liu Ming on 29/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "CellOfGirlList.h"


@implementation CellOfGirlList

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)attachMemberInfo:(NSDictionary *)member{
    [self.name setText:member[MemberFieldName]];
}

@end
