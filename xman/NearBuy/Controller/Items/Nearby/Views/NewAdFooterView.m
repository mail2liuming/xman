//
//  NewAdFooterView.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "NewAdFooterView.h"

@interface NewAdFooterView ()
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@end

@implementation NewAdFooterView

- (void)awakeFromNib{
    [super awakeFromNib];
    [PublicFunction setButtonBorder:_cancelBtn];
    [PublicFunction setButtonBorder:_confirmBtn];
}
- (IBAction)ConfirmAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonActionConfirm:)]) {
        [self.delegate buttonActionConfirm:YES];
    }
}
- (IBAction)cancelAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonActionConfirm:)]) {
        [self.delegate buttonActionConfirm:NO];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
