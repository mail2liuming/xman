//
//  HomeNearByListView.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/18.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeNearByListView : UIView<UITableViewDataSource,UITableViewDelegate>

- (void)getListData;

- (void)reloadDataWithCategory:(NSString *)category withOrder:(NSString *)order;

-(void)showDetails: (NSInteger)index;

-(void)checkShowingDetailsNeeded;

@property (nonatomic,strong)void(^showCategoryBlock)(BOOL);

@end
