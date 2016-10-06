//
//  FeedbackController.m
//  NearBuy
//
//  Created by URoad_MP on 15/11/19.
//  Copyright © 2015年 nearbuy. All rights reserved.
//

#import "FeedbackController.h"

@interface FeedbackController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)UITextView *inputTextV;
@property (nonatomic,strong)UILabel *placeholdLb;

@end

@implementation FeedbackController
- (id)initController{
    self = [super initWithTitle:@"feedback"];
    if (self) {
        [self registerKeyboardNotification];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _placeholdLb = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, UIScreenWidth, 15)];
    _placeholdLb.text  =@"Please enter details here";
    _placeholdLb.textColor = [UIColor lightGrayColor];
    _placeholdLb.font = FONT(15);
    
    _inputTextV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 150)];
    _inputTextV.delegate = self;
    _inputTextV.font = FONT(15);
    
    UITableViewController *tbc = [[UITableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    self.table =tbc.tableView;
    self.table.frame = CGRectMake(0, 0, self.view.size.width, self.view.frame.size.height);
    
    self.table.delegate = self;
    self.table.dataSource = self;
    //    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    //        self.table.tableFooterView = [[UIView alloc]init];
    //    self.table.backgroundColor = RGB(237, 237, 237);
    self.table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    //        _footerView = LOAD_XIB_CLASS(NewAdFooterView);
    //        _footerView.frame = CGRectMake(0, 0, UIScreenWidth, 100);
    //        _footerView.delegate = self;
    //        self.table.tableFooterView = _footerView;
    //        _footerView.height = 100;
    [self.view addSubview:self.table];
    [self addChildViewController:tbc];
    self.automaticallyAdjustsScrollViewInsets = YES;

    UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 100)];
    footV.backgroundColor = [UIColor clearColor];
    
    self.table.tableFooterView = footV;
    
    UIButton *commentB = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentB setTitle:@"Submit" forState:UIControlStateNormal];
    commentB.backgroundColor = UI_NAVIBAR_COLOR;
    commentB.frame = CGRectMake(10, 5, UIScreenWidth - 20, 44);
    commentB.layer.cornerRadius = 4.0;
    [commentB addTarget:self action:@selector(sendReport) forControlEvents:UIControlEventTouchUpInside];
    [footV addSubview:commentB];

}

- (void)sendReport{
    NSString*input = _inputTextV.text;
    if (input == nil || [input isEqualToString:@""]) {
        [LZAlertView showMessage:@"Please enter the content briefly" byStyle:Alert_Error];
        return;
        
    }
    [_inputTextV resignFirstResponder];
    SHOW_LOADING_MESSAGE(@"loading", self.view);
    [[AccountManager sharedInstance]sendFeedbackWithContent:input withCompleted:^(id result, BOOL success) {
        if (success) {
            [LZAlertView showMessage:result byStyle:Alert_Success];
            POP_CONTROLLER;
        }else{
            [LZAlertView showMessage:result byStyle:Alert_Error];
        }
        DISMISS_LOADING;
    }];
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        [_placeholdLb setHidden:YES];
    }else{
        [_placeholdLb setHidden:NO];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identfier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [cell.contentView addSubview:_inputTextV];
    [cell.contentView addSubview:_placeholdLb];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //    [tableView reloadRowsAtIndexPaths:@[selectPath] withRowAnimation:UITableViewRowAnimationNone];
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
