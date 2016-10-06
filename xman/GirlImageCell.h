//
//  GirlImageCell.h
//  xman
//
//  Created by Liu Ming on 5/08/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GirlImageCellDelegate.h"
#import "PhotoWrapper.h"
#import "Constants.h"

@interface GirlImageCell : UICollectionViewCell

@property(strong,nonatomic) PhotoWrapper* imageDataWrapper;
@property(strong,nonatomic) id<GirlImageCellDelegate> delegate;

@end
