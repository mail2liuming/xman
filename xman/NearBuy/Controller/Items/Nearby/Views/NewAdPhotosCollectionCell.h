//
//  NewAdPhotosCollectionCell.h
//  NearBuy
//
//  Created by URoad_MP on 15/11/26.
//  Copyright © 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAdPhotosCollectionCell : UITableViewCell


- (void)addNewsImage:(UIImage *)image;
@property (nonatomic,strong)void(^addNewsImageAction)(void);

- (NSArray *)images;

- (NSInteger)canAddNewPhoto;
@end
