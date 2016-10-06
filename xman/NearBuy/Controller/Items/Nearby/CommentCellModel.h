//
//  CommentCellModel.h
//  NearBuy
//
//  Created by URoad_MP on 15/9/9.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EtyComment.h"

typedef NS_ENUM(NSInteger, COMMENT_TYPE) {
    Other_Comment,
    My_Comment
};

@interface CommentCellModel : NSObject

@property (nonatomic, assign, readonly) CGRect timeFrame;
@property (nonatomic, assign, readonly) CGRect nameFrame;

@property (nonatomic,assign,readonly)CGRect arrowFrame;
@property (nonatomic,assign,readonly)CGRect textBackFrame;
@property (nonatomic, assign, readonly) CGRect textFrame;
@property (nonatomic, assign, readonly) CGFloat cellHeght;
@property (nonatomic,assign,readonly)COMMENT_TYPE whoComment;

@property (nonatomic,strong)EtyComment *attachComment;

- (void)configEtyCommentModel:(EtyComment *)attachComment withSellUserId:(NSString *)sUid;

@end
