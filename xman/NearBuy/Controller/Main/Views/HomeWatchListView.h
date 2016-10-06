//
//  HomeWatchListView.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeWatchListView : UIView

- (void)loadFirst;

- (void)changeToEdit;
- (void)cancelToEdit;

@property (nonatomic,assign)BOOL editing;

- (void)deleteWatch;
@property (nonatomic,strong)void(^finishEditingBlock)(void);
@end
