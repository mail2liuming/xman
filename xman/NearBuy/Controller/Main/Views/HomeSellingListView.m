//
//  HomeSellingListView.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/19.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "HomeSellingListView.h"
#import "TBLoadMoreControl.h"
#import "EtyAd.h"
#import "AdCell.h"
#import "ItemAdDetailController.h"
#import "UserLoginController.h"
#import "ItemNewAdController.h"
#import "DBModel.h"
#import "NewAdDetailController.h"
#import "SubTabOfSell.h"
typedef NS_ENUM(NSInteger, LoadTabType) {
    current_type = 0,
    expired_type,
    withdrawn_type
};

@interface HomeSellingListView()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UISegmentedControl *switchControl;
@property (strong, nonatomic) IBOutlet UITableView *table;
//@property (nonatomic,strong)YooPushRefreshHelper *refrehHelper;
//@property (nonatomic,strong)TBLoadMoreControl *loadMoreControl;

@property (nonatomic,strong)NSMutableArray *tabs;
@property (nonatomic,assign)LoadTabType currentType;
@property (strong, nonatomic) IBOutlet UIView *addSellingView;
@end

@implementation HomeSellingListView
{
    BOOL loaded;
}
- (id)initView{
    self = LOAD_XIB_CLASS(HomeSellingListView);
    if (self) {
        
        self.currentType = current_type;

        self.backgroundColor = RGB(237, 237, 237);

        self.table.delegate = self;
        self.table.dataSource = self;
        self.tabs = [NSMutableArray array];
        for (int i=0;i<3;i++){
            [self.tabs addObject:[[SubTabOfSell alloc] init]];
        }
        self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak typeof(self) weakSelf = self;
        self.table.width = UIScreenWidth;
        
        [self.table addLegendHeaderWithRefreshingBlock:^{
            [weakSelf pullToRefresh];
        }];
        if (HAS_LOGIN) {
            [self.table addLegendFooterWithRefreshingBlock:^{
                if ([AccountManager sharedInstance].hasLogin) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    SubTabOfSell *tab = weakSelf.tabs[strongSelf.currentType];
                    tab.currentIndex+=1;
                    [strongSelf getData];
                }
                
            }];

        }

        [_switchControl addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logouHandle) name:LOGOUT_NOTIFICATION_POST object:nil];
        
        
    }
    return self;
}

- (void)logouHandle{
    for(int i=0;i<3;i++){
        SubTabOfSell *tab = self.tabs[i];
        [tab.datas removeAllObjects];
    }
    [self.table reloadData];
}

- (IBAction)addNewAdAction:(id)sender {
    if (HAS_LOGIN) {
        ItemNewAdController*vc = [[ItemNewAdController alloc]initController];
        PUSH_CONTROLLER(vc);
    }else{
        UserLoginController *vc= [[UserLoginController alloc]initController];
        PUSH_CONTROLLER(vc);
    }
}

- (void)segmentChange:(UISegmentedControl *)seg{
    if (![AccountManager sharedInstance].hasLogin) {
        return;
    }
    NSInteger index= seg.selectedSegmentIndex;
    if (index == self.currentType) {
        return;
    }
    SHOW_LOADING_MESSAGE(nil, nil);
    self.currentType = index;
    [self getData];
}
- (IBAction)gotoAddSellingAction:(id)sender {
    if (HAS_LOGIN) {
        ItemNewAdController*vc = [[ItemNewAdController alloc]initController];
        PUSH_CONTROLLER(vc);
    }else{
        UserLoginController *vc= [[UserLoginController alloc]initController];
        PUSH_CONTROLLER(vc);
    }

}

- (void)pullToRefresh{
    SubTabOfSell *tab = self.tabs[self.currentType];
    tab.currentIndex = 1;
    [self getData];
    
}
- (void)loadSellingData{
    if (HAS_LOGIN) {
        [self.table.header beginRefreshing];
    }
}
- (void)loadFirstData{
    if (loaded) {
//        return;
    }
    SubTabOfSell *tab = self.tabs[self.currentType];
    tab.currentIndex = 1;
    if (HAS_LOGIN) {
        SHOW_LOADING_MESSAGE(nil, nil);
        __weak typeof(self)weakSelf = self;
        [self.table addLegendFooterWithRefreshingBlock:^{
            if ([AccountManager sharedInstance].hasLogin) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                SubTabOfSell *tab = weakSelf.tabs[strongSelf.currentType];
                tab.currentIndex+=1;
                [strongSelf getData];
            }
            
        }];
    }else{
        self.table.tableFooterView =  nil;
    }
    [self getData];
}
- (void)getData{
    if (!HAS_LOGIN) {
        [self.table.header endRefreshing];
        return;
    }
    NSString *state = [NSString stringWithFormat:@"%ld",(long)self.currentType+1];
    SubTabOfSell *tab = self.tabs[self.currentType];
    [EtyAd getMyAdByType:state withIndex:tab.currentIndex withFinish:^(id result, BOOL success) {
        if (success) {
            [self handleData:result];
            loaded = YES;
        }else{
            [LZAlertView showMessage:result byStyle:Alert_Error];
        }
        
        [self.table.header endRefreshing];
        DISMISS_LOADING;
    }];

}

- (void)handleData:(NSArray*)data{
    SubTabOfSell *tab = self.tabs[self.currentType];
    if (tab.currentIndex == 1) {
        [tab.datas removeAllObjects];
    }
    [tab.datas addObjectsFromArray:data];
    NSLog(@"the count is %lu",(unsigned long)data.count);
    if (data.count<10) {
        [self.table.footer noticeNoMoreData];
    }else{
        [self.table.footer endRefreshing];
    }

    if (tab.currentIndex == 1 && tab.datas.count == 0 && self.currentType == current_type) {
        [self.addSellingView setHidden:NO];
    }else{
        [self.addSellingView setHidden:YES];
    }
    [self.table reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SubTabOfSell *tab = self.tabs[self.currentType];
    return tab.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}

- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AdCell *cell = LOAD_XIB_CLASS(AdCell);
    SubTabOfSell *tab = self.tabs[self.currentType];
    EtyAd *ad = tab.datas[indexPath.row];
    [cell fillDataThinkDate:ad byType:@"1"];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SubTabOfSell *tab = self.tabs[self.currentType];
    EtyAd *ad = tab.datas[indexPath.row];
    [[DBModel sharedInstance]updateAd:ad toType:@"1"];
    [self.table reloadData];
    if (self.currentType == current_type) {
        
        NewAdDetailController *vc = [[NewAdDetailController alloc]initWithAd:ad withFunction:MY_CURRENT_FUNCTION];
//        vc.showWatch = watched;
        vc.ReloadListDataBlock=^{
            [self pullToRefresh];
        };
        vc.type = @"1";
        PUSH_CONTROLLER(vc);

        
//        ItemAdDetailController *vc = [[ItemAdDetailController alloc]initWithAd:ad withEdit:YES];
//        vc.type = @"1";
//        vc.ReloadListDataBlock=^{
//            [self getData];
//        };
//        PUSH_CONTROLLER(vc);
   
    }else if(self.currentType == expired_type){
        
        NewAdDetailController *vc = [[NewAdDetailController alloc]initWithAd:ad withFunction:MY_EXPIRED_FUNCTION];
        //        vc.showWatch = watched;
        vc.ReloadListDataBlock=^{
            [self pullToRefresh];
        };
        vc.type = @"1";
        PUSH_CONTROLLER(vc);

        
//        ItemAdDetailController *vc = [[ItemAdDetailController alloc]initWithAd:ad withRelist:YES withStatus:@"Expired"];
//        vc.ReloadListDataBlock=^{
//            [self getData];
//        };
//        vc.type = @"1";
//
//        PUSH_CONTROLLER(vc);

    }else if (self.currentType == withdrawn_type){
        
        NewAdDetailController *vc = [[NewAdDetailController alloc]initWithAd:ad withFunction:MY_WITHDRAWN_FUNCTION];
        //        vc.showWatch = watched;
        vc.ReloadListDataBlock=^{
            [self pullToRefresh];
        };
        vc.type = @"1";
        PUSH_CONTROLLER(vc);

        
//        ItemAdDetailController *vc = [[ItemAdDetailController alloc]initWithAd:ad withRelist:YES withStatus:@"Withdrawn"];
//        vc.isWithdrawn = YES;
//        vc.ReloadListDataBlock=^{
//            [self getData];
//        };
//        vc.type = @"1";
//
//        PUSH_CONTROLLER(vc);
//
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    _addBtn.layer.cornerRadius = 4.0;
}
@end
