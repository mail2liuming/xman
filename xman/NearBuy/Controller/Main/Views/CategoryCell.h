//
//  CategoryCell.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/18.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EtyAdCategory.h"
@interface CategoryCell : UITableViewCell


- (void)setContentEty:(EtyAdCategory *)category;

- (void)selectHighlight:(BOOL)highlight;

@end
