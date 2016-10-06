//
//  OrderByCell.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/18.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderByCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLb;
@property (strong, nonatomic) IBOutlet UIImageView *imgV;
@property (nonatomic,assign)BOOL drawable;
- (void)drawLine;
@property (nonatomic,strong)UIImage *selectimg;
@property (nonatomic,strong)UIImage *unSelectimg;
- (void)selectHighlightStyle:(BOOL)highlight;
@end
