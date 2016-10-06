//
//  HomeWatchListView.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "HomeWatchListView.h"
#import "AdCell.h"
#import "ItemAdDetailController.h"
#import "TBLoadMoreControl.h"
#import "DBModel.h"
#import "NewAdDetailController.h"
@interface HomeWatchListView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSMutableArray *datas;
//@property (nonatomic,strong)YooPushRefreshHelper *refreshHelper;
//
//@property (nonatomic,strong)TBLoadMoreControl *loadMoreControl;
@property (nonatomic,strong)NSMutableArray *removeAds;

@end

@implementation HomeWatchListView
{
    NSInteger currentIndex;
    BOOL isloaded;

}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(237, 237, 237);
        self.removeAds = [NSMutableArray array];
        self.datas = [NSMutableArray array];
        currentIndex = 1;
        self.table = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        [self.table setDelegate:self];
        [self.table setDataSource:self];
        self.table.backgroundColor = RGB(237, 237, 237);

        [self.table registerClass:[AdCell class] forCellReuseIdentifier:@"AdCellIdentifier"];
        [self addSubview:self.table];
        self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        __weak typeof(self) weakSelf = self;
        
        [self.table addLegendHeaderWithRefreshingBlock:^{
            [weakSelf pullToRefresh];
        }];
        if (HAS_LOGIN) {
            [self.table addLegendFooterWithRefreshingBlock:^{
                currentIndex+=1;
                
                [weakSelf getData];
                
            }];

        }
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearData) name:LOGOUT_NOTIFICATION_POST object:nil];
    }
    
    return self;
}
- (void)clearData{
    [self.datas removeAllObjects];
    [self.table reloadData];
}

- (void)pullToRefresh{
    currentIndex = 1;
    [self getData];
}
- (void)deleteWatch{
    if (self.removeAds.count>0) {
        
        [LZAlertControl showAlertWithTitle:@"Confirm" withRemark:@"Confirm to delete?" withBlock:^(BOOL confirm) {
            if (confirm) {
                SHOW_LOADING_MESSAGE(@"deleting", self);
                
                NSInteger count = self.removeAds.count;
                
                __block NSInteger completedCount = 0;
                
                
                void(^checkRemoveCompleted)(void)=^{
                    if (completedCount == count) {
                        
                        [self.datas removeObjectsInArray:self.removeAds];
                        [self.table reloadData];
                        [self.removeAds removeAllObjects];
                        [self cancelToEdit];
                        if (self.finishEditingBlock) {
                            self.finishEditingBlock();
                        }
                        DISMISS_LOADING;
                    }
                };
                
                
                [self.removeAds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    EtyAd *ad = obj;
                    [EtyAd deleteMyWatchByAdId:ad.ad_id withFinish:^(id result, BOOL success) {
                        completedCount+=1;
                        checkRemoveCompleted();
                    }];
                }];

            }
        }];
        
        
    }
}
- (void)loadFirst{
    if (isloaded) {
//        return;
    }
    if (HAS_LOGIN) {
        SHOW_LOADING_MESSAGE(@"loading", self);
        __weak typeof(self)weakSelf = self;
        [self.table addLegendFooterWithRefreshingBlock:^{
            currentIndex+=1;
            
            [weakSelf getData];
            
        }];

        [self getData];
    }else{
        self.table.tableFooterView =  nil;
    }
    
}

- (void)changeToEdit{
    self.editing = YES;
    [self.table setEditing:YES animated:YES];
}

- (void)cancelToEdit{
    self.editing = NO;
    [self.table setEditing:NO animated:YES];
    [self.removeAds removeAllObjects];
}
- (void)getData{
    [self getDataCanShowAlert:YES];
}

- (void)getDataCanShowAlert:(BOOL)can{
    if (HAS_LOGIN) {
        [EtyAd getMyWatchByPageIndex:currentIndex withFinish:^(id result, BOOL success) {
            if (success) {
                isloaded = YES;
                [self handleDataWithResult:result];
            }else{
                if (can) {
                    [LZAlertView showMessage:result byStyle:Alert_Error];
                }
            }
            DISMISS_LOADING;
            [self.table.header endRefreshing];
        }];

    }else{
        [self.table.header endRefreshing];
        [self.table.footer endRefreshing];

    }

}

- (void)handleDataWithResult:(NSArray*)result{
    if (currentIndex == 1) {
        [self.datas removeAllObjects];
    }
    [self.datas addObjectsFromArray:result];
    if (result.count<10) {
        [_table.footer noticeNoMoreData];
    }else{
        [_table.footer endRefreshing];
    }
    [self.table reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}

- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AdCell *cell = LOAD_XIB_CLASS(AdCell);
    EtyAd *ad = _datas[indexPath.row];
    [cell fillDataThinkDate:ad byType:@"2"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editing) {
        EtyAd *ad = _datas[indexPath.row];
        [self.removeAds addObject:ad];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    EtyAd *ad = _datas[indexPath.row];
    
    [[DBModel sharedInstance]updateAd:ad toType:@"2"];
    [tableView reloadData];
    
    NewAdDetailController *vc = [[NewAdDetailController alloc]initWithAd:ad withFunction:FAVOURITES_FUNCTION];
    vc.showWatch = YES;
    vc.ReloadListDataBlock=^{
        [self getDataCanShowAlert:NO];
    };
    vc.type = @"2";
    PUSH_CONTROLLER(vc);

    
//    ItemAdDetailController *vc = [[ItemAdDetailController alloc]initWithAd:ad showWatch:YES];
//    vc.ReloadListDataBlock=^{
//        [self getDataCanShowAlert:NO];
//    };
//    vc.type = @"2";
//
//    PUSH_CONTROLLER(vc);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editing) {
        EtyAd *ad = _datas[indexPath.row];
        if ([self.removeAds containsObject:ad]) {
            [self.removeAds removeObject:ad];
        }

    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
