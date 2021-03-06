//
//  GirlPageSummaryViewController.h
//  xman
//
//  Created by Liu Ming on 3/10/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "Member.h"
#import "GirlPageDelegate.h"

@interface GirlPageSummaryViewController : BaseUIViewController

@property(nonatomic,assign) int pageIndex;
@property(nonatomic,strong) Member* member;
@property(nonatomic,strong) id<GirlPageDelegate> pageDelegate;

@end
