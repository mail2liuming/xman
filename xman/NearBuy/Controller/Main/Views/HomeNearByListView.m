//
//  HomeNearByListView.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/18.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "HomeNearByListView.h"
#import "TBRefreshControl.h"
#import "EtyAd.h"
#import "AdCell.h"
#import "TBLoadMoreControl.h"
#import "ItemAdDetailController.h"
#import "NewAdDetailController.h"
#import "UserLoginController.h"
@interface HomeNearByListView ()
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)NSString *category;
@property (nonatomic,strong)NSString *orderby;
@property (nonatomic,strong)EtyAdRequest*adRequest;
//@property (nonatomic,strong)YooPushRefreshHelper *refreshHelper;
//@property (nonatomic,strong)TBLoadMoreControl *loadMoreControl;

@end

@implementation HomeNearByListView
{
    NSInteger pageIndex;
    NSInteger itemIndex;
    BOOL loading;
    BOOL firstLoading;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(237, 237, 237);
        pageIndex = 1;
        itemIndex = -1;
        _category = @"0";
        _orderby = @"latest";
        _adRequest = [[EtyAdRequest alloc]init];
        _adRequest.category = _category;
        _adRequest.orderby = _orderby;
        _datas = [NSMutableArray array];
        self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, UIScreenWidth, self.bounds.size.height - 64) style:UITableViewStylePlain];
        [self.table setDelegate:self];
        [self.table setDataSource:self];
        self.table.backgroundColor = RGB(237, 237, 237);
        [self.table registerClass:[AdCell class] forCellReuseIdentifier:@"AdCellIdentifier"];
        [self addSubview:self.table];
        self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak typeof(self) weakSelf = self;
        firstLoading = YES;
        [self.table addLegendHeaderWithRefreshingBlock:^{
            if (firstLoading) {
                firstLoading = NO;
            }else{
                [weakSelf pullToRefresh];
                
            }
        }];
        
//        _refreshHelper = [[YooPushRefreshHelper alloc]initWithScrollView:self.table];
//        _refreshHelper.refreshBlock=^{
//            if (firstLoading) {
//                firstLoading = NO;
//            }else{
//                [weakSelf pullToRefresh];
//
//            }
//        };
        
        [self.table addLegendFooterWithRefreshingBlock:^{
            pageIndex+=1;
//            [weakSelf.loadMoreControl changeStyle:loading_style];
            [weakSelf getFirstData];

        }];
//        _loadMoreControl = [[TBLoadMoreControl alloc]initMore];
//        _loadMoreControl.LoadNextPageDataBlock=^{
//            pageIndex+=1;
//            [weakSelf.loadMoreControl changeStyle:loading_style];
//            [weakSelf getFirstData];
//        };
//        self.table.tableFooterView = _loadMoreControl;

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getFirstData) name:LOGIN_NOTIFICATION_POST object:nil];
        
        UISwipeGestureRecognizer *recognizer;
        
        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self addGestureRecognizer:recognizer];

        
    }
    return self;
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)sender{
    if(sender.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        NSLog(@"swipe left");
        //执行程序
        if (self.showCategoryBlock) {
            self.showCategoryBlock(NO);
        }
    }
    
    
    
    if(sender.direction==UISwipeGestureRecognizerDirectionRight) {
        
        NSLog(@"swipe right");
        //执行程序
        if (self.showCategoryBlock) {
            self.showCategoryBlock(YES);
        }

    }
}
- (void)getListData{
    if (loading) {
//        return;
    }
    SHOW_LOADING_MESSAGE(@"loading", self);
    [self getFirstData];
}
- (void)pullToRefresh{
    [self getFirstData];
}
- (void)reloadDataWithCategory:(NSString *)category withOrder:(NSString *)order{
    _adRequest.category = category;
    _adRequest.orderby = order;

    pageIndex = 1;
    SHOW_LOADING_MESSAGE(@"loading", self);
    [self getFirstData];
}

- (void)getFirstData{
    
    [[LocationManager sharedInstance]startUpdateLocationWithCompleted:^(BOOL success) {
        if (success) {
            [[LocationManager sharedInstance]stopUpdateLocation];
            loading = YES;
            _adRequest.session_id = [AccountManager sharedInstance].hasLogin?[AccountManager sharedInstance].currentUser.session_id:@"";
            _adRequest.pageindex = [NSString stringWithFormat:@"%ld",(long)pageIndex];
            _adRequest.lat = [NSString stringWithFormat:@"%0.6f",[LocationManager sharedInstance].currentLocation.coordinate.latitude];
            _adRequest.lng = [NSString stringWithFormat:@"%0.6f",[LocationManager sharedInstance].currentLocation.coordinate.longitude];
            [EtyAd getAd_NearAdByParam:_adRequest withFinish:^(id result, BOOL success) {
                DISMISS_LOADING;
                firstLoading = NO;
                if (success) {
                    [self handleDataWithResult:result];
                }else{
                    [LZAlertView showMessage:result byStyle:Alert_Error];
                }
                [self.table.legendHeader endRefreshing];
                
                //        [_refreshHelper completed];
                //        [_refreshHelper updateLastRefreshTime];
                loading = YES;
            }];

        }else{
            [self.table.legendHeader endRefreshing];
        }
    }];
    

}
- (void)handleDataWithResult:(NSArray*)result{
    if (pageIndex == 1) {
        [self.datas removeAllObjects];
    }
    [self.datas addObjectsFromArray:result];
    if (result.count<10) {
//        [_loadMoreControl changeStyle:nomore_style];
        [self.table.footer noticeNoMoreData];
    }else{
        [self.table.footer endRefreshing];
//        [_loadMoreControl changeStyle:normal_style];
    }
    [self.table reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AdCell *cell = LOAD_XIB_CLASS(AdCell);
    EtyAd *ad = _datas[indexPath.row];
    [cell fillData:ad byType:@"0"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (HAS_LOGIN) {
        [self showDetails:indexPath.row];
    }else{
        itemIndex =indexPath.row;
        UserLoginController *vc= [[UserLoginController alloc]initController];
        PUSH_CONTROLLER(vc);
    }
    
    
//    ItemAdDetailController *det = [[ItemAdDetailController alloc]initWithAd:ad];
//    PUSH_CONTROLLER(det);
    
//    ItemAdDetailController *vc = [[ItemAdDetailController alloc]initWithAd:ad showWatch:watched];
//    vc.ReloadListDataBlock=^{
//        [self pullToRefresh];
//    };
//    vc.type = @"0";
//
//    PUSH_CONTROLLER(vc);
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

-(void)showDetails: (NSInteger)index{
    if(index >=0 && index < [_datas count]){
        EtyAd *ad = _datas[index];
        BOOL watched = NO;
        if (ad.in_watchlist == 1) {
            watched = YES;
        }
        
        
        NewAdDetailController *vc = [[NewAdDetailController alloc]initWithAd:ad withFunction:NORMAL_FUNCTION];
        vc.showWatch = watched;
        vc.ReloadListDataBlock=^{
            [self pullToRefresh];
        };
        vc.type = @"0";
        PUSH_CONTROLLER(vc);
    }
}

-(void)checkShowingDetailsNeeded{
    if(itemIndex >=0){
        if (HAS_LOGIN) {
            [self showDetails:itemIndex];
        }
        itemIndex = -1;
    }
}

@end
