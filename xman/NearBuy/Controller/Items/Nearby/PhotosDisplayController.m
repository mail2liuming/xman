//
//  PhotosDisplayController.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "PhotosDisplayController.h"
#import "FenLiuPicView.h"
@interface PhotosDisplayController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scView;
@property (strong, nonatomic) IBOutlet UILabel *contentLb;
@property (strong, nonatomic) IBOutlet UIPageControl *pageC;
@property (nonatomic,strong)NSArray *attachArray;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,assign)NSInteger startIndex;

@end

@implementation PhotosDisplayController

- (id)initControllerWithUrlsArray:(NSArray *)array withTitles:(NSArray *)titles withNaviTitle:(NSString *)title withSelectIndex:(NSInteger)index{
    self = [super initWithTitle:title];
    if (self) {
        _startIndex= index;
        
        _attachArray = array;
        _titles = titles;
        if (SYSTEM_VERSION_LATER_THAN_7_0) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return self;
}
- (void)configUI{
    
    __block CGFloat x = 0;
    CGFloat top = 0;
    if (SYSTEM_VERSION_LATER_THAN_7_0) {
        top = 0;
    }
    [_attachArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        FenLiuPicView *subV = [[FenLiuPicView alloc]initViewWithEty:obj];
        subV.frame = CGRectMake(x, top, UIScreenWidth, _scView.height);
        [_scView addSubview:subV];
        x = CGRectGetMaxX(subV.frame);
        
    }];
    _scView.delegate = self;
    _pageC.numberOfPages = _attachArray.count;
    _scView.contentSize = CGSizeMake(x, _scView.height);
    
    [self showContentTitleWithIndex:_startIndex];
    [_scView setContentOffset:CGPointMake(UIScreenWidth*_startIndex, 0)];
    _pageC.currentPage = _startIndex;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self configUI];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat off_x = scrollView.contentOffset.x;
    NSInteger page = off_x / UIScreenWidth;
    _pageC.currentPage = page;
    [self showContentTitleWithIndex:page];
}
- (void)showContentTitleWithIndex:(NSInteger)index{
    NSString *ety = _titles[index];
    _contentLb.text = SAFE_STRING(ety);
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
