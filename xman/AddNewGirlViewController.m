//
//  AddNewGirlViewController.m
//  xman
//
//  Created by Liu Ming on 27/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "AddNewGirlViewController.h"
#import "GirlPageContentViewController.h"
#import "GirlPageImageLUIViewController.h"
#import "GirlPageSummaryViewController.h"


@interface AddNewGirlViewController ()

@property (strong,nonatomic) NSMutableArray* pageViewControllers;
@property int curPageIndex;

@end

@implementation AddNewGirlViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.title = @"";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    
    // Do any additional setup after loading the view.
    if(self.girl == nil){
        self.status = GIRGPAGE_STATUS_NORMAL;
//        self.curPageIndex = 0;
        self.curPageIndex = 11;
        self.girl = [[Member alloc]init];
    }else{
        self.curPageIndex = MAX_PAGES_GIRLS-1;
        self.status = GIRLPAGE_STATUS_EDIT;
    }
    
    [self gotoPage:self.curPageIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIViewController*)getViewController: (int) pageIndex{
    if(pageIndex < MAX_PAGES_GIRLS-2){
        GirlPageContentViewController *obj = [self.pageViewControllers objectAtIndex:pageIndex];
        if(obj == nil){
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            if(pageIndex<MAX_PAGES_GIRLS-4){
                obj = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GirlPageContentViewController"];
            }else if (pageIndex == MAX_PAGES_GIRLS-4){
                obj = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GirlPageServicesUIViewController"];
            }else{
                obj = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GirlPageMapUIViewController"];
            }
            
            obj.pageIndex = pageIndex;
            obj.pageDelegate = self;
            obj.member = self.girl;
            
            [self.pageViewControllers setObject:obj atIndexedSubscript:pageIndex];
        }
        return obj;
    }
    else if (pageIndex == MAX_PAGES_GIRLS-2){
        GirlPageImageLUIViewController *obj = [self.pageViewControllers objectAtIndex:pageIndex];
        if(obj == nil){
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            obj = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GirlPageImageLUIViewController"];
            obj.pageIndex = pageIndex;
            obj.pageDelegate = self;
            obj.member = self.girl;
            
            [self.pageViewControllers setObject:obj atIndexedSubscript:pageIndex];
        }
        return obj;
    
    }else if (pageIndex == MAX_PAGES_GIRLS-1){
        GirlPageSummaryViewController *obj = [self.pageViewControllers objectAtIndex:pageIndex];
        if(obj == nil){
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            obj = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GirlPageSummaryViewController"];
            obj.pageIndex = pageIndex;
            obj.pageDelegate = self;
            obj.member = self.girl;
            
            [self.pageViewControllers setObject:obj atIndexedSubscript:pageIndex];
        }
        return obj;
    }
    return nil;
}

-(void)gotoPage:(int)index{
    if(index>=0 && index<MAX_PAGES_GIRLS){
        UIViewController *startingViewController = [self getViewController:index];
        
        NSArray *newViewControllers = @[startingViewController];
        [self setViewControllers:newViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

-(void)goBack{
    if(self.curPageIndex>0){
        UIViewController *startingViewController = [self getViewController:_curPageIndex-1];
        
        NSArray *newViewControllers = @[startingViewController];
        [self setViewControllers:newViewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    }
}

-(void)goForward{
    if(self.curPageIndex < MAX_PAGES_GIRLS-1){
//        UIViewController* fromViewController =[self getViewController:self.curPageIndex];
        UIViewController* toViewController = [self getViewController:_curPageIndex+1];
        NSArray *newViewControllers = @[toViewController];
        [self setViewControllers:newViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        
//        toViewController.view.transform = CGAffineTransformMakeTranslation(300, 0);
//        [UIView animateWithDuration:0.2 animations:^{
////            toViewController.view.alpha = 1;
//            toViewController.view.transform = CGAffineTransformIdentity;
//            
//        } completion:^(BOOL finished) {
////            fromViewController.view.transform = CGAffineTransformIdentity;
//            
//        }];
    }
    else{
        [self onCancel];
    }
}

-(UINavigationItem*)getNavigationItem{
    return self.navigationItem;
}

-(void)onShow:(int) pageIndex title:(NSString *)pageTitle{
    self.curPageIndex = pageIndex;
    if(self.curPageIndex == 0) {
        //TODO
    }
    
    self.navigationItem.title = pageTitle;
    self.navigationItem.rightBarButtonItem = nil;
}
       
-(void)onCancel{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onUpdate:(int)pageIndex content:(NSString *)content{
    NSString* index = GIRLS_TAGS_CONST[pageIndex];
    [self.girl setValue:content forKey:index];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    
}
       

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    return [self getViewController:self.curPageIndex+1];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
        return [self getViewController:self.curPageIndex+1];
}

//-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
//    return MAX_PAGES_GIRLS;
//}
//
//-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
//    return self.curPageIndex;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
