//
//  CountrySelectView.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/19.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "CountrySelectView.h"
#import "DBManager.h"
@interface CountrySelectView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIPickerView *pickerVie;
@property (nonatomic,strong)NSArray *countryNames;
@property (nonatomic,strong)NSString *selectName;
@end

@implementation CountrySelectView

- (id)initWithDatas:(NSArray *)datas{
    self = LOAD_XIB_CLASS(CountrySelectView);
    if (self) {
        self.countryNames = datas;
        self.selectName = datas[0];
        self.pickerVie.delegate = self;
        self.pickerVie.dataSource = self;
    }
    return self;
}
- (IBAction)confirmAction:(id)sender {
    if (self.confirmBlock) {
        self.confirmBlock(self.selectName);
    }
}
- (IBAction)dismissAction:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.countryNames.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.countryNames[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *string = self.countryNames[row];
    self.selectName = string;
}

@end
