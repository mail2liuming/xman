//
//  ItemNearBySearchController.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/17.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "ItemNearBySearchController.h"
#import "TBRefreshControl.h"
#import "EtyAd.h"
#import "AdCell.h"
#import "TBLoadMoreControl.h"
#import "ItemAdDetailController.h"
@interface ItemNearBySearchController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic,strong)NSMutableArray *datas;
@property (nonatomic,strong)TBLoadMoreControl *loadMoreControl;
@property (nonatomic,strong)UITextField *searchTf;
@end

@implementation ItemNearBySearchController
{
    NSInteger pageIndex;
    NSString *keyWord;
}
- (id)initController{
    self = [super initWithTitle:@""];
    if (self) {
        self.datas = [NSMutableArray array];
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    return self;
}

- (void)createSearchBar{
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(20, 50, UIScreenWidth-20, 34)];
    searchView.backgroundColor = RGB(53, 130, 170);
    searchView.layer.cornerRadius = 3.0;
    
    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, searchView.frame.size.width - 65, 34)];
    tf.borderStyle = UITextBorderStyleNone;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.placeholder = @"enter to search";
    tf.textColor = [UIColor whiteColor];
    tf.returnKeyType = UIReturnKeySearch;
    tf.delegate = self;
    tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"enter to search" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    [searchView addSubview:tf];
    self.searchTf =tf;
    UIImage *clearImg = [UIImage imageNamed:@"NaviClose"];
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:clearImg forState:UIControlStateNormal];
    [clearButton setFrame:CGRectMake(0, 0, clearImg.size.width, clearImg.size.height)];
    [clearButton addTarget:self action:@selector(clearTextField) forControlEvents:UIControlEventTouchUpInside];
    
    tf.rightViewMode = UITextFieldViewModeAlways; //can be changed to UITextFieldViewModeNever,    UITextFieldViewModeWhileEditing,   UITextFieldViewModeUnlessEditing
    [tf setRightView:clearButton];
    
    self.titleView = searchView;

}

- (void)clearTextField{
    self.searchTf.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![textField.text isEqualToString:@""]) {
        keyWord = textField.text;
        pageIndex = 1;
        [textField resignFirstResponder];
        [self search];
    }
    return YES;
}

- (void)search{
    if (keyWord == nil) {
        return;
    }
    SHOW_LOADING_MESSAGE(nil, nil);
    [EtyAd searchAdByKeyword:keyWord withIndex:pageIndex withFinish:^(id result, BOOL success) {
        if (success) {
            [self handleDataWithResult:result];
        }else{
            [LZAlertView showMessage:result byStyle:Alert_Error];
        }
        DISMISS_LOADING;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSearchBar];
//    TBRefreshControl *refresh = [[TBRefreshControl alloc]initView];
//    [refresh addControlScrollView:_table];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.tableFooterView = [[UIView alloc]init];
    __weak typeof(self) weakSelf =self;
    _loadMoreControl = [[TBLoadMoreControl alloc]initMore];
    _loadMoreControl.LoadNextPageDataBlock=^{
        pageIndex+=1;
        [weakSelf.loadMoreControl changeStyle:loading_style];
        [weakSelf search];
    };

    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)handleDataWithResult:(NSArray*)result{
    if (pageIndex == 1) {
        [self.datas removeAllObjects];
    }
    [self.datas addObjectsFromArray:result];
    
    if (result.count == 0) {
        if (pageIndex == 1) {
            [_loadMoreControl changeStyle:nosearch_style];
        }else{
            [_loadMoreControl changeStyle:nomore_style];
            
        }
    }
    else if (result.count<10 && result.count>0) {
        [_loadMoreControl changeStyle:nomore_style];
    }else{
        [_loadMoreControl changeStyle:normal_style];
    }
    self.table.tableFooterView = _loadMoreControl;
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
    
    EtyAd *ad = _datas[indexPath.row];
    ItemAdDetailController *vc = [[ItemAdDetailController alloc]initWithAd:ad showWatch:NO];
    PUSH_CONTROLLER(vc);
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
