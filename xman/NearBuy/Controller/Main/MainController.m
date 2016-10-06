//
//  MainController.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/16.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "MainController.h"
#import "BottomTabBarView.h"
#import "ItemNearBySearchController.h"
#import "EtyAd.h"
#import "CategoryListView.h"
#import "HomeSellingListView.h"
#import "HomeNearByListView.h"
#import "HomeSettingView.h"
#import "HomeWatchListView.h"
@interface MainController ()<CategoryListViewDelegate>
@property (nonatomic,strong)BottomTabBarView *tabar;
@property (nonatomic,strong)CategoryListView *leftCategoryView;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)HomeNearByListView *nearbyListView;
@property (nonatomic,strong)HomeSellingListView *sellingView;
@property (nonatomic,strong)HomeSettingView *settingView;
@property (nonatomic,strong)HomeWatchListView *watchListView;
@property (nonatomic,strong)UIView *overlayView;
@end

@implementation MainController
{
    NSInteger currentIndex;
    UIView *showView;
    BOOL showCategory;
    BOOL startLaunch;
}
@synthesize tabar = _tabar;
@synthesize leftCategoryView = _leftCategoryView;
@synthesize nearbyListView = _nearbyListView;
@synthesize sellingView = _sellingView;
@synthesize settingView = _settingView;
@synthesize watchListView = _watchListView;
- (HomeNearByListView *)nearbyListView{
    if (!_nearbyListView) {
        _nearbyListView = [[HomeNearByListView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight  - kTabBarHeight)];
        _nearbyListView.showCategoryBlock=^(BOOL show){
            if (show) {
                [self showCategoryView];
            }
        };
    }
    
    return _nearbyListView;
}

- (HomeSellingListView *)sellingView{
    if (!_sellingView) {
        _sellingView = [[HomeSellingListView alloc]initView];
    }
    return _sellingView;
}
- (HomeSettingView *)settingView{
    if (!_settingView) {
        _settingView = [[HomeSettingView alloc]initWithFrame:CGRectMake(0, 64, UIScreenWidth, UIScreenHeight  - kTabBarHeight - 64)];
    }
    return _settingView;
}

- (HomeWatchListView*)watchListView{
    if (!_watchListView) {
        _watchListView = [[HomeWatchListView alloc]initWithFrame:CGRectMake(0, 64, UIScreenWidth, UIScreenHeight  - kTabBarHeight-64)];
        _watchListView.finishEditingBlock=^{
            self.naviLeftBtnImg = nil;
            self.naviRightBtnImg = [UIImage imageNamed:@"NaviTrash"];
        };
    }
    return _watchListView;
}

- (CategoryListView*)leftCategoryView{
    if (!_leftCategoryView) {
        _leftCategoryView = [[CategoryListView alloc]initView];
        _leftCategoryView.delegate = self;
        _leftCategoryView.hideCategorySelfBlock=^{
            [self hideCategoryView];
        };
    }
    return _leftCategoryView;
}


- (BottomTabBarView *)tabar{
    if (!_tabar) {
        NSArray *titles = @[@"NEARBY",@"SELL",@"FAVOURITES",@"SETTINGS"];
        NSArray *sImages = @[[UIImage imageNamed:@"tabBarNearBuyS"],[UIImage imageNamed:@"tabBarSellingS"],[UIImage imageNamed:@"tabBarWatchListS"],[UIImage imageNamed:@"tabBarSettingS"]];
        NSArray *uImages = @[[UIImage imageNamed:@"tabBarNearBuyU"],[UIImage imageNamed:@"tabBarSellingU"],[UIImage imageNamed:@"tabBarWatchListU"],[UIImage imageNamed:@"tabBarSettingU"]];
        
        _tabar = [[BottomTabBarView alloc]initWithTitles:titles bySelectImages:sImages byUnSelectImages:uImages];
        _tabar.frame = CGRectMake(0, UIScreenHeight - kTabBarHeight, _tabar.frame.size.width, _tabar.frame.size.height);
    }
    return _tabar;
}

+ (MainController *)sharedInstance{
    static MainController *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[MainController alloc]initController];
    });
    return obj;
}

- (id)initController{
    self = [super initWithTitle:@""];
    if (self) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) blockSelf= self;
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight  - kTabBarHeight)];
    self.contentView.backgroundColor = RGB(237, 237, 237);

    [self.view addSubview:self.contentView];
    _overlayView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, UIScreenWidth, UIScreenHeight - 20)];
    _overlayView.backgroundColor = [UIColor blackColor];
    _overlayView.alpha = 0.0;
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideCategoryView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired =1;
    [_overlayView addGestureRecognizer:tap];
    
    [self.view addSubview:self.tabar];
    self.tabar.tabBarSelectIndexBlock=^(NSInteger index){
        [blockSelf chooseTabBarIndex:index];
    };
    [self.tabar setDefaultSelectIndex:0];
    [self chooseItem0First];
    
    UIImage *titleImage = [UIImage imageNamed:@"NaviBarTitleImg1"];
    
//    CGFloat w = titleImage.size.width*(titleImage.size.height - 20)/titleImage.size.height;
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, titleImage.size.height)];
    imgV.image = titleImage;
    self.titleView = imgV;
    self.automaticallyAdjustsScrollViewInsets = YES;

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (startLaunch) {
        
    }else{
        __block NSInteger completedCount = 0;
        __block BOOL hasLoadNearListData = NO;
        void(^loadNearListData)(void)=^{
            if (hasLoadNearListData) {
                return ;
            }
            if (completedCount == 2) {
                hasLoadNearListData = YES;
                [self.nearbyListView getListData];
                completedCount = 0;
            }
        };
        
        [[LocationManager sharedInstance]startUpdateLocationWithCompleted:^(BOOL success) {
            completedCount+=1;
            loadNearListData();
        }];
        if ([AccountManager sharedInstance].hasOldInfo) {
            
            SHOW_LOADING_MESSAGE(@"logining", self.view);
            [[AccountManager sharedInstance] autoLoginCompleted:^{
                completedCount+=1;
                loadNearListData();
                DISMISS_LOADING;
            }];
            
        }else{
            completedCount+=1;
            loadNearListData();
        }
        startLaunch = YES;
    }
    
    [self.nearbyListView checkShowingDetailsNeeded];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadDataWhenAppear];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.settingView viewAppearOrDisapper:YES];
}

- (void)reloadDataWhenAppear{
    if (currentIndex == 3) {
        [self.settingView checkHasLogin];
    }else if (currentIndex == 1){
        [self.sellingView loadSellingData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.settingView viewAppearOrDisapper:NO];
}

- (void)showCategoryView{
    if (self.leftCategoryView.superview == nil) {
        self.leftCategoryView.left = - self.leftCategoryView.width;
        [[UIApplication sharedApplication].keyWindow addSubview:self.leftCategoryView];
    }
    [[UIApplication sharedApplication].keyWindow insertSubview:_overlayView belowSubview:self.leftCategoryView];
    [UIView animateWithDuration:0.3 animations:^{
        self.leftCategoryView.left = 0;
        _overlayView.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideCategoryView{
    [self hideCategoryViewWithCompleted:nil];

}

- (void)hideCategoryViewWithCompleted:(void(^)(bool))completed{
    [UIView animateWithDuration:0.3 animations:^{
        self.leftCategoryView.left = -self.leftCategoryView.width;
        _overlayView.alpha = 0.0;
        showCategory =NO;
    } completion:^(BOOL finished) {
        [_overlayView removeFromSuperview];
        if (completed) {
            completed(YES);
        }
    }];

}
- (void)chooseItem0First{
    self.naviLeftBtnImg = [UIImage imageNamed:@"NaviLeftSetting"];
    self.naviRightBtnImg = [UIImage imageNamed:@"NaviSearch"];
    [self.contentView addSubview:self.nearbyListView];
    showView = self.nearbyListView;

}

- (void)chooseItem0{
    self.naviLeftBtnImg = [UIImage imageNamed:@"NaviLeftSetting"];
    self.naviRightBtnImg = [UIImage imageNamed:@"NaviSearch"];
    [self.contentView addSubview:self.nearbyListView];
    showView = self.nearbyListView;
    [self.nearbyListView getListData];
}
- (void)chooseItem1{
    self.naviLeftBtnImg = nil;
    self.naviRightBtnImg = nil;
    
    self.sellingView.frame = CGRectMake(0, 0, UIScreenWidth, self.contentView.bounds.size.height);
    [self.contentView addSubview:self.sellingView];
    showView = self.sellingView;
    [self.sellingView loadFirstData];
}
- (void)chooseItem2{
    self.naviRightBtnImg = [UIImage imageNamed:@"NaviTrash"];
    self.naviLeftBtnImg = nil;
    [self.contentView addSubview:self.watchListView];
    [self.watchListView loadFirst];
    showView = self.watchListView;
}
- (void)chooseItem3{
    self.naviLeftBtnImg = nil;
    self.naviRightBtnImg = nil;
    [self.contentView addSubview:self.settingView];
    [self.settingView checkHasLogin];
    showView = self.settingView;
    
}

- (void)naviRightButtonClick{
    if (currentIndex == 0) {
        ItemNearBySearchController *vc = [[ItemNearBySearchController alloc]initController];
        PUSH_CONTROLLER(vc);
    }else if (currentIndex == 2){
        if (self.watchListView.editing) {
            [self.watchListView deleteWatch];
        }else{
            self.naviRightBtnImg = [UIImage imageNamed:@"NaviSubmit"];
            self.naviLeftBtnImg = [UIImage imageNamed:@"NaviCancel"];
            [self.watchListView changeToEdit];
        }
    }
}


- (void)naviLeftButtonClick{
    if (currentIndex == 0) {
        if (showCategory) {
            [self hideCategoryView];
        }else{
            [self showCategoryView];
        }
        showCategory = !showCategory;
    }else if (currentIndex == 2){
        if (self.watchListView.editing) {
            //cancel edit
            [self.watchListView cancelToEdit];
            self.naviLeftBtnImg = nil;
            self.naviRightBtnImg = [UIImage imageNamed:@"NaviTrash"];
        }
    }
}
- (void)chooseTabBarIndex:(NSInteger)index{
    NSLog(@"select index =%ld",(long)index);
    if (currentIndex == index) {
        return;
    }
    [showView removeFromSuperview];
    currentIndex = index;
    switch (currentIndex) {
        case 0:
            [self chooseItem0];
            break;
        case 1:
            [self chooseItem1];
            break;
        case 2:
            [self chooseItem2];
            break;
        case 3:
            [self chooseItem3];
            break;
        default:
            break;
    }
}

- (void)selectCategory:(NSString *)category andOrder:(NSString *)order{
    NSLog(@"category =%@,order = %@",category,order);
    [self hideCategoryViewWithCompleted:^(bool success) {
        [self.nearbyListView reloadDataWithCategory:category withOrder:order];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
