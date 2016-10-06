//
//  NewAdDetailController.m
//  NearBuy
//
//  Created by URoad_MP on 15/11/15.
//  Copyright © 2015年 nearbuy. All rights reserved.
//

#import "NewAdDetailController.h"
#import "ImageScrollView.h"
#import "CommentCellModel.h"
#import "CommentCell.h"
#import "SendCommentView.h"
#import "AdDetailFooterView.h"
#import "ItemNewAdController.h"
#import "UserLoginController.h"
#import "DBModel.h"
#import "ReportTableController.h"
#import "NewAdDetailFooterView.h"

@interface NewAdDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *table;
@property (nonatomic,strong)NSMutableArray *modelDatas;
@property (nonatomic,strong)EtyAd *attachAd;
@property (nonatomic,assign)FUNCTIONCODE attachFunc;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)ImageScrollView *imgLoad;
@property (nonatomic,strong)SendCommentView *inputView;
//@property (nonatomic,strong)AdDetailFooterView *footerView;
@property (nonatomic,strong)NewAdDetailFooterView *footerView;

@property (nonatomic,strong)UILabel *commentLb;

@end

@implementation NewAdDetailController
{
    NSInteger pageIndex;
    BOOL isFirsted;
    BOOL hasFinish;
}
- (id)initWithAd:(EtyAd *)ad withFunction:(FUNCTIONCODE)func{

    self = [super initWithTitle:@"Details"];
    if (self) {
        __weak typeof(self)weakSelf = self;

        self.attachAd = ad;
        self.attachFunc = func;

        
        FooterType type = Footer_Normal_AddFavi;
        if (self.attachFunc == NORMAL_FUNCTION) {
            [self addCommentRightBtn];
        }else if (self.attachFunc  == FAVOURITES_FUNCTION  ){
            type = Footer_Normal_RemoveFavi;
            [self addCommentRightBtn];
        }else if (self.attachFunc == MY_CURRENT_FUNCTION){
            type = Footer_Current;
            [self addWithdrawnBtn];
        }else if (self.attachFunc == MY_EXPIRED_FUNCTION){
            type = Footer_Expired;

        }else if (self.attachFunc == MY_WITHDRAWN_FUNCTION){
            type = Footer_Withdrawn;
        }
        
        self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight - 60) style:UITableViewStyleGrouped];
        [self.view addSubview:self.table];
        self.table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _footerView = [[NewAdDetailFooterView alloc]initWithEtyAd:self.attachAd withType:type];
        _footerView.frame = CGRectMake(0, UIScreenHeight - 120., UIScreenWidth, 120);
        [self.view addSubview:_footerView];
        UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKyboard)];
        dismissKeyboard.numberOfTouchesRequired = 1;
        dismissKeyboard.numberOfTapsRequired = 1;
        [self.table addGestureRecognizer:dismissKeyboard];
        
        _footerView.topButtonClickBlock=^{
            [weakSelf handleTopButtonClick];
        };
//        _footerView.secondButtonClickBlock=^{
//            [weakSelf showInputView];
//        };
        
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            if (type == Footer_Normal_AddFavi || type == Footer_Normal_RemoveFavi) {
                make.bottom.equalTo(self.view).offset(60);
            }else{
                make.bottom.equalTo(self.view);
            }
            make.size.mas_equalTo(CGSizeMake(UIScreenWidth, 120.));
        }];

        if (type == Footer_Normal_RemoveFavi || type == Footer_Normal_AddFavi) {
            [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 60, 0));
            }];
        }else{
            [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(64, 0, 120, 0));
            }];
        }
        if (SYSTEM_VERSION_LATER_THAN_7_0) {
            _table.separatorInset = UIEdgeInsetsZero;
        }
        if (SYSTEM_VERSION_LATER_THAN_8_0) {
            _table.layoutMargins = UIEdgeInsetsZero;
        }
        _table.tableFooterView = [[UIView alloc]init];
        _table.delegate = self;
        _table.dataSource =self;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_table addLegendHeaderWithRefreshingBlock:^{
            [weakSelf loadFirstData];
        }];
        [_table addLegendFooterWithRefreshingBlock:^{
            [weakSelf loadNextData];
        }];
        _modelDatas = [NSMutableArray array];
        
        [_table mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(UIScreenWidth, self.view.height - 120.));
        }];

        if (func == NORMAL_FUNCTION || func == FAVOURITES_FUNCTION) {
            if (self.attachAd.in_watchlist == 1) {
//                [_footerView showHasFavi:YES];
                NSMutableAttributedString *aq2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Remove from favourites"]];
                NSRange aqRange2 = {0,[aq2 length]};
                [aq2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:aqRange2];
                self.commentLb.attributedText = aq2;

            }else{
//                [_footerView showHasFavi:NO];
                NSMutableAttributedString *aq2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Add to favourites"]];
                NSRange aqRange2 = {0,[aq2 length]};
                [aq2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:aqRange2];
                self.commentLb.attributedText = aq2;
            }
        }

        
    }
    return self;
}
- (void)dismissKyboard{
    [self.view endEditing:YES];
}
- (void)addCommentRightBtn{
    
    
    self.commentLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    self.commentLb.font = FONT(13);
    self.commentLb.numberOfLines = 0;
    self.commentLb.textColor = [UIColor whiteColor];
    self.commentLb.textAlignment = NSTextAlignmentRight;
    UITapGestureRecognizer *bltap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(faviWork)];
    bltap.numberOfTapsRequired =1;
    bltap.numberOfTouchesRequired = 1;
    self.commentLb.userInteractionEnabled = YES;
    [self.commentLb addGestureRecognizer:bltap];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:self.commentLb];
    
    self.navigationItem.rightBarButtonItem =item;
    
}

- (void)gotoReport{
    if (HAS_LOGIN) {
        ReportTableController *vc = [[ReportTableController alloc]initControllerByAd:self.attachAd];
        PUSH_CONTROLLER(vc);
        
    }else{
        UserLoginController *vc = [[UserLoginController alloc]initController];
        PUSH_CONTROLLER(vc);
    }
}
- (void)addWithdrawnBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (DEVICE_IS_IPHONE_4 || DEVICE_IS_IPHONE_5) {
        btn.frame = CGRectMake(0, 0, 70, 22);
        btn.titleLabel.font = FONT(14);
    }else{
        btn.frame =CGRectMake(0, 0, 100, 30);
        btn.titleLabel.font = FONT(16);
    }
    
    [btn setTitle:@"Withdraw" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3.0;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1.0;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(withdrawAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)withdrawAction{
    NSLog(@"withdraw");
    [LZAlertControl showAlertWithTitle:@"Withdraw confirmation" withRemark:@"Are you sure?" withBlock:^(BOOL confirm) {
        if (confirm) {
            
            SHOW_LOADING_MESSAGE(nil, nil);
            [EtyAd withdrawnAdByAdid:self.attachAd.ad_id withFinish:^(id result, BOOL success) {
                
                if (success) {
                    
                    if (self.ReloadListDataBlock) {
                        self.ReloadListDataBlock();
                    }
                    POP_CONTROLLER;
                    
                }else{
                    [LZAlertView showMessage:result byStyle:Alert_Error];
                }
                DISMISS_LOADING;
                
            }];
            
        }
    }];
}

- (void)showInputView{
    if (HAS_LOGIN) {
        [_inputView beginTextEditing];
    }else{
        UserLoginController *vc =[[UserLoginController alloc]initController];
        PUSH_CONTROLLER(vc);
    }
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!isFirsted) {
        isFirsted = YES;
        [self configHeader];
        [self.table.legendHeader beginRefreshing];
    }
    if (!hasFinish) {
        __weak typeof(self)weakSelf =self;
        _inputView = LOAD_XIB_CLASS(SendCommentView);
        _inputView.frame = CGRectMake(0, UIScreenHeight, UIScreenWidth, 50);
        _inputView.sendMessageBlock=^(NSString *text){
            [weakSelf addCommentByText:text];
        };
        [self.view addSubview:_inputView];
        hasFinish = YES;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    _footerView.frame = CGRectMake(0, UIScreenHeight - 120, UIScreenWidth, 120);
}
- (void)addCommentByText:(NSString *)text{
    SHOW_LOADING_MESSAGE(@"sending", self.view);
    __weak typeof(self)weakSelf = self;
    [self.attachAd addNewCommentByContent:text withFinish:^(id result, BOOL success) {
        if (success) {
            [weakSelf.inputView clearInputText];
            if ([weakSelf.type isEqualToString:@"0"]) {
                
            }else{
                
                NSString *count = [[DBModel sharedInstance]queryCommentCount:self.attachAd byType:self.type];
                NSInteger c = [count integerValue]+1;
                self.attachAd.commentcount = [NSString stringWithFormat:@"%ld",(long)c];
                [[DBModel sharedInstance]updateAd:self.attachAd toType:self.type];
                
            }
            
            [_table.legendHeader beginRefreshing];

        }else{
            [LZAlertView showMessage:result byStyle:Alert_Error];
        }
        DISMISS_LOADING;
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
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

- (void)configHeader{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, UIScreenWidth, 0)];
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, UIScreenWidth - 20, 10)];
        _contentView.layer.cornerRadius = 3.0;
        _contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _contentView.layer.borderWidth = 1.0;

    }

    [_headerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [_headerView addSubview:_contentView];

    
    if (_contentView.subviews) {
        [_contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    
    NSMutableArray *urls = [NSMutableArray array];
    NSString *url1 = self.attachAd.pic1;
    NSString *url2 = self.attachAd.pic2;
    NSString *url3 = self.attachAd.pic3;
    NSString *url4 = self.attachAd.pic4;
    NSString *url5 = self.attachAd.pic5;
    if ([url1 isKindOfClass:[NSString class]] && ![url1 isEqualToString:@""]) {
        [urls addObject:url1];
    }
    if ([url2 isKindOfClass:[NSString class]] && ![url2 isEqualToString:@""]) {
        [urls addObject:url2];
    }
    if ([url3 isKindOfClass:[NSString class]] && ![url3 isEqualToString:@""]) {
        [urls addObject:url3];
    }
    if ([url4 isKindOfClass:[NSString class]] && ![url4 isEqualToString:@""]) {
        [urls addObject:url4];
    }
    if ([url5 isKindOfClass:[NSString class]] && ![url5 isEqualToString:@""]) {
        
        [urls addObject:url5];
    }
    NSInteger top = 0;
    self.contentView.clipsToBounds = YES;
    if (urls.count>0) {
        _imgLoad =[[ImageScrollView alloc]initWiew];
        if (_showWatch) {
            [_imgLoad showWatchTag];
        }
        _imgLoad.frame = CGRectMake(0, 0, self.contentView.width, 284);
        CGSize imgSize = CGSizeMake(self.contentView.width, 250);
        [_imgLoad loadDataWith:self.attachAd bySize:imgSize];
        _imgLoad.top = 0;
        [self.contentView addSubview:_imgLoad];
        top = CGRectGetMaxY(_imgLoad.frame)+10;
    }
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(10, top, self.contentView.width - 20, 0)];
    titleLb.font = FONT(20);
    titleLb.text = self.attachAd.title;
    titleLb.numberOfLines = 0;
    [titleLb sizeToFit];
    [self.contentView addSubview:titleLb];
    top = CGRectGetMaxY(titleLb.frame)+10;
    
    //todo 缺失一个expired字段的含义
    
    NSDate *inTime = [NSDate dateWithTimeIntervalSince1970:[self.attachAd.currt_time doubleValue]];
    NSDate *nowTime = [NSDate dateWithTimeIntervalSince1970:[self.attachAd.realease_time doubleValue]];
    
    NSString *timeago = [nowTime dateTimeAgoByDate:inTime];
    NSString *adid = self.attachAd.ad_id;
    NSString *time = [NSString stringWithFormat:@"%@ | #%@",timeago,adid];
    UILabel *timeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, top, self.contentView.width - 20, 21)];
    timeLb.font = FONT(16);
    timeLb.text = time;
    [self.contentView addSubview:timeLb];
    
    if (self.adStatus) {
        NSMutableString*ms = [[NSMutableString alloc]initWithString:time];
        [ms appendFormat:@"| %@",self.adStatus];
        
        UIColor *foregroundColor = RGB(234, 61, 62);
        NSDictionary*dic = @{NSForegroundColorAttributeName:foregroundColor};
        NSMutableAttributedString *atString = [[NSMutableAttributedString alloc]initWithString:ms];
        NSRange range = [ms rangeOfString:self.adStatus];
        [atString setAttributes:dic range:range];
        timeLb.attributedText = atString;
        
    }
    
    
    top = CGRectGetMaxY(timeLb.frame)+10;
    
    UILabel *contentlb = [[UILabel alloc]initWithFrame:CGRectMake(10, top, self.contentView.width - 20, 21)];
    contentlb.font = FONT(16);
    if ([self.attachAd.describe isKindOfClass:[NSString class]]) {
        contentlb.text = [self.attachAd.describe stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    contentlb.numberOfLines = 0;
    [contentlb sizeToFit];
    [self.contentView addSubview:contentlb];
    top = CGRectGetMaxY(contentlb.frame)+10;
    
    
    UILabel *reportListLb = [[UILabel alloc]initWithFrame:CGRectMake(10, top, self.contentView.width - 20, 30)];
    reportListLb.textColor = UI_NAVIBAR_COLOR;
    [self.contentView addSubview:reportListLb];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Report listing"]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    reportListLb.attributedText = content;
    top = CGRectGetMaxY(reportListLb.frame)+10;
    reportListLb.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoReport)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [reportListLb addGestureRecognizer:tap];
    
    
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, top, self.contentView.width - 20, 30)];
//    backView.backgroundColor = RGB(246, 246, 246);
//    [self.contentView addSubview:backView];
//    
//    UILabel *cont = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 30)];
//    cont.text = @"Contact:";
//    cont.font = [UIFont boldSystemFontOfSize:16];
//    [cont sizeToFit];
//    cont.height = 30.;
//    [backView addSubview:cont];
//    
//    UILabel *contactLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cont.frame)+5 , 0, backView.width - 10, 30)];
//    contactLb.font = FONT(16);
//    if (DEVICE_IS_IPHONE_4 || DEVICE_IS_IPHONE_5||DEVICE_IS_IPHONE_6) {
//        contactLb.font = FONT(11);
//    }
//    contactLb.text = self.attachAd.phone;
//    [backView addSubview:contactLb];
//    
//    
//    UIImage *messageImage = [UIImage imageNamed:@"AdMessage"];
//    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [messageBtn setImage:[UIImage imageNamed:@"AdMessage"] forState:UIControlStateNormal];
//    messageBtn.frame = CGRectMake(CGRectGetMaxX(backView.frame) - messageImage.size.width, contactLb.top, messageImage.size.width, messageImage.size.height);
//    messageBtn.center = CGPointMake(messageBtn.center.x, backView.center.y);
//    [messageBtn addTarget:self action:@selector(messageCall) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:messageBtn];
//    
//    
//    UIImage *callImage = [UIImage imageNamed:@"AdCallBtn"];
//    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [callBtn setImage:[UIImage imageNamed:@"AdCallBtn"] forState:UIControlStateNormal];
//    callBtn.frame = CGRectMake(CGRectGetMidX(messageBtn.frame)-30-callImage.size.width, messageBtn.top, callImage.size.width, callImage.size.height);
//    [callBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:callBtn];
//    
//    
//    top = CGRectGetMaxY(backView.frame)+10;
    

    _contentView.height = top;
    
    UILabel *noticeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, top+20, UIScreenWidth, 21)];
    noticeLb.text = @"Questions and answers";
    
    noticeLb.textColor = [UIColor blackColor];
    noticeLb.textAlignment = NSTextAlignmentLeft;
    noticeLb.font = [UIFont boldSystemFontOfSize:14];
    [_headerView addSubview:noticeLb];
    
    
    if ([AccountManager sharedInstance].currentUser && [self.attachAd.user_id isEqualToString:[AccountManager sharedInstance].currentUser.user_id]) {
        UILabel *askQLb = [[UILabel alloc]initWithFrame:CGRectMake(10, top + 20, UIScreenWidth-20, 21)];
        
        NSMutableAttributedString *aq = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Enter your response"]];
        NSRange aqRange = {0,[aq length]};
        [aq addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:aqRange];
        askQLb.attributedText = aq;
        askQLb.textAlignment = NSTextAlignmentRight;
        askQLb.attributedText  = aq;
        askQLb.font = [UIFont boldSystemFontOfSize:14];
        askQLb.textColor = UI_NAVIBAR_COLOR;
        [_headerView addSubview:askQLb];
        askQLb.userInteractionEnabled= YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showInputView)];
        tap2.numberOfTapsRequired = 1;
        tap2.numberOfTouchesRequired = 1;
        [askQLb addGestureRecognizer:tap2];


    }else{
        UILabel *askQLb = [[UILabel alloc]initWithFrame:CGRectMake(10, top + 20, UIScreenWidth-20, 21)];
        
        NSMutableAttributedString *aq = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Ask a question"]];
        NSRange aqRange = {0,[aq length]};
        [aq addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:aqRange];
        askQLb.attributedText = aq;
        askQLb.textAlignment = NSTextAlignmentRight;
        askQLb.attributedText  = aq;
        askQLb.font = [UIFont boldSystemFontOfSize:14];
        askQLb.textColor = UI_NAVIBAR_COLOR;
        [_headerView addSubview:askQLb];
        askQLb.userInteractionEnabled= YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showInputView)];
        tap2.numberOfTapsRequired = 1;
        tap2.numberOfTouchesRequired = 1;
        [askQLb addGestureRecognizer:tap2];

    }
    

    top = CGRectGetMaxY(noticeLb.frame);
    _headerView.height = top;
    
    self.table.tableHeaderView = _headerView;

}



- (void)messageCall{
    NSString *sms = [NSString stringWithFormat:@"sms://%@",self.attachAd.phone];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:sms]];

}
- (void)call{
    NSString *sms = [NSString stringWithFormat:@"tel://%@",self.attachAd.phone];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:sms]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)faviWork{
    if (!self.showWatch) {
        if (HAS_LOGIN) {
            SHOW_LOADING_MESSAGE(@"confirm", self.view);
            
            [EtyAd addToMyWatchByAdId:self.attachAd.ad_id withFinish:^(id result, BOOL success) {
                if (success) {
                    self.showWatch = YES;

                    [_imgLoad showWatchTag];
                    if (self.ReloadListDataBlock) {
                        self.ReloadListDataBlock();
                    }
                    
                    NSMutableAttributedString *aq2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Remove from favourites"]];
                    NSRange aqRange2 = {0,[aq2 length]};
                    [aq2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:aqRange2];
                    self.commentLb.attributedText = aq2;
                }else{
                    [LZAlertView showMessage:result byStyle:Alert_Error];
                }
                DISMISS_LOADING;
                
            }];
            
        }else{
            UserLoginController *vc = [[UserLoginController alloc]initController];
            PUSH_CONTROLLER(vc);
        }
    }else{
        [LZAlertControl showAlertWithTitle:@"Remove your favourites" withRemark:@"Are you sure?" withBlock:^(BOOL confirm) {
            if (confirm) {
                
                SHOW_LOADING_MESSAGE(@"confirm", self.view);
                [EtyAd deleteMyWatchByAdId:self.attachAd.ad_id withFinish:^(id result, BOOL success) {
                    
                    if (success) {
                        self.showWatch = NO;
                        [_imgLoad hideWatchTag];
                        if (self.ReloadListDataBlock) {
                            self.ReloadListDataBlock();
                        }
                        NSMutableAttributedString *aq2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Add to favourites"]];
                        NSRange aqRange2 = {0,[aq2 length]};
                        [aq2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:aqRange2];
                        self.commentLb.attributedText = aq2;

                    }else{
                        [LZAlertView showMessage:result byStyle:Alert_Error];
                    }
                    DISMISS_LOADING;
                    
                }];
                
            }
        }];

    }

}


- (void)handleTopButtonClick{
    if (self.attachFunc == NORMAL_FUNCTION) {
        
        [self faviWork];
    }else if (self.attachFunc == FAVOURITES_FUNCTION){
        [self faviWork];


    }else if (self.attachFunc == MY_CURRENT_FUNCTION){
        [self adEditAction];
    }else if (self.attachFunc == MY_EXPIRED_FUNCTION){
        [LZAlertControl showAlertWithTitle:@"Your listing will be relisted" withRemark:@"Are you sure?" withBlock:^(BOOL confirm) {
            if (confirm) {
                
                SHOW_LOADING_MESSAGE(nil, nil);
                
                
                [EtyAd relistAdByAd:self.attachAd withFinish:^(id result, BOOL success) {
                    if (success) {
                        
                        if (self.ReloadListDataBlock) {
                            self.ReloadListDataBlock();
                        }
                        [LZAlertView showMessage:@"Relisting successfully" byStyle:Alert_Success];
                        POP_CONTROLLER;
                        
                    }else{
                        [LZAlertView showMessage:result byStyle:Alert_Error];
                    }
                    DISMISS_LOADING;
                    
                }];
                
                
            }
        }];

    }else if (self.attachFunc == MY_WITHDRAWN_FUNCTION){
        [LZAlertControl showAlertWithTitle:@"Your listing will be relisted" withRemark:@"Are you sure?" withBlock:^(BOOL confirm) {
            if (confirm) {
                
                SHOW_LOADING_MESSAGE(nil, nil);
                
                
                [EtyAd relistAdByAd:self.attachAd withFinish:^(id result, BOOL success) {
                    if (success) {
                        
                        if (self.ReloadListDataBlock) {
                            self.ReloadListDataBlock();
                        }
                        [LZAlertView showMessage:@"Relisting successfully" byStyle:Alert_Success];
                        POP_CONTROLLER;
                        
                    }else{
                        [LZAlertView showMessage:result byStyle:Alert_Error];
                    }
                    DISMISS_LOADING;
                    
                }];
                
                
            }
        }];

    }
}

- (void)adEditAction{
    NSMutableArray *urls = [NSMutableArray array];
    NSString*pic1 = self.attachAd.pic1;
    NSString*pic2 = self.attachAd.pic2;
    NSString*pic3 = self.attachAd.pic3;
    NSString*pic4 = self.attachAd.pic4;
    NSString*pic5 = self.attachAd.pic5;
    if ([PublicFunction checkStringIsValid:pic1]) {
        [urls addObject:pic1];
    }
    if ([PublicFunction checkStringIsValid:pic2]){
        [urls addObject:pic2];
    }
    if ([PublicFunction checkStringIsValid:pic3]){
        [urls addObject:pic3];
    }
    if ([PublicFunction checkStringIsValid:pic4]){
        [urls addObject:pic4];
    }
    if ([PublicFunction checkStringIsValid:pic5]){
        [urls addObject:pic5];
    }
    NSMutableArray*photos = [NSMutableArray array];
    NSInteger allCount = urls.count;
    __block NSInteger completed = 0;
    
    if (allCount>0) {
        SHOW_LOADING_MESSAGE(@"loading", self.view);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [urls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSString *url = obj;
                
                NSURLResponse *response;
                NSError *error;
                
                NSData *imgData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] returningResponse:&response error:&error];
                
                if (imgData) {
                    UIImage *img = [UIImage imageWithData:imgData];
                    [photos addObject:img];
                }
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                DISMISS_LOADING;
                if (photos.count == urls.count) {
                    ItemNewAdController *vc = [[ItemNewAdController alloc]initControllerWithEditMode:self.attachAd withPhotos:photos];
                    vc.reloadDataBlock=^(EtyAd*ad){
                        self.attachAd = ad;
//                        [self adjustUIByEdit];
                        [self configHeader];
                        _footerView.attachAd  = ad;
                        
                    };
                    vc.reloadUIBlock=^{
                        [self configHeader];
                        [_footerView reloadFooterData];
                        if (self.ReloadListDataBlock) {
                            self.ReloadListDataBlock();
                        }
                    };
                    
                    PUSH_CONTROLLER(vc);
                    
                }else{
                    [LZAlertView showMessage:@"Get data error" byStyle:Alert_Error];
                }
            });
            
            
        });
        
        
    }else{
        ItemNewAdController *vc = [[ItemNewAdController alloc]initControllerWithEditMode:self.attachAd withPhotos:photos];
        vc.reloadDataBlock=^(EtyAd*ad){
            self.attachAd = ad;
            [self configHeader];
        };
        vc.reloadUIBlock=^{
            [self configHeader];
            if (self.ReloadListDataBlock) {
                self.ReloadListDataBlock();
            }
        };
        PUSH_CONTROLLER(vc);
    }

}

- (void)loadFirstData{
    pageIndex = 1;
    [self getData];
    
}
- (void)loadNextData{
    pageIndex +=1;
    
    [self getData];
}

- (void)getData{
    
    [self.attachAd getAdCommentByIndex:pageIndex withFinish:^(id result, BOOL success) {
        if (success) {
            [self handleData:result];
        }else{
            [self.table.legendFooter endRefreshing];
            [self.table.legendHeader endRefreshing];
        }
        
    }];
}
- (void)handleData:(NSArray *)datas{
    if (datas.count < 10) {
        [self.table.legendHeader endRefreshing];
        [self.table.legendFooter noticeNoMoreData];
    }else{
        [self.table.legendHeader endRefreshing];
        [self.table.legendFooter endRefreshing];
    }
    if (pageIndex == 1) {
        [_modelDatas removeAllObjects];
    }
    if ([datas isKindOfClass:[NSArray class]] && datas.count>0) {
        [datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CommentCellModel *model = [[CommentCellModel alloc]init];
            //            model.attachComment = obj;
            [model configEtyCommentModel:obj withSellUserId:self.attachAd.user_id];
//            [_modelDatas insertObject:model atIndex:0];
            [_modelDatas addObject:model];
        }];
        [_table reloadData];
        
        
    }
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
