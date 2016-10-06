//
//  CommentCell.m
//  NearBuy
//
//  Created by URoad_MP on 15/9/9.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell()
@property (nonatomic,strong)UILabel *timelb;
@property (nonatomic,strong)UILabel *namelb;
@property (nonatomic,strong)UIImageView *arrowImgV;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UILabel *contentlb;

@end

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGB(237, 237, 237);
        _timelb = [[UILabel alloc]init];
        _timelb.textColor = RGB(127, 127, 127);
        _timelb.font = FONT(13);
        _timelb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timelb];
        
        _namelb = [[UILabel alloc]init];
        _namelb.textColor =RGB(127, 127, 127);
        _namelb.font = FONT(15);
        [self addSubview:_namelb];
        
        _arrowImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:_arrowImgV];
        _backView = [[UIView alloc]init];
//        _backView.layer.cornerRadius = 2.0;
        [self addSubview:_backView];
        
        _contentlb = [[UILabel alloc]init];
        _contentlb.font = FONT(16);
        _contentlb.numberOfLines = 0;
//        _contentlb.backgroundColor=[UIColor redColor];
        [_backView addSubview:_contentlb];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellModel:(CommentCellModel *)cellModel{
    _cellModel = cellModel;
    _timelb.frame = cellModel.timeFrame;
    NSDate *inDate = [NSDate dateWithTimeIntervalSince1970:[cellModel.attachComment.intime doubleValue]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[cellModel.attachComment.curr_time doubleValue]];
//    NSDate *nowDate = [PublicFunction getNowDateFromatAnDate:date];
//    NSDate *realDate = [date dateByAddingTimeInterval:60*6*8];
    _timelb.text = [inDate dateTimeAgoByDate:date];

//    NSString *showtimeNew = [formatter1 stringFromDate:date];
//    _timelb.text = showtimeNew;
    
    _namelb.frame = cellModel.nameFrame;
    _namelb.text = cellModel.attachComment.user_name;
    if (cellModel.whoComment == My_Comment) {
        _namelb.textAlignment = NSTextAlignmentRight;
        
        _arrowImgV.frame = cellModel.arrowFrame;
        _arrowImgV.image = [UIImage imageNamed:@"comment_arrow_right"];
        _backView.frame = cellModel.textBackFrame;
        _backView.backgroundColor = [UIColor whiteColor];
        
        _contentlb.frame = cellModel.textFrame;
        _contentlb.text = cellModel.attachComment.content;
        _contentlb.textColor = [UIColor blackColor];
    }else if (cellModel.whoComment == Other_Comment){
        _namelb.textAlignment = NSTextAlignmentLeft;
        
        _arrowImgV.frame = cellModel.arrowFrame;
        _arrowImgV.image = [UIImage imageNamed:@"comment_arrow_left"];
        
        _backView.frame = cellModel.textBackFrame;
        _backView.backgroundColor = RGB(93, 169, 208);

        _contentlb.frame = cellModel.textFrame;
        _contentlb.text = cellModel.attachComment.content;
        _contentlb.textColor = [UIColor whiteColor];
        
        
    }
}

@end
