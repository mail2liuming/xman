//
//  NewPhotosCollectionCell.h
//  NearBuy
//
//  Created by URoad_MP on 15/11/26.
//  Copyright © 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPhotosCollectionCell : UICollectionViewCell

@property (nonatomic,strong)UIImage *attachImage;
@property (nonatomic,strong)void(^removeItemBlock)(void);

- (void)addOverlayView;
- (void)removeOverlayView;
- (void)hideDeleteButton;
- (void)showDeleteButton;
@end
