//
//  BaseNavigationController.m
//  LNGaosutong
//
//  Created by 罗 建镇 on 15/3/5.
//  Copyright (c) 2015年 URoad. All rights reserved.
//

#import "BaseNavigationController.h"

#import "MainController.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

+ (BaseNavigationController *)shareNaviController
{
    static BaseNavigationController *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        obj = [[BaseNavigationController alloc]initWithRootViewController:[MainController sharedInstance]];
    });
    return obj;
}

- (void)popBackControllerByBackIndex:(NSInteger)index
{
    NSArray *vcs = self.viewControllers;
    NSInteger count = vcs.count;
    if (index>count) {
        return;
    }
    
    NSInteger vcIndex = count - index;
    [self popToViewController:vcs[vcIndex] animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __block BaseNavigationController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }

}
-(UIBarButtonItem*) createBackButton{
    return [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NaviBack"] style:UIBarButtonItemStylePlain target:self action:@selector(popself)];
}

- (void)popself{
    [self popViewControllerAnimated:YES];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    
    [super pushViewController:viewController animated:animated];
    if (viewController !=[Base shareMain]) {
        
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
        
    }
}



#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if ([self.viewControllers indexOfObject:viewController] == 0) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
        else {
            self.interactivePopGestureRecognizer.enabled = YES;
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
