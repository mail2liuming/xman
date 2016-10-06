//
//  BottomTabBarView.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/16.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "BottomTabBarView.h"
#import "BottomTabBarItem.h"

@interface BottomTabBarView()
@property (nonatomic,strong)NSArray *attachTitles;
@property (nonatomic,strong)NSArray *selectImgs;
@property (nonatomic,strong)NSArray *unSelectImgs;
@property (nonatomic,strong)BottomTabBarItem *selectedItem;
@property (nonatomic,strong)NSMutableArray *items;
@end

@implementation BottomTabBarView


- (id)initWithTitles:(NSArray *)titles bySelectImages:(NSArray *)imgs byUnSelectImages:(NSArray *)unImgs{
    self = [super initWithFrame:CGRectMake(0, 0, UIScreenWidth, kTabBarHeight)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _items = [NSMutableArray array];
        __block CGFloat left = 0;
        CGFloat imgWidth = UIScreenWidth/titles.count;
        UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 0.5)];
        shadowView.backgroundColor = [UIColor lightGrayColor];
        shadowView.alpha = 0.5;
        [self addSubview:shadowView];
        [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            BottomTabBarItem *item = [[BottomTabBarItem alloc]initWithFrame:CGRectMake(left, 0.5, imgWidth, kTabBarHeight) byTitle:obj bySelectImg:imgs[idx] byUnSelectImg:unImgs[idx]];
            item.tag = idx;
            item.selectThisItemBlock=^(NSInteger thisTag){
                [self chooseTabWithIndex:thisTag];
            };
            [self addSubview:item];
            [_items addObject:item];
            left = CGRectGetMaxX(item.frame);
        }];
        
        
    }
    return self;
}

- (void)setDefaultSelectIndex:(NSInteger)defaultIndex{
    [self chooseTabWithIndex:defaultIndex];
}
- (void)chooseTabWithIndex:(NSInteger)index{
    BottomTabBarItem *item = _items[index];
    if (item == _selectedItem) {
        return;
    }
    [_selectedItem unselect];
    [item selectSelf];
    _selectedItem = item;
    if (self.tabBarSelectIndexBlock) {
        self.tabBarSelectIndexBlock(index);
    }
}


@end
