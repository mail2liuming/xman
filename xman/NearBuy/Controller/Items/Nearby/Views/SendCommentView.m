//
//  SendCommentView.m
//  NearBuy
//
//  Created by URoad_MP on 15/9/9.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "SendCommentView.h"

@implementation SendCommentView
{
    
    IBOutlet UITextField *inputTf;
    
    IBOutlet UIButton *postBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    postBtn.layer.cornerRadius = 4.0;
}
- (void)beginTextEditing{
    [inputTf becomeFirstResponder];
}
- (IBAction)cancelAction:(id)sender {
    [inputTf resignFirstResponder];
}
- (IBAction)sendAction:(id)sender {
    NSString *text = inputTf.text;
    if ([text isEqualToString:@""]) {
        return;
    }
    [inputTf resignFirstResponder];
    if (self.sendMessageBlock) {
        self.sendMessageBlock(text);
    }
}

- (void)clearInputText{
    inputTf.text = @"";
}

@end
