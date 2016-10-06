//
//  BaseController.m
//  LNGaosutong
//
//  Created by 罗 建镇 on 15/3/4.
//  Copyright (c) 2015年 URoad. All rights reserved.
//

#import "BaseController.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"

#import "GAITracker.h"


#define kRightButtonWidth_Height 44.
@interface BaseController ()<UIGestureRecognizerDelegate>
@property (nonatomic,retain)UILabel *titleLb;
@property (nonatomic,strong)UIButton *naviRightBtn;
@property (nonatomic,strong)UIButton *naviLeftBtn;
@property (nonatomic,strong)UIView *hideBar;

@end

@implementation BaseController
{
    BOOL base_register_keyboard;
}
- (id)initWithTitle:(NSString *)title{
    Class c=[self class];
    NSString *name=[NSString stringWithFormat:@"%@",c];
    self = [super initWithNibName:name bundle:nil];
    if (self) {
        _titleString = title;
        self.title = title;

        //        CGSize textSize = [title sizeWithFont:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(self.navigationItem.titleView.bounds.size.width, 44.)];
//        self.titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, textSize.width, 44.)];
//        self.titleLb.backgroundColor = [UIColor clearColor];
//        self.titleLb.font = [UIFont boldSystemFontOfSize:20];
//        self.titleLb.textAlignment = NSTextAlignmentCenter;
//        self.titleLb.textColor = [UIColor whiteColor];
//        self.titleLb.text = title;
//        
//        self.navigationItem.titleView = self.titleLb;
        
        if (SYSTEM_VERSION_LATER_THAN_7_0) {
            
            UIView *statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
            statusBarView.backgroundColor = RGB(0, 197, 70);
            [self.view addSubview:statusBarView];

        }
        
    }
    return self;
}
- (void)registerKeyboardNotification{
    base_register_keyboard= YES;
    _hideBar = [[UIView alloc]initWithFrame:CGRectMake(UIScreenWidth-50, UIScreenHeight, 50, 44)];
    _hideBar.backgroundColor = UI_INPUT_LAYER_COLOR;
    UIButton *hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hideBtn setTitle:@"Hide" forState:UIControlStateNormal];
    hideBtn.titleLabel.textColor = UI_NAVIBAR_COLOR;
    hideBtn.frame = _hideBar.bounds;
    [hideBtn addTarget:self action:@selector(finishEdit) forControlEvents:UIControlEventTouchUpInside];
    [_hideBar addSubview:hideBtn];
    [self.view addSubview:_hideBar];
    
}

- (void)setTitleString:(NSString *)titleString
{
    self.title  =titleString;
    _titleString = titleString;
//    CGSize textSize = [titleString sizeWithFont:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(self.navigationItem.titleView.bounds.size.width, 44.)];
//    self.titleLb.frame = CGRectMake(0, 0, textSize.width, 44.);
//    self.titleLb.text = titleString;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (base_register_keyboard) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }

}
- (void)viewWillDisappear:(BOOL)animated{
    if (base_register_keyboard) {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}
- (void)finishEdit{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
        self.hideBar.top =  UIScreenHeight - keyboardHeight - 44;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notice{
    [UIView animateWithDuration:0.3 animations:^{
        self.hideBar.top = UIScreenHeight;
    } completion:^(BOOL finished) {
    }];
}

- (void)setNaviRightBtnImg:(UIImage *)naviRightBtnImg
{
    _naviRightBtnImg = naviRightBtnImg;
    if (!_naviRightBtn) {
        UIButton *naviRight = [UIButton buttonWithType:UIButtonTypeCustom];
        [naviRight setImage:_naviRightBtnImg forState:UIControlStateNormal];
        naviRight.frame = CGRectMake(0, 0, kRightButtonWidth_Height, kRightButtonWidth_Height);
        [naviRight addTarget:self action:@selector(naviRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.naviRightBtn = naviRight;
        UIBarButtonItem *rigthItem = [[UIBarButtonItem alloc]initWithCustomView:naviRight];
        
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width=(SYSTEM_VERSION_LATER_THAN_7_0)?-10:5;
        
        NSArray *rightBtns = @[fixedSpace,rigthItem];
        self.navigationItem.rightBarButtonItems = rightBtns;
    }else{
        [self.naviRightBtn setImage:naviRightBtnImg forState:UIControlStateNormal];
    }
}

- (void)setTitleView:(UIView *)titleView{
    self.navigationItem.titleView = titleView;
}

- (void)setNaviLeftBtnImg:(UIImage *)naviLeftBtnImg
{
    if (!_naviLeftBtn) {
        UIButton *naviRight = [UIButton buttonWithType:UIButtonTypeCustom];
        [naviRight setImage:naviLeftBtnImg forState:UIControlStateNormal];
        naviRight.frame = CGRectMake(0, 0, kRightButtonWidth_Height, kRightButtonWidth_Height);
        [naviRight addTarget:self action:@selector(naviLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rigthItem = [[UIBarButtonItem alloc]initWithCustomView:naviRight];
        self.naviLeftBtn = naviRight;
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width=(SYSTEM_VERSION_LATER_THAN_7_0)?-10:5;
        
        NSArray *rightBtns = @[fixedSpace,rigthItem];
        self.navigationItem.leftBarButtonItems = rightBtns;

    }else{
        [self.naviLeftBtn setImage:naviLeftBtnImg forState:UIControlStateNormal];
    }
}

- (void)naviLeftButtonClick{
    
}
- (void)naviRightButtonClick{
    
}

- (void)naviBackAction{
//    DISMISS_LOADING;
    POP_CONTROLLER;
}

- (void)startAnimation
{
}
- (void)stopAnimation
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    if (![self isKindOfClass:[MainController class]]) {
//        UIImage *leftButtonImg = [UIImage imageNamed:@"Navi_Back"];
//        UIImage *leftButtonNormal = [leftButtonImg stretchableImageWithLeftCapWidth:5 topCapHeight:10];
//        
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backBtn setImage:leftButtonNormal forState:UIControlStateNormal];
//        backBtn.frame = CGRectMake(0,0,44,40);
//        [backBtn addTarget:self action:@selector(naviBackAction) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *naviBack = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//        
//        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        fixedSpace.width=(SYSTEM_VERSION_LATER_THAN_7_0)?-16:-5;
//        
//        NSArray *leftBtns = @[fixedSpace,naviBack];
//        
//        
//        self.navigationItem.leftBarButtonItems = leftBtns;
//
//    }

    
    

    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /********** Using the default tracker **********/
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    /**********Manual screen recording**********/
    //  [tracker set:kGAIScreenName value:@"Stopwatch"];
    //  [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    /**********Setting and Sending Data**********/
    //    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"appview", kGAIHitType, @"Stopwatch1", kGAIScreenName, nil];
    //    [tracker send:params];
    
    
    /* MapBuilder class simplifies the process of building hits */
    Class c=[self class];
    NSString *name=[NSString stringWithFormat:@"%@",c];

    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
//    [tracker send:[[[GAIDictionaryBuilder createScreenView] set:name forKey:kGAIScreenName] build]];
    
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker set:kGAIScreenName value:name];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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
