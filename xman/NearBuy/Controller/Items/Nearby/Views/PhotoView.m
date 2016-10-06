//
//  PhotoView.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "PhotoView.h"

@implementation PhotoView

- (id)initView{
    self = LOAD_XIB_CLASS(PhotoView);
    if (self) {
        
    }
    return self;
}
- (IBAction)deleteAction:(id)sender {
    if (self.deletePhotoBlock) {
        self.deletePhotoBlock(self.tag);
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.borderView.layer.borderColor = UI_NAVIBAR_COLOR.CGColor;
    self.borderView.layer.borderWidth = 3.0;
}
@end
