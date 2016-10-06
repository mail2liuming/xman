//
//  NewAdDetailFooterView.m
//  NearBuy
//
//  Created by URoad_MP on 16/1/27.
//  Copyright © 2016年 nearbuy. All rights reserved.
//

#import "NewAdDetailFooterView.h"

@interface NewAdDetailFooterView()
@property (strong, nonatomic) IBOutlet UILabel *contactLb;
@property (strong, nonatomic) IBOutlet UIButton *funcBtn;
@property (nonatomic,strong)EtyAd *attachEty;

@end

@implementation NewAdDetailFooterView
{
    FooterType currentType;
}
- (id)initWithEtyAd:(EtyAd *)ad withType:(FooterType)type{
    self =LOAD_XIB_CLASS(NewAdDetailFooterView);
    if (self) {
        self.attachAd = ad;
        currentType = type;
        UIImage *topImage ;
        NSString *topTitle;
        if (type == Footer_Normal_AddFavi) {
            topImage = [UIImage imageNamed:@"whiteHeart"];
            topTitle = [NSString stringWithFormat:@"Add to favourites"];
            [self.funcBtn setHidden:YES];
        }else if (type == Footer_Normal_RemoveFavi){
            topImage = [UIImage imageNamed:@"whiteHeart"];
            topTitle = [NSString stringWithFormat:@"Remove to favourites"];
            [self.funcBtn setHidden:YES];
        }else if (type == Footer_Withdrawn || type == Footer_Expired){
            topImage = [UIImage imageNamed:@"Relist"];
            topTitle = [NSString stringWithFormat:@"Relist"];
        }else if (type == Footer_Current){
            topImage = [UIImage imageNamed:@"Edit"];
            topTitle = [NSString stringWithFormat:@"Edit"];
        }
        self.funcBtn.layer.cornerRadius = 3.0;
        [self.funcBtn setImage:topImage forState:UIControlStateNormal];
        [self.funcBtn setTitle:topTitle forState:UIControlStateNormal];
        self.funcBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);

        self.funcBtn.tintColor = [UIColor whiteColor];
        self.contactLb.text =[NSString stringWithFormat:@"contact seller:  %@",self.attachAd.phone];
    }
    return self;
}
- (void)reloadFooterData{
    self.contactLb.text = _attachAd.phone;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.funcBtn.layer.cornerRadius = 3.0;
    self.contactLb.text = self.attachAd.phone;
}

- (void)setAttachAd:(EtyAd *)attachAd{
    _attachAd = attachAd;
    _contactLb.text = attachAd.phone;
    
    
}
- (void)messageCall{
    NSString *sms = [NSString stringWithFormat:@"sms://%@",self.attachAd.phone];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:sms]];
    
}
- (void)call{
    NSString *sms = [NSString stringWithFormat:@"tel://%@",self.attachAd.phone];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:sms]];
}

- (IBAction)callAction:(id)sender {
    [self call];
}
- (IBAction)smsAction:(id)sender {
    [self messageCall];
}
- (IBAction)funcAction:(id)sender {
    if (self.topButtonClickBlock) {
        self.topButtonClickBlock();
    }

}
@end
