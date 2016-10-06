//
//  NewAdTitleDescCell.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "NewAdTitleDescCell.h"

@interface NewAdTitleDescCell ()<UITextViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *titleTf;
@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) IBOutlet UILabel *placeholdLb;
@property (strong, nonatomic) IBOutlet UITextView *descTv;
@end

@implementation NewAdTitleDescCell

- (void)awakeFromNib {
    self.backView.layer.cornerRadius = 4.0;
    [self.descTv setDelegate:self];
    _titleTf.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(titleTfBeginEdit) name:@"contactTfEditCompleted" object:nil];
}

- (void)titleTfBeginEdit{
    [_titleTf becomeFirstResponder];
}

- (void)setAdDesc:(NSString *)desc{
    _descTv.text = desc;
    if (desc!=nil && desc.length>0) {
        [_placeholdLb setHidden:YES];
    }
}
- (void)setAdTitle:(NSString *)title{
    _titleTf.text = title;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _titleTf) {
        [_titleTf resignFirstResponder];
        [_descTv becomeFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.TextViewBeginEditBlock) {
        self.TextViewBeginEditBlock(YES);
    }

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.TextViewBeginEditBlock) {
        self.TextViewBeginEditBlock(NO);
    }

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.TextViewBeginEditBlock) {
        self.TextViewBeginEditBlock(YES);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.TextViewBeginEditBlock) {
        self.TextViewBeginEditBlock(NO);
    }
}


- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:@"\n"]) {
        textView.text = @"";
        return;
    }
    if (textView.text.length>0) {
        [self.placeholdLb setHidden:YES];
    }else{
        [self.placeholdLb setHidden:NO];
    }
    if (self.outputDescBlock) {
        self.outputDescBlock(textView.text);
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString*tobestring = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (self.outputTitleBlock) {
        self.outputTitleBlock(tobestring);
    }
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
