//
//  PhotoView.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoView : UIView

- (id)initView;

@property (strong, nonatomic) IBOutlet UIView *borderView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic,strong)void(^deletePhotoBlock)(NSInteger);

@end
