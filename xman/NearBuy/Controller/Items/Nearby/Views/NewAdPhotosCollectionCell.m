//
//  NewAdPhotosCollectionCell.m
//  NearBuy
//
//  Created by URoad_MP on 15/11/26.
//  Copyright © 2015年 nearbuy. All rights reserved.
//

#import "NewAdPhotosCollectionCell.h"
#import "NewPhotosCollectionCell.h"
@interface NewAdPhotosCollectionCell()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray *imgs;
@property (nonatomic,strong)UIImage *holdImage;
@end

static NSString * const iden = @"NewPhotosCollectionCellIdentifier";

@implementation NewAdPhotosCollectionCell
{
    BOOL hasHoldImage;
}
- (void)awakeFromNib {
    hasHoldImage =YES;
    _imgs = [NSMutableArray array];
    _holdImage = [UIImage imageNamed:@"AddNewPhotoImage"];
    [_imgs addObject:_holdImage];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(113, 83);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.collectionViewLayout = layout;
    [_collectionView registerNib:[UINib nibWithNibName:@"NewPhotosCollectionCell" bundle:nil] forCellWithReuseIdentifier:iden];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    longPress.delegate = self;
    [_collectionView addGestureRecognizer:longPress];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender{
    static NSIndexPath  *sourceIndexPath = nil;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:[sender locationInView:_collectionView]];
            NewPhotosCollectionCell *cell = (NewPhotosCollectionCell*)[_collectionView cellForItemAtIndexPath:indexPath];
            sourceIndexPath = indexPath;
            [cell addOverlayView];
            
        }
            break;
        case UIGestureRecognizerStateChanged:{
            NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:[sender locationInView:_collectionView]];
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                [_imgs exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [_collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:[sender locationInView:_collectionView]];
            NewPhotosCollectionCell *cell = (NewPhotosCollectionCell*)[_collectionView cellForItemAtIndexPath:indexPath];
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                [_imgs exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [_collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                [_collectionView reloadData];
            }
            [cell removeOverlayView];
            
        }
            break;
            
        default:
            break;
    }
}
- (NSArray*)images{
    if (hasHoldImage) {
        [_imgs removeLastObject];
        return _imgs;
    }else{
        return _imgs;
    }
    return nil;
}

- (NSInteger)canAddNewPhoto{
    if (hasHoldImage) {
        return 5 - ([_imgs count]-1);
    }else{
        return 0;
    }
}

- (void)addNewsImage:(UIImage *)image{
//    [_imgs addObject:image];
    if (_imgs.count==5) {
        [_imgs removeLastObject];
        [_imgs addObject:image];
        hasHoldImage = NO;
    }else{
        [_imgs insertObject:image atIndex:_imgs.count-1];
        hasHoldImage = YES;
    }
    [_collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewPhotosCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    UIImage *img = _imgs[indexPath.row];

    cell.attachImage = img;
    if (img == _holdImage) {
        [cell hideDeleteButton];
    }else{
        [cell showDeleteButton];
    }
    cell.removeItemBlock=^{
        [_imgs removeObjectAtIndex:indexPath.row];
        if (_imgs.count == 4 && ![_imgs containsObject:_holdImage]) {
            [_imgs addObject:_holdImage];
            hasHoldImage = YES;
        }
        [collectionView reloadData];
    };
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imgs.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _imgs.count-1) {
        //最后一个
        if (self.addNewsImageAction) {
            self.addNewsImageAction();
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
