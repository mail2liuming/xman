//
//  AdCommentController.m
//  NearBuy
//
//  Created by URoad_MP on 15/9/8.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "AdCommentController.h"
#import "CommentCell.h"
#import "SendCommentView.h"
#import "UserLoginController.h"
#import "DBModel.h"
@interface AdCommentController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic,strong)EtyAd *currentAd;
@property (nonatomic,strong)YooPushRefreshHelper *refreshHelper;
@property (nonatomic,strong)NSMutableArray *modelDatas;
@property (nonatomic,strong)SendCommentView *inputView;
@end

@implementation AdCommentController
{
    NSInteger pageIndex;
    __block BOOL hasMoreData;
}
- (id)initWithEty:(EtyAd *)ety{
    self = [super initWithTitle:@"Comments"];
    if (self) {
        _modelDatas = [NSMutableArray array];
        _currentAd = ety;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)showInputView{
    if (HAS_LOGIN) {
    [_inputView beginTextEditing];
    }else{
        UserLoginController *vc =[[UserLoginController alloc]initController];
        PUSH_CONTROLLER(vc);
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 60)];
    footerV.backgroundColor=[UIColor clearColor];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setTitle:@"  Add comment" forState:UIControlStateNormal];
    
    [addBtn setImage:[UIImage imageNamed:@"AddCommentImage"] forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(20, 5, UIScreenWidth - 40, 50);
    addBtn.backgroundColor = RGB(150, 188, 51);
    [addBtn addTarget:self action:@selector(showInputView) forControlEvents:UIControlEventTouchUpInside];
    [footerV addSubview:addBtn];
    
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCellModel *model = _modelDatas[indexPath.row];
    return model.cellHeght;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identfier = @"cellIdentifier";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
    if (cell == nil) {
        cell =[[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    cell.cellModel = _modelDatas[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.tableFooterView = [[UIView alloc]init];
    _table.delegate = self;
    _table.dataSource =self;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_refreshHelper == nil) {
        __weak typeof(self)weakSelf = self;

        _refreshHelper = [[YooPushRefreshHelper alloc]initWithScrollView:_table];
        _refreshHelper.refreshBlock=^{
            if (hasMoreData) {
                pageIndex += 1;
                [weakSelf getData];
                
            }else{
                [_refreshHelper completed];
//                [LZAlertView showMessage:@"No more comments" byStyle:Alert_Error];

            }
        };
        _inputView = LOAD_XIB_CLASS(SendCommentView);
        _inputView.frame = CGRectMake(0, UIScreenHeight, UIScreenWidth, 50);
        _inputView.sendMessageBlock=^(NSString *text){
            [weakSelf addCommentByText:text];
        };
        [self.view addSubview:_inputView];
        
        pageIndex = 1;
        [weakSelf getData];
        
        if (HAS_LOGIN) {
            [AccountManager registerPushSetting];
        }
        
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)addCommentByText:(NSString *)text{
    SHOW_LOADING_MESSAGE(@"sending", self.view);
    __weak typeof(self)weakSelf = self;
    [_currentAd addNewCommentByContent:text withFinish:^(id result, BOOL success) {
        if (success) {
            [_inputView clearInputText];
            if ([self.type isEqualToString:@"0"]) {
                
            }else{
                
                NSString *count = [[DBModel sharedInstance]queryCommentCount:self.currentAd byType:self.type];
                NSInteger c = [count integerValue]+1;
                self.currentAd.commentcount = [NSString stringWithFormat:@"%ld",(long)c];
                [[DBModel sharedInstance]updateAd:self.currentAd toType:self.type];

            }
            if (self.reloadTableData) {
                self.reloadTableData();
            }
            
            pageIndex = 1;
            [weakSelf getData];
        }else{
            [LZAlertView showMessage:result byStyle:Alert_Error];
        }
        DISMISS_LOADING;
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];

}
- (void)keyboardWillShow:(NSNotification *)notice{
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
    NSValue *keyboardBoundsValue = [[notice userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
#else
    NSValue *keyboardBoundsValue = [[notice userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
#endif
    CGRect keyboardEndRect = [keyboardBoundsValue CGRectValue];
    CGFloat keyboardHeight = keyboardEndRect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _inputView.frame =  CGRectMake(0, UIScreenHeight - keyboardHeight - 50, UIScreenWidth, 50);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notice{
    [UIView animateWithDuration:0.3 animations:^{
        _inputView.top = UIScreenHeight;
    } completion:^(BOOL finished) {
    }];
}

- (void)getData{
    
    [_currentAd getAdCommentByIndex:pageIndex withFinish:^(id result, BOOL success) {
        if (success) {
            [self handleData:result];
        }
        if (pageIndex == 1) {
            
//            [_refreshHelper completed];
        }
        [_refreshHelper completed];

        
    }];
}
- (void)handleData:(NSArray *)datas{
    if (datas.count >= 10) {
        hasMoreData = YES;
    }else{
        hasMoreData = NO;
    }
    if (pageIndex == 1) {
        [_modelDatas removeAllObjects];
    }
    if ([datas isKindOfClass:[NSArray class]] && datas.count>0) {
        [datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CommentCellModel *model = [[CommentCellModel alloc]init];
//            model.attachComment = obj;
            [model configEtyCommentModel:obj withSellUserId:_currentAd.user_id];
            [_modelDatas insertObject:model atIndex:0];
        }];
        [_table reloadData];
        
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat off_y = scrollView.contentOffset.y;
    NSLog(@"off_y=%0.2f",off_y);
    
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
