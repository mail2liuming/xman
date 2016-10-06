//
//  SendCommentView.h
//  NearBuy
//
//  Created by URoad_MP on 15/9/9.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendCommentView : UIView

- (void)beginTextEditing;

@property (nonatomic,strong)void(^sendMessageBlock)(NSString *);

- (void)clearInputText;
@end
