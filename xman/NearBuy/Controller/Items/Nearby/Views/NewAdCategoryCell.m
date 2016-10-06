//
//  NewAdCategoryCell.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "NewAdCategoryCell.h"

@interface NewAdCategoryCell()
@property (strong, nonatomic) IBOutlet UIView *backVIEW;

@property (strong, nonatomic) IBOutlet UILabel *categoryLb;
@end

@implementation NewAdCategoryCell

- (void)awakeFromNib {
    _backVIEW.layer.cornerRadius = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCategory:(NSString *)category{
    _categoryLb.text = category;
}
@end
