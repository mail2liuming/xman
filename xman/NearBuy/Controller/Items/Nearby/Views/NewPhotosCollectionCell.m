//
//  NewPhotosCollectionCell.m
//  NearBuy
//
//  Created by URoad_MP on 15/11/26.
//  Copyright © 2015年 nearbuy. All rights reserved.
//

#import "NewPhotosCollectionCell.h"

@implementation NewPhotosCollectionCell
{
    IBOutlet UIImageView *imageV;
    UIView *overlayView;
    IBOutlet UIButton *deleteBtn;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)hideDeleteButton{
    [deleteBtn setHidden:YES];
}
- (void)showDeleteButton{
    [deleteBtn setHidden:NO];
}

- (IBAction)delectAction:(id)sender {
    if (self.removeItemBlock) {
        self.removeItemBlock();
    }
}

- (void)addOverlayView{
    if (!overlayView) {
        overlayView = [[UIView alloc]initWithFrame:self.bounds];
        overlayView.backgroundColor = [UIColor blackColor];
        overlayView.alpha = 0.3;
    }
    [self addSubview:overlayView];
}

- (void)removeOverlayView{
    if (overlayView.superview) {
        [overlayView removeFromSuperview];
    }
}

- (void)setAttachImage:(UIImage *)attachImage{
    _attachImage = attachImage;
    imageV.image = _attachImage;
}

@end
