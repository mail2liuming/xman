//
//  CellOfGirlList.h
//  xman
//
//  Created by Liu Ming on 29/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"

@interface CellOfGirlList : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *available;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

-(void) attachMemberInfo: (Member*)member;
@end
