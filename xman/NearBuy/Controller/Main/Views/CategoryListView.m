//
//  CategoryListView.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/17.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "CategoryListView.h"
#import "EtyAdCategory.h"
#import "CategoryCell.h"
#import "OrderByCell.h"
@interface CategoryListView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSArray *categoryData;
@property (nonatomic,strong)NSArray *orderByData;
@property (nonatomic,strong)NSIndexPath *orderSelectIndex;
@property (nonatomic,strong)NSIndexPath *categorySelectIndex;
@end

@implementation CategoryListView
{
    
}
- (id)initView{
    self = [super initWithFrame:CGRectMake(0, 20, UIScreenWidth - 80, UIScreenHeight  - 20)];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.orderSelectIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        self.categorySelectIndex = [NSIndexPath indexPathForRow:0 inSection:1];
        self.categoryData = [EtyAdCategory sharedInstance].categorys;
        
        EtyOrderBy *order1 = [[EtyOrderBy alloc]init];
        order1.name = @"Latest listings";
        order1.orderDesc = @"latest";
        EtyOrderBy *order2 = [[EtyOrderBy alloc]init];
        order2.name = @"Nearest listings";
        order2.orderDesc = @"nearest";
        self.orderByData = @[order1,order2];
        self.table = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        self.table.delegate = self;
        self.table.dataSource = self;
        self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.table registerClass:[CategoryCell class] forCellReuseIdentifier:@"CategoryCellIdentifier"];
        [self.table registerClass:[OrderByCell class] forCellReuseIdentifier:@"OrderByCellIdentifier"];
        [self addSubview:self.table];
        
        UISwipeGestureRecognizer *recognizer;

        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self addGestureRecognizer:recognizer];

        
        
    }
    return self;
}
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)sender{
    if(sender.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        NSLog(@"swipe left");
        //执行程序
        if (self.hideCategorySelfBlock) {
            self.hideCategorySelfBlock();
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.orderByData.count;
    }
    else{
        return self.categoryData.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        return 44;
//    }else{
//        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//        return cell.frame.size.height;
//    }
//    return 0.;
    return 44;

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *secView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth - 80, 30)];
    secView.backgroundColor = RGB(225, 225, 225);
    if (section == 0) {
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, secView.width - 50, 30)];
        lb.text = @"      Order by";
        lb.font = [UIFont systemFontOfSize:16];
        lb.textColor = [UIColor whiteColor];
        [secView addSubview:lb];
    }else{
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, secView.width, 30)];
        lb.textColor = [UIColor whiteColor];
        lb.text = @"      Categories";
        lb.font = [UIFont systemFontOfSize:16];
        [secView addSubview:lb];
        
    }
    return secView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSIndexPath *currentIndex = indexPath;
    if (currentIndex.section == 0) {
        
        OrderByCell *cell = LOAD_XIB_CLASS(OrderByCell);
        EtyOrderBy *order = _orderByData[indexPath.row];
        cell.nameLb.text = order.name;
        cell.nameLb.textColor = RGB(160, 160, 160);
        cell.nameLb.highlightedTextColor = UI_NAVIBAR_COLOR;
        
        if (currentIndex.row == 0) {
            [cell drawLine];
//            UIImage *img = [UIImage imageNamed:@"OrderByLastestS"];
//            cell.imgV.size = img.size;
            cell.imageView.image = [UIImage imageNamed:@"OrderByLastestS"];
//            cell.imgV.highlightedImage = [UIImage imageNamed:@"OrderByLastestS"];
//            [cell.imgV sizeToFit];
        }else{
//            UIImage *img = [UIImage imageNamed:@"OrderByNearestU"];
//            cell.imgV.size = img.size;
            cell.imageView.image = [UIImage imageNamed:@"OrderByNearestS"];
//            cell.imgV.highlightedImage = [UIImage imageNamed:@"OrderByNearestS"];
//            [cell.imgV sizeToFit];

        }
//        [cell selectHighlightStyle:YES];
        if (_orderSelectIndex.row == currentIndex.row) {
            [cell selectHighlightStyle:YES];
        }else{
            [cell selectHighlightStyle:NO];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (currentIndex.section == 1){
        
        CategoryCell *cell = LOAD_XIB_CLASS(CategoryCell);
        EtyAdCategory *category = _categoryData[indexPath.row];
        [cell setContentEty:category];
        if (_categorySelectIndex.row == currentIndex.row) {
            [cell selectHighlight:YES];
        }else{
            [cell selectHighlight:NO];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        _orderSelectIndex = indexPath;
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        if (_categorySelectIndex == nil) {
            _categorySelectIndex = indexPath;
            [tableView reloadRowsAtIndexPaths:@[_categorySelectIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else if(_categorySelectIndex.row != indexPath.row){
            NSIndexPath *oldSelect = _categorySelectIndex;
            _categorySelectIndex = indexPath;
            [tableView reloadRowsAtIndexPaths:@[_categorySelectIndex,oldSelect] withRowAnimation:UITableViewRowAnimationAutomatic];

        }
    }
    EtyOrderBy *order = _orderByData[_orderSelectIndex.row];
    EtyAdCategory *category = _categoryData[_categorySelectIndex.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectCategory:andOrder:)]) {
        [self.delegate selectCategory:category.categoryId andOrder:order.orderDesc];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
