//
//  NewAdPhotosCell.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "NewAdPhotosCell.h"
#import "PhotoView.h"
@interface NewAdPhotosCell()


//@property (nonatomic,strong)UIButton *addPhotoBtn;

@property (strong, nonatomic) IBOutlet UIScrollView *scView;

@property (nonatomic,strong)NSMutableArray *photoViews;


@end

@implementation NewAdPhotosCell

- (void)awakeFromNib {
    self.photoViews =[NSMutableArray array];
//    _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"AddNewPhotoImage"] forState:UIControlStateNormal];
//    _addPhotoBtn.origin = CGPointMake(0, 8);
//    _addPhotoBtn.size = CGSizeMake(105, 75);
//    [_addPhotoBtn addTarget:self action:@selector(addNewPhotoAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.scView addSubview:_addPhotoBtn];
}

- (IBAction)addNewPhotoAction:(id)sender{
    if (self.addNewPhotoBlock) {
        self.addNewPhotoBlock();
    }
}

- (void)loadPhotos:(NSArray *)array{
    if (array.count == 0) {
        return;
    }
    [self.scView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        [view removeFromSuperview];
    }];
    
    __block CGFloat left = 0;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        PhotoView *view = [[PhotoView alloc]initView];
        view.tag = idx;
        view.frame = CGRectMake(left, 0, 113, 83);
        view.imgView.image = obj;
        view.deletePhotoBlock=^(NSInteger index){
            if (self.deletePhotoReloadBlock) {
                self.deletePhotoReloadBlock(index);
            }
        };
        [self.scView addSubview:view];
        [self.photoViews addObject:view];
        left = CGRectGetMaxX(view.frame)+5;
        
    }];
    if (array.count!=5) {
//        _addPhotoBtn.origin = CGPointMake(left, 8);
//        [self.scView addSubview:_addPhotoBtn];
//        left = CGRectGetMaxX(_addPhotoBtn.frame)+5;

    }
    self.scView.contentSize = CGSizeMake(left, self.scView.contentSize.height);
    if (left>UIScreenWidth) {
        [self.scView setContentOffset:CGPointMake(left - UIScreenWidth, 0) animated:NO];
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
