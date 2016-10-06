//
//  CategoryCell.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/18.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "CategoryCell.h"

@interface CategoryCell ()
@property (nonatomic,strong)UIView*whitePointView;
@property (nonatomic,strong)UIView *selectedView;
@property (nonatomic,strong)UILabel *TitleLb;
@property (nonatomic,strong)UILabel *remarkLb;
@end

@implementation CategoryCell

- (void)awakeFromNib {
    
    _selectedView = [[UIView alloc]initWithFrame:CGRectMake(20, 2, self.width - 80, 40)];
    
    _selectedView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_selectedView];
    
    
    if (DEVICE_IS_IPHONE_4) {
        _selectedView.width = self.width - 120;
    }else if (DEVICE_IS_IPHONE_5){
        _selectedView.width = self.width - 115;
    }else if (DEVICE_IS_IPHONE_6){
        _selectedView.width = self.width - 90;
    }
    
//    _whitePointView = [[UIView alloc]initWithFrame:CGRectMake(11, 11, 3, 3)];
//    _whitePointView.backgroundColor = [UIColor blackColor];
//    _whitePointView.layer.cornerRadius = 1.5;
//    [_selectedView addSubview:_whitePointView];
    _TitleLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, _selectedView.width - 44, 40)];
    _TitleLb.textColor = [UIColor blackColor];
//    _TitleLb.highlightedTextColor = [UIColor whiteColor];
    _TitleLb.font = [UIFont systemFontOfSize:16];
    [_selectedView addSubview:_TitleLb];
    
//    _remarkLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(_whitePointView.frame)+22, CGRectGetMaxY(_selectedView.frame)+4, self.width, 21)];
//    _remarkLb.numberOfLines = 0;
//    _remarkLb.font = [UIFont systemFontOfSize:14];
//    _remarkLb.textColor = [UIColor darkGrayColor];
//    [self.contentView addSubview:_remarkLb];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)drawRect:(CGRect)rect{
//    CGContextRef context =UIGraphicsGetCurrentContext();
//    CGContextBeginPath(context);
//    CGContextSetLineWidth(context, 1.0);
//    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
//    CGFloat lengths[] = {5,5};
//    CGContextSetLineDash(context, 0, lengths,2);
//    CGContextMoveToPoint(context, 20, self.height - 1);
//    CGContextAddLineToPoint(context, UIScreenWidth - 20,self.height - 1);
//    CGContextStrokePath(context);
//    CGContextClosePath(context);
//    [super drawRect:rect];
}
- (void)setContentEty:(EtyAdCategory *)category{
    NSString *name =category.name;
//    NSString *desc = category.desc;
//    CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(_TitleLb.width, 21)];
    _TitleLb.text = name;
//    _TitleLb.size = nameSize;
    
//    _selectedView.width = CGRectGetMaxX(_TitleLb.frame)+10;
//    if (DEVICE_IS_IPHONE_6 ||DEVICE_IS_IPHONE_6PLUS) {
//        _remarkLb.width = self.width - 22;
//    }else{
//        _TitleLb.font = FONT(14);
//        _remarkLb.width = self.width - 120;
//    }
//    _remarkLb.text = desc;
//    CGSize descSize = [desc sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(_remarkLb.width, 60)];
//    _remarkLb.size = descSize;
    
//    self.height = CGRectGetMaxY(_remarkLb.frame)+10;
//    if (desc == nil ||[desc isEqualToString:@""]) {
//        self.height = CGRectGetMaxY(_selectedView.frame)+10;
//    }
//    _selectedView.width = self.width - 80;
    [self setNeedsDisplay];
    
}
- (void)selectHighlight:(BOOL)highlight{
    if (highlight) {
        [_selectedView setBackgroundColor:RGB(225, 225, 225)];
        _whitePointView.backgroundColor = [UIColor whiteColor];

    }else{
        [_selectedView setBackgroundColor:[UIColor whiteColor]];
        _whitePointView.backgroundColor = [UIColor blackColor];
        
    }
//    [_TitleLb setHighlighted:highlight];
}

@end
