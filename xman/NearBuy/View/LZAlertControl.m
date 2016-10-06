//
//  LZAlertControl.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/20.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "LZAlertControl.h"

@interface LZAlertControl ()
@property (strong, nonatomic) IBOutlet UILabel *titleLb;
@property (strong, nonatomic) IBOutlet UILabel *descLb;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation LZAlertControl

- (id)initViewWithTitle:(NSString *)title withRemark:(NSString *)remark{
    self = LOAD_XIB_CLASS(LZAlertControl);
    if (self) {
        self.width = UIScreenWidth - 30;
        self.layer.cornerRadius = 3.0;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowOpacity = 0.4;
        self.titleLb.text = title;
        self.descLb.text = remark;
        self.descLb.numberOfLines = 0;
        self.height = CGRectGetMaxY(self.descLb.frame)+70;
        [PublicFunction setButtonBorder:_cancelBtn];
        [PublicFunction setButtonBorder:_confirmBtn];
    }
    return self;
}

- (IBAction)cancelAction:(id)sender {
    if (self.alertBlock) {
        self.alertBlock(NO);
    }
}
- (IBAction)confirmAction:(id)sender {
    if (self.alertBlock) {
        self.alertBlock(YES);
    }
}

+ (void)showAlertWithTitle:(NSString *)title withRemark:(NSString *)remark withBlock:(AlertButtonClick)block{
    LZAlertControl *alert = [[LZAlertControl alloc]initViewWithTitle:title withRemark:remark];
    LZPopAnimationView *pop = [LZPopAnimationView addContentView:alert];
    [pop showPop];
    alert.alertBlock=^(BOOL confirm){
        [pop dismissPop];
        block(confirm);
    };

}

@end
