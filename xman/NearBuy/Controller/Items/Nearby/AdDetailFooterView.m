//
//  AdDetailFooterView.m
//  NearBuy
//
//  Created by URoad_MP on 15/11/20.
//  Copyright © 2015年 nearbuy. All rights reserved.
//

#import "AdDetailFooterView.h"

@interface AdDetailFooterView ()
@property (strong, nonatomic) IBOutlet UIButton *secondBtn;

@property (strong, nonatomic) IBOutlet UIButton *topBtn;
@end

@implementation AdDetailFooterView
{
    FooterType currentType;
}

-  (id)initViewWithWithType:(FooterType)type{
    self = LOAD_XIB_CLASS(AdDetailFooterView);
    if (self) {
        currentType = type;
        self.topBtn.layer.cornerRadius = 3.0;
        self.secondBtn.layer.cornerRadius = 3.0;
        UIImage *topImage ;
        NSString *topTitle;
        if (type == Footer_Normal_AddFavi) {
            topImage = [UIImage imageNamed:@"whiteHeart"];
            topTitle = [NSString stringWithFormat:@"Add to favourites"];
        }else if (type == Footer_Normal_RemoveFavi){
            topImage = [UIImage imageNamed:@"whiteHeart"];
            topTitle = [NSString stringWithFormat:@"Remove to favourites"];
        }else if (type == Footer_Withdrawn || type == Footer_Expired){
            topImage = [UIImage imageNamed:@"Relist"];
            topTitle = [NSString stringWithFormat:@"Relist"];
        }else if (type == Footer_Current){
            topImage = [UIImage imageNamed:@"Edit"];
            topTitle = [NSString stringWithFormat:@"Edit"];
        }
        
        [self.topBtn setImage:topImage forState:UIControlStateNormal];
        [self.topBtn setTitle:topTitle forState:UIControlStateNormal];
        self.topBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
//        self.topBtn.titleLabel.font = FONT(15);
        self.topBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);

        [self.secondBtn setTitle:@"Leave a comment" forState:UIControlStateNormal];
        
        
    }
    return self;
}

- (void)showHasFavi:(BOOL)favied{
    if (favied) {
        [self.topBtn setTitle:@"Remove to favourites" forState:UIControlStateNormal];
    }else{
        [self.topBtn setTitle:@"Add to favourites" forState:UIControlStateNormal];        
    }
}

- (IBAction)topClick:(id)sender {
    if (self.topButtonClickBlock) {
        self.topButtonClickBlock();
    }
}
- (IBAction)secondClick:(id)sender {
    if (self.secondButtonClickBlock) {
        self.secondButtonClickBlock();
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
