//
//  ImageScrollView.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EtyAd.h"

/*!
 *  @brief  width:height = 611:400
 */

@interface ImageScrollView : UIView

- (id)initWiew;

- (void)loadDataWith:(EtyAd *)ad bySize:(CGSize)size;

- (void)loadDataWith:(EtyAd *)ad bySize:(CGSize)size withType:(NSString *)type;


- (void)showWatchTag;
- (void)hideWatchTag;
@end
