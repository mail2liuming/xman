//
//  ImageScrollView.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "ImageScrollView.h"
#import "PhotosDisplayController.h"
#import "DBModel.h"
@interface ImageScrollView()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scView;
@property (strong, nonatomic) IBOutlet UILabel *contentLb;
@property (strong, nonatomic) IBOutlet UIPageControl *pageC;

@property (strong, nonatomic) IBOutlet UIImageView *watchedTag;
@property (nonatomic,strong)NSArray*allUrls;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong, nonatomic) IBOutlet UIButton *mileBtn;
@property (strong, nonatomic) IBOutlet UILabel *moneyLb;
@end

@implementation ImageScrollView

- (id)initWiew{
    
    self = LOAD_XIB_CLASS(ImageScrollView);
    if (self) {
        self.scView.delegate = self;
//        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoPhotoDetail)];
//        tap.numberOfTapsRequired = 1;
//        tap.numberOfTouchesRequired = 1;
//        [self.scView addGestureRecognizer:tap];
    }
    return self;
    
}


- (void)gotoPhotoDetail{
    
    PhotosDisplayController *vc  =[[PhotosDisplayController alloc]initControllerWithUrlsArray:self.allUrls withTitles:nil withNaviTitle:nil withSelectIndex:0];
    PUSH_CONTROLLER(vc);
}
- (void)showWatchTag{
    [_watchedTag setHidden:NO];
}
- (void)hideWatchTag{
    [_watchedTag setHidden:YES];
}
- (void)loadDataWith:(EtyAd *)ad bySize:(CGSize)size{
//    self.size = size;
//    self.scView.size = size;
    [self loadDataWith:ad bySize:size withType:0];

}

- (void)loadDataWith:(EtyAd *)ad bySize:(CGSize)size withType:(NSString *)type{
    NSMutableArray *urls = [NSMutableArray array];
    NSString *url1 = ad.pic1;
    NSString *url2 = ad.pic2;
    NSString *url3 = ad.pic3;
    NSString *url4 = ad.pic4;
    NSString *url5 = ad.pic5;
    if ([url1 isKindOfClass:[NSString class]] && ![url1 isEqualToString:@""]) {
        [urls addObject:url1];
    }
    if ([url2 isKindOfClass:[NSString class]] && ![url2 isEqualToString:@""]) {
        [urls addObject:url2];
    }
    if ([url3 isKindOfClass:[NSString class]] && ![url3 isEqualToString:@""]) {
        [urls addObject:url3];
    }
    if ([url4 isKindOfClass:[NSString class]] && ![url4 isEqualToString:@""]) {
        [urls addObject:url4];
    }
    if ([url5 isKindOfClass:[NSString class]] && ![url5 isEqualToString:@""]) {
        [urls addObject:url5];
    }
    self.allUrls = urls;
    self.clipsToBounds = YES;
    __block CGFloat left = 0;
    
    [urls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(left, 0, self.width, self.height)];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.clipsToBounds = YES;
        
        [imgv sd_setImageWithURL:[NSURL URLWithString:obj] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                imgv.image = [UIImage imageNamed:@"AdNoImagePlacehold"];
                imgv.contentMode = UIViewContentModeScaleAspectFit;
            }
        }];
        imgv.userInteractionEnabled = YES;
        UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoPhotoDetail)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imgv addGestureRecognizer:tap];

        [self.scView addSubview:imgv];
        left = CGRectGetMaxX(imgv.frame);
    }];
    self.scView.contentSize = CGSizeMake(left, self.scView.height);
    
    [self adjustPageControlRight:urls.count];
    CGFloat money = [ad.price floatValue];
    NSString *content = [NSString stringWithFormat:@"Watched:%@ | Views:%@ | $%0.2f",ad.watchlistcount,ad.view_count,money];
    self.contentLb.text = content;
    CLLocation *adLoc = [[CLLocation alloc]initWithLatitude:[ad.lat floatValue] longitude:[ad.lng floatValue]];
    CLLocation *myLoc = [LocationManager sharedInstance].currentLocation;
    CGFloat distance = [adLoc distanceFromLocation:myLoc]/1000.;
    if (distance<1) {
        NSString *disString = [NSString stringWithFormat:@" %0.1fm away",distance*1000];
        [_mileBtn setTitle:disString forState:UIControlStateNormal];
        //        [_locateBtn setTitle:disString forState:UIControlStateNormal];
        
        
    }else{
        NSString *disString = [NSString stringWithFormat:@" %0.1fkm away",distance];
        if (disString.length>4) {
            _mileBtn.titleLabel.font = FONT(10);
        }
        [_mileBtn setTitle:disString forState:UIControlStateNormal];
        //        [_locateBtn setTitle:disString forState:UIControlStateNormal];
    }
    //    _locateBtn.titleLabel.textColor = _distanceLb.textColor;
    
    NSString*con = [NSString stringWithFormat:@"Q&A(%@)",ad.commentcount];
    _commentBtn.width = 80;

    [_commentBtn setTitle:con forState:UIControlStateNormal];
    if (DEVICE_IS_IPHONE_4 || DEVICE_IS_IPHONE_5) {
        _commentBtn.titleLabel.font = FONT(10);
    }
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
    CGFloat price = [ad.price floatValue];
    if (price == 0) {
        _moneyLb.text = @"free  ";
    }else{
        _moneyLb.text = [NSString stringWithFormat:@"$%0.2f  ",price];
    }

}

- (void)adjustPageControlRight:(NSInteger)count{
    _pageC.numberOfPages = count;
    CGSize pointSize = [_pageC sizeForNumberOfPages:count];
    
    CGFloat page_x = -(_pageC.bounds.size.width - pointSize.width) / 2 ;
    
    [_pageC setBounds:CGRectMake(page_x, _pageC.bounds.origin.y,
                                      _pageC.bounds.size.width, _pageC.bounds.size.height)];

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger pg = scrollView.contentOffset.x / self.width;
    _pageC.currentPage = pg;
}
@end
