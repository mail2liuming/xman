//
//  NewAdPriceCell.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "NewAdPriceCell.h"

#define kAlphaNum @"1234567890."

@interface NewAdPriceCell ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UITextField *priceTf;

@end

@implementation NewAdPriceCell

- (void)awakeFromNib {
    self.backView.layer.cornerRadius = 4.0;
    [self.priceTf setDelegate:self];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *tobestring = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL basic = [string isEqualToString:filtered];
    if (basic) {

        
        NSArray *ps = [tobestring componentsSeparatedByString:@"."];
        if (ps.count == 3) {
            return NO;
        }
        if (ps.count>1) {
            NSString *s = ps[1];
            if (s.length>2) {
                return NO;
            }
        }
        if (tobestring.length>7 && [tobestring rangeOfString:@"."].length == 0) {
            return NO;
        }
        if (tobestring.length>8 && [tobestring rangeOfString:@"."].length == 1) {
            return NO;
        }
        if (self.outputPriceBlock) {
            self.outputPriceBlock(tobestring);
        }

        return YES;
    }else{
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (NSString*)price{
    return _priceTf.text;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.TextFieldBeginEditBlock) {
        self.TextFieldBeginEditBlock(YES);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.TextFieldBeginEditBlock) {
        self.TextFieldBeginEditBlock(NO);
    }
}

- (void)setPrice:(NSString *)price{
    CGFloat price_f = [price floatValue];
    
    _priceTf.text = [NSString stringWithFormat:@"%0.2f",price_f];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
