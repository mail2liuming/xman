//
//  AdCell.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/18.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "AdCell.h"
#import "DBModel.h"
@interface AdCell()

@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIImageView *adImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *imgloadActView;
@property (strong, nonatomic) IBOutlet UILabel *titleLb;
@property (strong, nonatomic) IBOutlet UILabel *descLb;

@property (strong, nonatomic) IBOutlet UILabel *timeLb;
@property (strong, nonatomic) IBOutlet UILabel *distanceLb;
@property (strong, nonatomic) IBOutlet UILabel *priceLb;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong, nonatomic) IBOutlet UIButton *locateBtn;
@end

@implementation AdCell

- (void)awakeFromNib {
    _backView.layer.cornerRadius = 4.0;
    _backView.clipsToBounds =YES;
    _backView.layer.borderColor  =RGB(193, 193, 193).CGColor;
    _backView.layer.borderWidth= 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillDataThinkDate:(EtyAd *)ad byType:(NSString *)type{
    NSString *url = ad.pic1;
    [_imgloadActView startAnimating];
    [_adImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"AdNoImagePlacehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_imgloadActView stopAnimating];
    }];
    _titleLb.text = ad.title;
    if ([ad.describe isKindOfClass:[NSString class]]) {
        _descLb.text = [ad.describe stringByReplacingOccurrencesOfString:@"\n" withString:@""];        
    }
    
    if (_descLb.height>69) {
        _descLb.height = 69;
    }
    
    NSDate *createtime = [PublicFunction tranferUnitTime:ad.realease_time];
    _timeLb.text = [createtime timeAgo];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    if ([ad.realease_time integerValue] - a <12*60*60) {
        _timeLb.textColor = [UIColor redColor];
    }
    [_timeLb setHidden:YES];
    if ([ad.state isEqualToString:@"2"]) {
        //过期
        [_timeLb setHidden:NO];
        _timeLb.text = @"Expired";
        _timeLb.textColor = [UIColor redColor];
        [_commentBtn setHidden:YES];
    }else if ([ad.state isEqualToString:@"3"]){
        //下架
        [_timeLb setHidden:NO];
        _timeLb.text = @"Withdrawn";
        _timeLb.textColor = [UIColor redColor];
        [_commentBtn setHidden:YES];
    }
    CLLocation *adLoc = [[CLLocation alloc]initWithLatitude:[ad.lat floatValue] longitude:[ad.lng floatValue]];
    CLLocation *myLoc = [LocationManager sharedInstance].currentLocation;
    CGFloat distance = [adLoc distanceFromLocation:myLoc]/1000.;
    if (distance<1) {
        NSString *disString = [NSString stringWithFormat:@" %0.1fm",distance*1000];
        _distanceLb.text = disString;
        [_locateBtn setTitle:disString forState:UIControlStateNormal];

        
    }else{
        NSString *disString = [NSString stringWithFormat:@" %0.1fkm",distance];
        _distanceLb.text = disString;
        [_locateBtn setTitle:disString forState:UIControlStateNormal];
    }
    _locateBtn.titleLabel.textColor = _distanceLb.textColor;

    CGFloat price = [ad.price floatValue];
    if (price == 0) {
        _priceLb.text = @"free";
    }else{
        _priceLb.text = [NSString stringWithFormat:@"$%0.2f",price];
    }
    //    BOOL pricetype = [ad.pricetype boolValue];
    //    if (pricetype) {
    //        _priceLb.text = [NSString stringWithFormat:@"$%@",ad.price];
    //    }else{
    //    }
    NSString*con = [NSString stringWithFormat:@"  Q&A(%@)",ad.commentcount];
    [_commentBtn setTitle:con forState:UIControlStateNormal];
    _commentBtn.width = 80;

    if ([type isEqualToString:@"1"]||[type isEqualToString:@"2"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *oldComment = [[DBModel sharedInstance]queryCommentCount:ad byType:type];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([oldComment isEqualToString:ad.commentcount]) {
                    [_commentBtn setImage:[UIImage imageNamed:@"HomeCommentCountNoNew"] forState:UIControlStateNormal];
                }else{
                    [_commentBtn setImage:[UIImage imageNamed:@"HomeCommentCount"] forState:UIControlStateNormal];
                }
                
            });
        });
        
    }

    self.height = 145;

}
- (void)fillData:(EtyAd *)ad byType:(NSString *)type{
    NSString *url = ad.pic1;
    [_imgloadActView startAnimating];
    [_adImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"AdNoImagePlacehold"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_imgloadActView stopAnimating];
    }];
    _titleLb.text = ad.title;
    _descLb.text = ad.describe;
    
    if (_descLb.height>69) {
        _descLb.height = 69;
    }
    
    NSDate *createtime = [PublicFunction tranferUnitTime:ad.currt_time];
    _timeLb.text = [createtime timeAgo];
    [_timeLb setHidden:YES];
    CLLocation *adLoc = [[CLLocation alloc]initWithLatitude:[ad.lat floatValue] longitude:[ad.lng floatValue]];
    CLLocation *myLoc = [LocationManager sharedInstance].currentLocation;
    CGFloat distance = [adLoc distanceFromLocation:myLoc]/1000.;
    if (distance<1) {
        NSString *disString = [NSString stringWithFormat:@" %0.1fm",distance*1000];
        _distanceLb.text = disString;
        [_locateBtn setTitle:disString forState:UIControlStateNormal];

    }else{
        NSString *disString = [NSString stringWithFormat:@" %0.1fkm",distance];
        _distanceLb.text = disString;
        [_locateBtn setTitle:disString forState:UIControlStateNormal];

    }
    
    CGFloat price = [ad.price floatValue];
    if (price == 0) {
        _priceLb.text = @"free";
    }else{
        _priceLb.text = [NSString stringWithFormat:@"$%0.2f",price];
    }
//    BOOL pricetype = [ad.pricetype boolValue];
//    if (pricetype) {
//        _priceLb.text = [NSString stringWithFormat:@"$%@",ad.price];
//    }else{
//    }
    NSString*con = [NSString stringWithFormat:@"  Q&A(%@)",ad.commentcount];
    [_commentBtn setTitle:con forState:UIControlStateNormal];
    _commentBtn.width = 80;
    if ([type isEqualToString:@"1"]||[type isEqualToString:@"2"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *oldComment = [[DBModel sharedInstance]queryCommentCount:ad byType:type];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([oldComment isEqualToString:ad.commentcount]) {
                    [_commentBtn setImage:[UIImage imageNamed:@"HomeCommentCountNoNew"] forState:UIControlStateNormal];
                }else{
                    [_commentBtn setImage:[UIImage imageNamed:@"HomeCommentCount"] forState:UIControlStateNormal];
                }
                
            });
        });

    }
    
    self.height = 145;
    
}

@end
