//
//  GirlPageContentViewController.h
//  xman
//
//  Created by Liu Ming on 1/08/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "BaseUIViewController.h"
#import "Member.h"
#import "GirlPageDelegate.h"

@interface GirlPageContentViewController : BaseUIViewController

@property(nonatomic,assign) int pageIndex;
@property(nonatomic,strong) Member* member;
@property(nonatomic,strong) id<GirlPageDelegate> pageDelegate;

@end
