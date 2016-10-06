//
//  GirlImageCellDelegate.h
//  xman
//
//  Created by Liu Ming on 29/08/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GirlImageCellDelegate

-(void)onDelete: (int)index;

-(void)onClick: (int)index;


@end
