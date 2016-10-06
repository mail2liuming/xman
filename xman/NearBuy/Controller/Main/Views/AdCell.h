//
//  AdCell.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/18.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EtyAd.h"
@interface AdCell : UITableViewCell

- (void)fillData:(EtyAd *)ad byType:(NSString *)type;

- (void)fillDataThinkDate:(EtyAd *)ad byType:(NSString*)type;


@end
