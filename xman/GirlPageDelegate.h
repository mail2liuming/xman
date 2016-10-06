//
//  GirlPageDelegate.h
//  xman
//
//  Created by Liu Ming on 1/08/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GirlPageDelegate

-(void)goBack;
-(void)goForward;

-(void)onShow:(int)pageIndex title: (NSString*)pageTitle;
-(void)onUpdate:(int)pageIndex content:(NSString*)content;
-(void)onCancel;

-(UINavigationItem*)getNavigationItem;

-(void)gotoPage:(int)index;



@end
