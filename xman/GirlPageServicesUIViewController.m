//
//  GirlPageServicesUIViewController.m
//  xman
//
//  Created by Liu Ming on 2/08/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "GirlPageServicesUIViewController.h"

@interface GirlPageServicesUIViewController ()
@property (weak, nonatomic) IBOutlet UITextField *serviceTextField;
@property (weak, nonatomic) IBOutlet UITextField *rateTextField;
@property (weak, nonatomic) IBOutlet UITextField *lengthTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;

@property NSMutableArray* options;
@property NSMutableArray* optionViews;

@end

@implementation GirlPageServicesUIViewController

int optionCount=0;

static const int MAX_OPTIONS_SHOWN=3;

-(void)viewDidLoad{
    self.options = [[NSMutableArray alloc]init];
    self.optionViews= [[NSMutableArray alloc]init];
    
    
    [super viewDidLoad];
    [self.pageDelegate onShow:self.pageIndex title:@"options"];
//    [self setPageIndicator];
    
    [self updateKeyboardPanelMiddleButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.serviceTextField becomeFirstResponder];
}

-(void)attachContent{
    self.options = [[NSMutableArray alloc]init];
    [self.options addObjectsFromArray:self.member.options];
    [self showOptions];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.member.options = self.options;
}

- (IBAction)textEditingBegin:(id)sender {
    self.activeField = sender;
}
- (IBAction)textEditingEnd:(id)sender {
    self.activeField = nil;
}
- (IBAction)textEditingReturn:(id)sender {
   
}
- (IBAction)tabOutside:(id)sender {
    [self.activeField resignFirstResponder];
}

-(void)updateKeyboardPanelMiddleButton{
    [self.keyboardPanel.middleButton setHidden:NO];
    [self.keyboardPanel.middleButton setTitle:@"save" forState:UIControlStateNormal];
    [self.keyboardPanel.middleButton addTarget:self action:@selector(commitOption) forControlEvents:UIControlEventTouchUpInside];
}

-(void)commitOption{
    [self.headerTitle setHidden:TRUE];
    
    NSString* option =[NSString stringWithFormat:@"Option %d:%@,%@,%@ ",++optionCount,self.serviceTextField.text,self.rateTextField.text,self.lengthTextField.text];
    
//    NSString* option =[NSString stringWithFormat:@"option %d ",++optionCount];
    [self.options addObject:option];
    
    [self showOptions];
}
    
-(void)showOptions{
    int count = (self.options.count > MAX_OPTIONS_SHOWN)?MAX_OPTIONS_SHOWN:(int)self.options.count;
    int offset =(self.options.count > MAX_OPTIONS_SHOWN)?(int)(self.options.count - MAX_OPTIONS_SHOWN):0;
    for(int i=0;i<self.optionViews.count;i++){
        [self.optionViews[i] removeFromSuperview];
    }
    
    for(int i=0;i<count;i++){
        NSString* option = self.options[i+offset];
        UILabel* optionView = [[UILabel alloc]initWithFrame:CGRectMake(0, (i+3)*25, 200, 20)];
        [optionView setText:option];
        [self.optionViews addObject:optionView];
        [self.view addSubview:optionView];
    }
}


@end
