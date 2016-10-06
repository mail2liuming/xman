//
//  CommentCellModel.m
//  NearBuy
//
//  Created by URoad_MP on 15/9/9.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "CommentCellModel.h"

@implementation CommentCellModel

- (void)setAttachComment:(EtyComment *)attachComment{
    _attachComment = attachComment;
    CGFloat textPadding = 10;
    _timeFrame = CGRectMake(0, 5, UIScreenWidth, 16);
    
    _nameFrame = CGRectMake(20, CGRectGetMaxY(_timeFrame), UIScreenWidth - 40, 16);
    
    if ([attachComment.user_id isEqualToString:[AccountManager sharedInstance].currentUser.user_id]) {
        _whoComment = My_Comment;
        UIImage *arrowImage = [UIImage imageNamed:@"comment_arrow_right"];
        _textBackFrame = CGRectMake(35, CGRectGetMaxY(_nameFrame)+5, UIScreenWidth - arrowImage.size.width - 35, 5);
        _arrowFrame = CGRectMake(CGRectGetMaxX(_textBackFrame), CGRectGetMaxY(_nameFrame)+5, arrowImage.size.width, arrowImage.size.height);
        CGSize textMaxSize = CGSizeMake(_textBackFrame.size.width - textPadding*2, MAXFLOAT);

        CGSize textSize = [attachComment.content sizeWithFont:[UIFont systemFontOfSize:16.0] maxSize:textMaxSize];
        _textFrame = CGRectMake(textPadding, 10, textSize.width, textSize.height);
        _textBackFrame.size.height = CGRectGetMaxY(_textFrame)+10;
        if (_textBackFrame.size.height<50) {
            _textBackFrame.size.height = 50;
        }
        _cellHeght = CGRectGetMaxY(_textBackFrame)+textPadding;
        
    }else{
        _whoComment = Other_Comment;
        
        UIImage *arrowImage = [UIImage imageNamed:@"comment_arrow_left"];
        
        _arrowFrame = CGRectMake(0, CGRectGetMaxY(_nameFrame)+5, arrowImage.size.width, arrowImage.size.height);
        _textBackFrame = CGRectMake(CGRectGetMaxX(_arrowFrame)-2, CGRectGetMaxY(_nameFrame)+5, UIScreenWidth - arrowImage.size.width - 35, 5);
        CGSize textMaxSize = CGSizeMake(_textBackFrame.size.width - textPadding*2, MAXFLOAT);
        
        CGSize textSize = [attachComment.content sizeWithFont:[UIFont systemFontOfSize:16.0] maxSize:textMaxSize];
        _textFrame = CGRectMake(textPadding, 10, textSize.width, textSize.height);
        _textBackFrame.size.height = CGRectGetMaxY(_textFrame)+10;
        if (_textBackFrame.size.height<50) {
            _textBackFrame.size.height = 50;
        }

        _cellHeght = CGRectGetMaxY(_textBackFrame)+textPadding;
        
        
    }
}

- (void)configEtyCommentModel:(EtyComment *)attachComment withSellUserId:(NSString *)sUid{
    _attachComment = attachComment;
    CGFloat textPadding = 10;
    _timeFrame = CGRectMake(0, 5, UIScreenWidth, 16);
    
    _nameFrame = CGRectMake(20, CGRectGetMaxY(_timeFrame)-5, UIScreenWidth - 40, 16);
    
    if ([attachComment.user_id isEqualToString:sUid]) {
        _whoComment = My_Comment;
        UIImage *arrowImage = [UIImage imageNamed:@"comment_arrow_right"];
        _textBackFrame = CGRectMake(35, CGRectGetMaxY(_nameFrame)+6, UIScreenWidth - arrowImage.size.width - 35, 5);
        _arrowFrame = CGRectMake(CGRectGetMaxX(_textBackFrame), CGRectGetMaxY(_nameFrame)+5, arrowImage.size.width, arrowImage.size.height);
        CGSize textMaxSize = CGSizeMake(_textBackFrame.size.width - textPadding*2, MAXFLOAT);
        
        CGSize textSize = [attachComment.content sizeWithFont:[UIFont systemFontOfSize:16.0] maxSize:textMaxSize];
        _textFrame = CGRectMake(textPadding, 10, textSize.width, textSize.height);
        _textBackFrame.size.height = CGRectGetMaxY(_textFrame)+10;
        if (_textBackFrame.size.height<50) {
            _textBackFrame.size.height = 50;
        }
        _cellHeght = CGRectGetMaxY(_textBackFrame);
        
    }else{
        _whoComment = Other_Comment;
        
        UIImage *arrowImage = [UIImage imageNamed:@"comment_arrow_left"];
        
        _arrowFrame = CGRectMake(0, CGRectGetMaxY(_nameFrame)+6, arrowImage.size.width, arrowImage.size.height);
        _textBackFrame = CGRectMake(CGRectGetMaxX(_arrowFrame)-2, CGRectGetMaxY(_nameFrame)+6, UIScreenWidth - arrowImage.size.width - 35, 5);
        CGSize textMaxSize = CGSizeMake(_textBackFrame.size.width - textPadding*2, MAXFLOAT);
        
        CGSize textSize = [attachComment.content sizeWithFont:[UIFont systemFontOfSize:16.0] maxSize:textMaxSize];
        _textFrame = CGRectMake(textPadding, 10, textSize.width, textSize.height);
        _textBackFrame.size.height = CGRectGetMaxY(_textFrame)+10;
        if (_textBackFrame.size.height<50) {
            _textBackFrame.size.height = 50;
        }
        
        _cellHeght = CGRectGetMaxY(_textBackFrame);
        
        
    }

}

@end
