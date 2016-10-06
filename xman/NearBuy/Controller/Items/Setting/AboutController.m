//
//  AboutController.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/20.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "AboutController.h"
#import "EtyAppInfo.h"
@interface AboutController ()
@property (nonatomic,assign)AboutStyle atyle;
@property (strong, nonatomic) IBOutlet UIWebView *webV;
@end

@implementation AboutController
{
    
}

- (id)initWithTitle:(NSString *)title withType:(AboutStyle)style{
    _atyle = style;
    self =[super initWithTitle:title];
    if (self) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    return self;

}

- (void)getData{
    BOOL hasGet = [EtyAppInfo sharedInstance].hasLoaded;
    if (!hasGet) {
        SHOW_LOADING_MESSAGE(@"loading", [UIApplication sharedApplication].keyWindow);
        [EtyAppInfo getAppInfoCompleted:^(id result, BOOL success) {
            
            if (success) {
                [self setData];
            }
            DISMISS_LOADING;
            
        }];
        
    }else{
        [self setData];
    }

}

- (void)setData{
    switch (_atyle) {
        case AboutPage:
            [_webV loadHTMLString:[EtyAppInfo sharedInstance].about baseURL:nil];
            break;
        case TermPage:
            [_webV loadHTMLString:[EtyAppInfo sharedInstance].terms baseURL:nil];
            break;
        case PrivacyPage:
            [_webV loadHTMLString:[EtyAppInfo sharedInstance].privacy baseURL:nil];
            break;
        default:
            break;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
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
