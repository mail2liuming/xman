//
//  CategoryListView.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/17.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryListViewDelegate <NSObject>

@required
- (void)selectCategory:(NSString *)category andOrder:(NSString *)order;

@end

@interface CategoryListView : UIView
- (id)initView;
@property (nonatomic,strong)id<CategoryListViewDelegate>delegate;

@property (nonatomic,strong)void(^hideCategorySelfBlock)(void);
@end
