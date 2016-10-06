//
//  ItemAdDetailController.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/20.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "ItemAdDetailController.h"
#import "ImageScrollView.h"
#import "UserLoginController.h"
#import "AdCommentController.h"
#import "ReportTableController.h"
#import "ItemNewAdController.h"

@interface ItemAdDetailController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scView;
@property (strong, nonatomic) IBOutlet UIButton *removeBtn;
@property (nonatomic,strong)IBOutlet UIView *contentView;
@property (nonatomic,strong)EtyAd *attachAd;
@property (nonatomic,assign)BOOL showWatch;
@property (nonatomic,assign)BOOL edit;
@property (nonatomic,assign)BOOL relist;
@property (nonatomic,strong)ImageScrollView *imgLoad;
@property (nonatomic,strong)NSString *adStatus;
@property (strong, nonatomic) IBOutlet UIButton *comBtn;
@end

@implementation ItemAdDetailController
{
    BOOL loaded;
}
- (id)initWithAd:(EtyAd *)ad{
    return [[ItemAdDetailController alloc]initWithAd:ad showWatch:NO];
}

- (id)initWithAd:(EtyAd *)ad showWatch:(BOOL)show{
    self = [super initWithTitle:@"Details"];
    if (self) {
        self.showWatch = show;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.attachAd = ad;
//        [self adjustUI];
        
        [self addCommentRightBtn];
        
    }
    return self;

}

- (id)initWithAd:(EtyAd *)ad withEdit:(BOOL)edit{
    self = [super initWithTitle:@"Details"];
    if (self) {
        self.edit = edit;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.attachAd = ad;
//        [self adjustUIByEdit];
    }
    return self;

}

- (id)initWithAd:(EtyAd *)ad withRelist:(BOOL)relist withStatus:(NSString *)status{
    self = [super initWithTitle:@"Details"];
    if (self) {
        self.adStatus = status;
        self.relist = relist;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.attachAd = ad;
//        [self adjustUIByRelist];
    }
    return self;

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (loaded) {
        return;
    }
    loaded = YES;
    if (self.edit) {
        [self adjustUIByEdit];
    }else if (self.relist){
        [self adjustUIByRelist];
    }else{
        [self adjustUI];
    }
}

- (void)adjustUIByRelist{
    self.removeBtn.backgroundColor =UI_NAVIBAR_COLOR;
    [self.removeBtn setImage:[UIImage imageNamed:@"Relist"] forState:UIControlStateNormal];
    [self.removeBtn setTitle:@"Relist" forState:UIControlStateNormal];
    self.removeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//    if (!self.isWithdrawn && !self.relist) {
//        [self addCommentBtnBottom];
//        
//    }
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setTitle:@"Comments" forState:UIControlStateNormal];
    commentBtn.frame = CGRectMake(CGRectGetMaxX(self.removeBtn.frame)+24, self.removeBtn.top, self.removeBtn.width/2.-12, self.removeBtn.height);
    commentBtn.backgroundColor = UI_NAVIBAR_COLOR;
    commentBtn.layer.cornerRadius = 3.0;
    [commentBtn addTarget:self action:@selector(gotoComments) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-12);
        make.width.equalTo(self.removeBtn);
        make.bottom.equalTo(self.view).offset(-10);
        make.height.equalTo(self.removeBtn);
    }];


    [self adjust];

}
- (void)adjustUIByEdit{
    self.removeBtn.backgroundColor =RGB(152, 204, 69);
    [self.removeBtn setImage:[UIImage imageNamed:@"Edit"] forState:UIControlStateNormal];
    [self.removeBtn setTitle:@"Edit" forState:UIControlStateNormal];
    self.removeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//    self.removeBtn

    
    [self addCommentBtnBottom];

    [self addWithdrawnBtn];
    [self adjust];
}

- (void)addCommentRightBtn{
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setTitle:@"Report" forState:UIControlStateNormal];
//    commentBtn.frame = CGRectMake(0, 0, 90, 44);
    
    if (DEVICE_IS_IPHONE_4 || DEVICE_IS_IPHONE_5) {
        commentBtn.frame = CGRectMake(0, 0, 70, 22);
        commentBtn.titleLabel.font = FONT(14);
    }else{
        commentBtn.frame =CGRectMake(0, 0, 100, 30);
        commentBtn.titleLabel.font = FONT(16);
    }

    commentBtn.layer.cornerRadius = 3.0;
    commentBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    commentBtn.layer.borderWidth = 1.0;

    [commentBtn addTarget:self action:@selector(gotoReport) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:commentBtn];
    
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

- (void)addCommentBtnBottom{
    
    [_removeBtn setHidden:YES];
    [_comBtn setHidden:YES];
    UIButton *editBBB = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBBB setImage:[UIImage imageNamed:@"Edit"] forState:UIControlStateNormal];
    [editBBB setTitle:@"Edit" forState:UIControlStateNormal];
    editBBB.backgroundColor = RGB(152, 204, 69);
    editBBB.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    editBBB.layer.cornerRadius = 3.0;
    [editBBB addTarget:self action:@selector(removeAction:) forControlEvents:UIControlEventTouchUpInside];
    editBBB.frame = CGRectMake(_removeBtn.left, _removeBtn.top, (self.view.width/2 -24), _removeBtn.height);
    [self.view addSubview:editBBB];
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_removeBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_removeBtn attribute:NSLayoutAttributeTop multiplier:1 constant:-80]];
//    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setTitle:@"Comments" forState:UIControlStateNormal];
    commentBtn.frame = CGRectMake(CGRectGetMaxX(editBBB.frame)+24, self.removeBtn.top, self.removeBtn.width/2.-12, self.removeBtn.height);
    commentBtn.backgroundColor = UI_NAVIBAR_COLOR;
    commentBtn.layer.cornerRadius = 3.0;
    [commentBtn addTarget:self action:@selector(gotoComments) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-12);
        make.width.equalTo(editBBB);
        make.bottom.equalTo(self.view).offset(-10);
        make.height.equalTo(editBBB);
    }];

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

- (void)adjustUI{
    
    if (self.showWatch) {
        
        self.removeBtn.backgroundColor =RGB(152, 204, 69);
        [self.removeBtn setImage:[UIImage imageNamed:@"Eye"] forState:UIControlStateNormal];
        self.removeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        [self.removeBtn setTitle:@"Remove from favourites" forState:UIControlStateNormal];
        self.removeBtn.titleLabel.numberOfLines = 0;
        self.removeBtn.titleLabel.font = FONT(13);
        self.removeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);

        if (DEVICE_IS_IPHONE_4 || DEVICE_IS_IPHONE_5 || DEVICE_IS_IPHONE_6) {

//            self.removeBtn.titleLabel.font = FONT(10);
        }
    }else{
        self.removeBtn.backgroundColor =RGB(152, 204, 69);
        [self.removeBtn setImage:[UIImage imageNamed:@"Eye"] forState:UIControlStateNormal];
        self.removeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        [self.removeBtn setTitle:@"Add to favourites" forState:UIControlStateNormal];
        self.removeBtn.titleLabel.numberOfLines = 0;
        self.removeBtn.titleLabel.font = FONT(13);
        self.removeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);


    }
    
//    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:self.removeBtn attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottomMargin multiplier:1.0f constant:0.0f];
//    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:self.removeBtn attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
//
//    NSLayoutConstraint* widthConstraint = [NSLayoutConstraint constraintWithItem:self.removeBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:.5f constant:-20.f];
//    
//    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:self.removeBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.removeBtn attribute:NSLayoutAttributeWidth multiplier:0.3f constant:-10.f];
//    [self.view addConstraints:@[bottomConstraint,leftConstraint,widthConstraint,heightConstraint]];
    
    
//    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [commentBtn setTitle:@"Comments" forState:UIControlStateNormal];
//    commentBtn.frame = CGRectMake(CGRectGetMaxX(self.removeBtn.frame)+24, self.removeBtn.top, self.removeBtn.width/2.-12, self.removeBtn.height);
    self.comBtn.backgroundColor = UI_NAVIBAR_COLOR;
    self.comBtn.layer.cornerRadius = 3.0;
    [self.comBtn addTarget:self action:@selector(gotoComments) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:commentBtn];

//    NSLayoutConstraint* cbottomConstraint = [NSLayoutConstraint constraintWithItem:commentBtn attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottomMargin multiplier:1.0f constant:0.0f];
//    NSLayoutConstraint* crightConstraint = [NSLayoutConstraint constraintWithItem:commentBtn attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.f];
//    
//    NSLayoutConstraint* cwidthConstraint = [NSLayoutConstraint constraintWithItem:commentBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5f constant:-20.f];
//    
//    NSLayoutConstraint* cheightConstraint = [NSLayoutConstraint constraintWithItem:commentBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.removeBtn attribute:NSLayoutAttributeHeight multiplier:1.f constant:0.f];
//    [self.view addConstraints:@[cbottomConstraint,crightConstraint,cwidthConstraint,cheightConstraint]];
//
    
    
    [self adjust];
}

- (void)adjust{
    
    [self.scView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *subView = obj;
        [subView removeFromSuperview];
    }];
    self.contentView.layer.cornerRadius = 5.0;
    self.contentView.layer.borderColor = RGB(196, 196, 196).CGColor;
    self.contentView.layer.borderWidth = 1.0;
    CGFloat top =10;
    
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
    self.contentView.clipsToBounds = YES;
    if (urls.count>0) {
        _imgLoad =[[ImageScrollView alloc]initWiew];
        if (_showWatch) {
            [_imgLoad showWatchTag];
        }
        _imgLoad.frame = CGRectMake(0, 0, self.contentView.width, 284);
        CGSize imgSize = CGSizeMake(self.scView.width, self.scView.width*400/611);
        [_imgLoad loadDataWith:self.attachAd bySize:imgSize];
        _imgLoad.top = 0;
        [self.scView addSubview:_imgLoad];
        top = CGRectGetMaxY(_imgLoad.frame)+10;
    }
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(10, top, self.scView.width - 20, 0)];
    titleLb.font = FONT(20);
    titleLb.text = self.attachAd.title;
    titleLb.numberOfLines = 0;
    [titleLb sizeToFit];
    [self.scView addSubview:titleLb];
    top = CGRectGetMaxY(titleLb.frame)+10;
    
    //todo 缺失一个expired字段的含义
    
    NSDate *inTime = [NSDate dateWithTimeIntervalSince1970:[self.attachAd.currt_time doubleValue]];
    NSDate *nowTime = [NSDate dateWithTimeIntervalSince1970:[self.attachAd.realease_time doubleValue]];
    
    NSString *timeago = [nowTime dateTimeAgoByDate:inTime];
    NSString *adid = self.attachAd.ad_id;
    NSString *time = [NSString stringWithFormat:@"%@ | #%@",timeago,adid];
    UILabel *timeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, top, self.scView.width - 20, 21)];
    timeLb.font = FONT(16);
    timeLb.text = time;
    [self.scView addSubview:timeLb];

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
    [self.scView addSubview:contentlb];
    top = CGRectGetMaxY(contentlb.frame)+10;
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, top, self.contentView.width - 20, 30)];
    backView.backgroundColor = RGB(246, 246, 246);
    [self.scView addSubview:backView];
    
    UILabel *cont = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 30)];
    cont.text = @"Contact:";
    cont.font = [UIFont boldSystemFontOfSize:16];
    [cont sizeToFit];
    cont.height = 30.;
    [backView addSubview:cont];
    
    UILabel *contactLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cont.frame)+5 , 0, backView.width - 10, 30)];
    contactLb.font = FONT(16);
    if (DEVICE_IS_IPHONE_4 || DEVICE_IS_IPHONE_5||DEVICE_IS_IPHONE_6) {
        contactLb.font = FONT(11);
    }
    contactLb.text = self.attachAd.phone;
    [backView addSubview:contactLb];

    
    UIImage *messageImage = [UIImage imageNamed:@"AdMessage"];
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setImage:[UIImage imageNamed:@"AdMessage"] forState:UIControlStateNormal];
    messageBtn.frame = CGRectMake(CGRectGetMaxX(backView.frame) - messageImage.size.width, contactLb.top, messageImage.size.width, messageImage.size.height);
    messageBtn.center = CGPointMake(messageBtn.center.x, backView.center.y);
    [messageBtn addTarget:self action:@selector(messageCall) forControlEvents:UIControlEventTouchUpInside];
    [self.scView addSubview:messageBtn];
    
    
    UIImage *callImage = [UIImage imageNamed:@"AdCallBtn"];
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn setImage:[UIImage imageNamed:@"AdCallBtn"] forState:UIControlStateNormal];
    callBtn.frame = CGRectMake(CGRectGetMidX(messageBtn.frame)-30-callImage.size.width, messageBtn.top, callImage.size.width, callImage.size.height);
    [callBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [self.scView addSubview:callBtn];
    
    
    top = CGRectGetMaxY(backView.frame)+10;
    
    self.scView.contentSize = CGSizeMake(self.scView.contentSize.width, top);

}

- (void)call{
    CALL(self.attachAd.phone);
    
}

- (void)messageCall{
    NSString *sms = [NSString stringWithFormat:@"sms://%@",self.attachAd.phone];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:sms]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [PublicFunction setButtonBorder:self.removeBtn];
    
}

- (void)gotoComments{
    AdCommentController *vc = [[AdCommentController alloc]initWithEty:self.attachAd];

    vc.type = self.type;
    vc.reloadTableData=^{
        if (self.ReloadListDataBlock) {
            self.ReloadListDataBlock();
        }
    };
    PUSH_CONTROLLER(vc);
}


- (void)setWatchStatus{
    [self.removeBtn setTitle:@"Remove from favourites" forState:UIControlStateNormal];
    [_imgLoad showWatchTag];

}
- (void)setUnWatchStatus{
    [self.removeBtn setTitle:@"Add to favourites" forState:UIControlStateNormal];
    [_imgLoad hideWatchTag];
}

- (IBAction)removeAction:(id)sender {
    if (_edit) {
        
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
                            [self adjustUIByEdit];
                            
                        };
                        vc.reloadUIBlock=^{
                            [self adjustUIByEdit];
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
                [self adjustUIByEdit];

            };
            vc.reloadUIBlock=^{
                [self adjustUIByEdit];
                if (self.ReloadListDataBlock) {
                    self.ReloadListDataBlock();
                }
            };
            PUSH_CONTROLLER(vc);
        }
        
        
    }else if(self.relist){
        
        
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

        
    }else{
        if(self.showWatch) {
            
            [LZAlertControl showAlertWithTitle:@"Remove your favourites" withRemark:@"Are you sure?" withBlock:^(BOOL confirm) {
                if (confirm) {
                    
                    SHOW_LOADING_MESSAGE(@"confirm", self.view);
                    [EtyAd deleteMyWatchByAdId:self.attachAd.ad_id withFinish:^(id result, BOOL success) {
                        
                        if (success) {
                            self.showWatch = NO;
                            [self setUnWatchStatus];
                            if (self.ReloadListDataBlock) {
                                self.ReloadListDataBlock();
                            }
                        }else{
                            [LZAlertView showMessage:result byStyle:Alert_Error];
                        }
                        DISMISS_LOADING;
                        
                    }];
                    
                }
            }];
            
        }else{
            
            if (HAS_LOGIN) {
                SHOW_LOADING_MESSAGE(@"confirm", self.view);
                
                [EtyAd addToMyWatchByAdId:self.attachAd.ad_id withFinish:^(id result, BOOL success) {
                    if (success) {
                        self.showWatch = YES;
                        [self setWatchStatus];
                        if (self.ReloadListDataBlock) {
                            self.ReloadListDataBlock();
                        }
                    }else{
                        [LZAlertView showMessage:result byStyle:Alert_Error];
                    }
                    DISMISS_LOADING;
                    
                }];
                
            }else{
                UserLoginController *vc = [[UserLoginController alloc]initController];
                PUSH_CONTROLLER(vc);
            }
            
            
            
        }
        

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
