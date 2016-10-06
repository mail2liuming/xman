//
//  NewAdContactCell.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "NewAdContactCell.h"

@interface NewAdContactCell()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UITextField *contactTf;

@end

@implementation NewAdContactCell

- (void)awakeFromNib {
    self.backView.layer.cornerRadius = 4.0;
}

- (NSString *)phone{
    return _contactTf.text;
}

- (void)setPhone:(NSString *)phone{
    _contactTf.text = phone;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"contactTfEditCompleted" object:nil];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
