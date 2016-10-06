//
//  NewAdPhotosCell.h
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAdPhotosCell : UITableViewCell

@property (nonatomic,strong)void(^addNewPhotoBlock)(void);
@property (nonatomic,strong)void(^deletePhotoReloadBlock)(NSInteger index);
- (void)loadPhotos:(NSArray *)array;

@end
