//
//  CellOfGirlList.m
//  xman
//
//  Created by Liu Ming on 29/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "CellOfGirlList.h"
#import "PhotoWrapper.h"
#import "UIImageView+AFNetworking.h"


@implementation CellOfGirlList

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)attachMemberInfo:(Member *)member{
    [self.name setText:member.name];
    if (member.pics !=nil){
        if(member.pics.count > 0){
            PhotoWrapper* url = member.pics[0];
            [self.icon setImageWithURL:[NSURL URLWithString:url.showImageUrl]];
        }
    }
}

@end
