//
//  GirlPageContentViewController.m
//  xman
//
//  Created by Liu Ming on 1/08/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "GirlPageContentViewController.h"
#import "Constants.h"

@interface GirlPageContentViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pageContent;
@property (weak, nonatomic) IBOutlet UILabel *pageHeaderTitle;

@property (weak, nonatomic) IBOutlet UILabel *pageHeaderIndicator;
@end

@implementation GirlPageContentViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    [self.pageDelegate onShow:self.pageIndex title:GIRLS_TAGS_CONST[self.pageIndex]];
    [self setPageIndicator];
    [self updateKeyboardPanel];
    [self updatePageTitle];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.pageContent becomeFirstResponder];
    
    [self attachContent];
}

-(void)attachContent{
    NSString* index = GIRLS_TAGS_CONST[self.pageIndex];
    [self.pageContent setText:[self.member valueForKey:index]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.pageContent){
        [self.pageDelegate onUpdate:self.pageIndex content:self.pageContent.text];
    }
}
- (IBAction)textStartEdit:(id)sender {
    self.activeField = sender;
}
- (IBAction)textEndEdit:(id)sender {
    self.activeField = nil;
}
- (IBAction)textFinishEdit:(id)sender {
    [self nextScreen];
}

-(void)nextScreen{
    if(self.pageIndex<MAX_PAGES_GIRLS-1){
        [self.pageDelegate goForward];
    }
    else{
        
    }
    
}

-(void)updatePageTitle{
    NSString * str = [[NSString alloc]initWithFormat:(@"Enter %@"),GIRLS_TAGS_CONST[self.pageIndex]];
    [self.pageHeaderTitle setText:str];
}
-(void)previousScreen{
    [self.pageDelegate goBack];
}

-(void)updateKeyboardPanel{
    [self.keyboardPanel.middleButton setHidden:YES];
    if(self.pageIndex == 0){
        [self.keyboardPanel.leftButton setHidden:YES];
    }else if(self.pageIndex<=MAX_PAGES_GIRLS){
        [self.keyboardPanel.leftButton setHidden:NO];
    }else{
        
    }
    [self.keyboardPanel.leftButton addTarget:self action:@selector(previousScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboardPanel.rightButton addTarget:self action:@selector(nextScreen) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* title = (self.pageIndex<MAX_PAGES_GIRLS-1)?GIRLS_TAGS_CONST[self.pageIndex+1]:@"finish";
    [self.keyboardPanel.rightButton setTitle:title forState:UIControlStateNormal];
    
}

-(void)setPageIndicator{
    NSString* pageIndicator = [NSString stringWithFormat:@"%0d of %d", self.pageIndex+1, MAX_PAGES_GIRLS];
    [self.pageHeaderIndicator setText:pageIndicator];
}
@end
