//
//  OrderByCell.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/18.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "OrderByCell.h"

@implementation OrderByCell

- (void)awakeFromNib {
    
}
- (void)drawLine{
    _drawable = YES;
}

- (void)selectHighlightStyle:(BOOL)highlight{
//    [_nameLb setHighlighted:highlight];
    if (highlight) {
        _nameLb.textColor = RGB(80, 193, 233);
    }else{
        _nameLb.textColor = [UIColor darkGrayColor];
    }
    [_imgV setHighlighted:highlight];
}

//画虚线
- (void)drawRect:(CGRect)rect{
    if (_drawable) {
//        CGContextRef context =UIGraphicsGetCurrentContext();
//        CGContextBeginPath(context);
//        CGContextSetLineWidth(context, 1.0);
//        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//        CGFloat lengths[] = {5,5};
//        CGContextSetLineDash(context, 0, lengths,2);
//        CGContextMoveToPoint(context, 5.0, 40.0);
//        CGContextAddLineToPoint(context, 300.0,40.0);
//        CGContextStrokePath(context);
////        CGContextClosePath(context);
    }
    
    
    [super drawRect:rect];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
