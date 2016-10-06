//
//  GirlPageImageLUIViewController.h
//  xman
//
//  Created by Liu Ming on 5/08/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Member.h"
#import "GirlPageDelegate.h"
#import "GirlImageCellDelegate.h"
#import <CTAssetsPickerController/CTAssetsPickerController.h>

@interface GirlPageImageLUIViewController : UICollectionViewController<GirlImageCellDelegate,CTAssetsPickerControllerDelegate>

@property(nonatomic,assign) int pageIndex;
@property(nonatomic,strong) Member* member;
@property(nonatomic,strong) id<GirlPageDelegate> pageDelegate;

@end
