//
//  AddNewGirlViewController.h
//  xman
//
//  Created by Liu Ming on 27/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"
#import "Constants.h"
#import "GirlPageDelegate.h"



@interface AddNewGirlViewController : UIPageViewController<GirlPageDelegate,UIPageViewControllerDataSource >


@property(strong,nonatomic) Member* girl;
@property(nonatomic,assign) int status;

@end
