//
//  ItemNewAdController.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/21.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "ItemNewAdController.h"
#import "NewAdPhotosCell.h"
#import "NewAdContactCell.h"
#import "NewAdCategoryCell.h"
#import "NewAdPriceCell.h"
#import "NewAdTitleDescCell.h"
#import "CountrySelectView.h"
#import "EtyAdCategory.h"
#import "NewAdFooterView.h"
#import "EtyAd.h"
//#import "NewAdPhotosCollectionCell.h"
@interface ItemNewAdController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,NewAdFooterViewDelegate,CTAssetsPickerControllerDelegate>
@property (strong, nonatomic) UITableView *table;
@property (nonatomic,strong)UIImagePickerController *imgPicker;
@property (nonatomic,strong)UIActionSheet *photoSourceSheet;
@property (nonatomic,strong)NSMutableArray *photos;
@property (nonatomic,strong)CountrySelectView *categorySelectView;
@property (nonatomic,strong)UIView *overlayView;
@property (nonatomic,strong)NSString *category;
@property (nonatomic,strong)NewAdFooterView *footerView;
@property (nonatomic,strong)NSString *contactPhone;
@property (nonatomic,strong)NSString*adTitle;
@property (nonatomic,strong)NSString *adDesc;
@property (nonatomic,strong)NSString *adPrice;
@property (nonatomic,strong)EtyAd*attachAd;
@property (nonatomic,assign)BOOL editMode;
@property (nonatomic,strong)NSArray*categorys;

@property (nonatomic, copy) NSArray *assets;

@property (nonatomic,strong)CTAssetsPickerController *libraryPicker;
//@property (nonatomic,strong)NewAdPhotosCollectionCell *imageCell;

@end

@implementation ItemNewAdController
{
    BOOL isPriceEdit;
    BOOL registerKeyboard;
    NewAdContactCell *cellphone;
}
@synthesize imgPicker = _imgPicker;
@synthesize categorySelectView = _categorySelectView;
@synthesize categorys = _categorys;
@synthesize libraryPicker = _libraryPicker;
- (CTAssetsPickerController *)libraryPicker{
    if (!_libraryPicker) {
        _libraryPicker = [[CTAssetsPickerController alloc]init];
        _libraryPicker.assetsFilter         = [ALAssetsFilter allPhotos];
        _libraryPicker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
        _libraryPicker.delegate             = self;
        
        
    }
    return _libraryPicker;
}

- (NSArray*)categorys{
    if (!_categorys) {
        NSMutableArray *datas = [NSMutableArray arrayWithArray:[EtyAdCategory getAdCategoryNames]];
//        [datas removeObjectAtIndex:0];
        _categorys = datas;
    }
    return _categorys;
}

- (UIImagePickerController*)imgPicker{
    if (!_imgPicker) {
        _imgPicker = [[UIImagePickerController alloc]init];
        _imgPicker.delegate = self;
    }
    return _imgPicker;
}
- (CountrySelectView*)categorySelectView{
    if (!_categorySelectView) {
        NSMutableArray *datas = [NSMutableArray arrayWithArray:[EtyAdCategory getAdCategoryNames]];
//        [datas removeObjectAtIndex:0];
        self.categorys = datas;
        __weak typeof(self) weakself = self;
        _categorySelectView = [[CountrySelectView alloc]initWithDatas:datas];
        _categorySelectView.frame = CGRectMake(0, UIScreenHeight, UIScreenWidth, 269);
        _categorySelectView.confirmBlock=^(NSString *category){
            weakself.category = category;
            [weakself.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakself dismissCategoryView];
        };
        _categorySelectView.dismissBlock=^{
            [weakself dismissCategoryView];
        };
        
    }
    return _categorySelectView;
}
- (void)showCategoryView{
    
    [self.view addSubview:self.categorySelectView];
    [self.view insertSubview:self.overlayView belowSubview:self.categorySelectView];
    [UIView animateWithDuration:0.3 animations:^{
        self.categorySelectView.top = UIScreenHeight - 269;
        self.overlayView.alpha = 0.4;
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)dismissCategoryView{
    [UIView animateWithDuration:0.3 animations:^{
        self.categorySelectView.top = UIScreenHeight;
        self.overlayView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.overlayView removeFromSuperview];
        [self.categorySelectView removeFromSuperview];
    }];
}


- (id)initController{
    self = [super initWithTitle:@"New Listing"];
    if (self) {
        self.editMode = NO;
        self.contactPhone = [AccountManager sharedInstance].currentUser.phone;
        self.photos =[NSMutableArray array];
        self.view.backgroundColor = RGB(237, 237, 237);
        
        UITableViewController *tbc = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
        self.table =tbc.tableView;
        self.table.frame = CGRectMake(0, 64, self.view.size.width, self.view.frame.size.height - 64);

        self.table.delegate = self;
        self.table.dataSource = self;
        self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.table.tableFooterView = [[UIView alloc]init];
        self.table.backgroundColor = RGB(237, 237, 237);
        self.table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.photoSourceSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Photograph album", nil];
//        _footerView = LOAD_XIB_CLASS(NewAdFooterView);
//        _footerView.frame = CGRectMake(0, 0, UIScreenWidth, 100);
//        _footerView.delegate = self;
//        self.table.tableFooterView = _footerView;
//        _footerView.height = 100;
        [self.view addSubview:self.table];
        [self addChildViewController:tbc];
        self.automaticallyAdjustsScrollViewInsets = YES;

    }
    return self;
}

- (id)initControllerWithEditMode:(EtyAd *)ad withPhotos:(NSArray *)photos{
    self = [super initWithTitle:@"Edit"];
    if (self) {
        self.editMode = YES;
        self.attachAd = ad;
        self.contactPhone = ad.phone;
        self.adDesc = ad.describe;
        self.adTitle = ad.title;
        self.adPrice = ad.price;
        if ([ad.category integerValue]>self.categorys.count) {
            self.category = self.categorys[0];
        }else{
            self.category = [self.categorys objectAtIndex:[ad.category integerValue]-1];
        }
        
        self.photos =[NSMutableArray arrayWithArray:photos];
        
        self.view.backgroundColor = RGB(237, 237, 237);
        UITableViewController *tbc = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
        self.table =tbc.tableView;
        self.table.frame = CGRectMake(0, 64, self.view.size.width, self.view.frame.size.height - 64);
        self.table.delegate = self;
        self.table.dataSource = self;
        self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.table.tableFooterView = [[UIView alloc]init];
        self.table.backgroundColor = RGB(237, 237, 237);
        self.table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.photoSourceSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Photo album", nil];
        [self.view addSubview:self.table];
        [self addChildViewController:tbc];
        self.automaticallyAdjustsScrollViewInsets = YES;

    }
    return self;
}

- (void)buttonActionConfirm:(BOOL)confirm{
    if (confirm) {
        if (self.editMode) {
            [self editCopletedAction];
        }else{
            [self confirmAction];
        }
    }else{
        POP_CONTROLLER;
    }
}

- (void)editCopletedAction{
    EtyAd *request = [[EtyAd alloc]init];
    request.ad_id = self.attachAd.ad_id;
    _contactPhone = cellphone.phone;
    if (![PublicFunction checkStringIsValid:_category]) {
        [LZAlertView showMessage:@"Please select category" byStyle:Alert_Info];
        return;
    }
    if (![PublicFunction checkStringIsValid:_contactPhone]) {
        [LZAlertView showMessage:@"Please enter your contact" byStyle:Alert_Info];
        return;
    }
    if (![PublicFunction checkStringIsValid:self.adTitle]) {
        [LZAlertView showMessage:@"Please enter ad title" byStyle:Alert_Info];
        return;
    }
//    if (![PublicFunction checkStringIsValid:self.adDesc]) {
//        [LZAlertView showMessage:@"Please enter ad description" byStyle:Alert_Info];
//        return;
//    }
    
    if (![PublicFunction checkStringIsValid:self.adPrice]) {
        [LZAlertView showMessage:@"Oops! Enter the sale price please" byStyle:Alert_Info];
        return;
    }
    
    __block NSString *pic1 = [[NSString alloc]init];
    __block NSString *pic2 = [[NSString alloc]init];
    __block NSString *pic3 = [[NSString alloc]init];
    __block NSString *pic4 = [[NSString alloc]init];
    __block NSString *pic5 = [[NSString alloc]init];
    
    [self.photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImage *img = obj;
        if (idx == 0) {
            pic1 = [img base64Value];
        }else if (idx == 1){
            pic2 = [img base64Value];
        }else if (idx == 2){
            pic3 = [img base64Value];
        }else if (idx == 3){
            pic4 = [img base64Value];
        }else if (idx == 4){
            pic5 = [img base64Value];
        }
    }];
    
    request.category = [NSString stringWithFormat:@"%ld",(long)[self.categorys indexOfObject:_category]+1];
    request.price = self.adPrice;
    request.phone = _contactPhone;
    request.title = self.adTitle;
    request.describe = self.adDesc == nil?@"":self.adDesc;
    request.pic1= pic1;
    request.pic2= pic2;
    request.pic3= pic3;
    request.pic4= pic4;
    request.pic5= pic5;
    request.lat = [NSString stringWithFormat:@"%0.6f",[LocationManager sharedInstance].currentLocation.coordinate.latitude];
    request.lng = [NSString stringWithFormat:@"%0.6f",[LocationManager sharedInstance].currentLocation.coordinate.longitude];
    
    [LZAlertControl showAlertWithTitle:@"" withRemark:@"Confirm your listing" withBlock:^(BOOL confirm) {
        if (confirm) {
            SHOW_LOADING_MESSAGE(@"confirm", self.view);
            
            [EtyAd editAdByRequest:request withFinish:^(id result, BOOL success) {
                if (success) {
                    if ([result isKindOfClass:[NSDictionary class]]) {
                        
                        NSString *pic1 = [result valueForKey:@"pic1"];
                        NSString *pic2 = [result valueForKey:@"pic2"];
                        NSString *pic3 = [result valueForKey:@"pic3"];
                        NSString *pic4 = [result valueForKey:@"pic4"];
                        NSString *pic5 = [result valueForKey:@"pic5"];
                        
                        self.attachAd.pic1 = pic1;
                        self.attachAd.pic2 =pic2;
                        self.attachAd.pic3 = pic3;
                        self.attachAd.pic4 =pic4;
                        self.attachAd.pic5 = pic5;
                        self.attachAd.describe = request.describe;
                        self.attachAd.phone = _contactPhone;
                        if (self.reloadUIBlock) {
                            self.reloadUIBlock();
                        }
                    }
                    POP_CONTROLLER;

                    [LZAlertView showMessage:@"Your listing has been updated" byStyle:Alert_Success];
                    
                }else{
                    [LZAlertView showMessage:result byStyle:Alert_Error];
                }
                DISMISS_LOADING;
            }];

        }
    }];
    
    
}

- (void)confirmAction{
    
    EtyAd *request = [[EtyAd alloc]init];
    
    if (![PublicFunction checkStringIsValid:_category]) {
        [LZAlertView showMessage:@"Please select category" byStyle:Alert_Info];
        return;
    }
    if (![PublicFunction checkStringIsValid:_contactPhone]) {
        [LZAlertView showMessage:@"Please enter your contact" byStyle:Alert_Info];
        return;
    }
    if (![PublicFunction checkStringIsValid:self.adTitle]) {
        [LZAlertView showMessage:@"Please enter ad title" byStyle:Alert_Info];
        return;
    }
//    if (![PublicFunction checkStringIsValid:self.adDesc]) {
//        [LZAlertView showMessage:@"Please enter ad description" byStyle:Alert_Info];
//        return;
//    }

    if (![PublicFunction checkStringIsValid:self.adPrice]) {
        [LZAlertView showMessage:@"Oops! Enter the sale price please" byStyle:Alert_Info];
        return;
    }
    
    __block NSString *pic1 = [[NSString alloc]init];
    __block NSString *pic2 = [[NSString alloc]init];
    __block NSString *pic3 = [[NSString alloc]init];
    __block NSString *pic4 = [[NSString alloc]init];
    __block NSString *pic5 = [[NSString alloc]init];
    
    [self.photos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImage *img = obj;
        if (idx == 0) {
            pic1 = [img base64Value];
        }else if (idx == 1){
            pic2 = [img base64Value];
        }else if (idx == 2){
            pic3 = [img base64Value];
        }else if (idx == 3){
            pic4 = [img base64Value];
        }else if (idx == 4){
            pic5 = [img base64Value];
        }
    }];
    
    request.category = [NSString stringWithFormat:@"%ld",(long)[self.categorys indexOfObject:_category]+1];
    request.price = self.adPrice;
    request.phone = _contactPhone;
    request.title = self.adTitle;
    request.describe = self.adDesc == nil?@"":self.adDesc;
    request.pic1= pic1;
    request.pic2= pic2;
    request.pic3= pic3;
    request.pic4= pic4;
    request.pic5= pic5;
    request.lat = [NSString stringWithFormat:@"%0.6f",[LocationManager sharedInstance].currentLocation.coordinate.latitude];
    request.lng = [NSString stringWithFormat:@"%0.6f",[LocationManager sharedInstance].currentLocation.coordinate.longitude];
    

    [LZAlertControl showAlertWithTitle:@"" withRemark:@"Confirm your listing" withBlock:^(BOOL confirm) {
        if (confirm) {
            SHOW_LOADING_MESSAGE(@"confirm", self.view);
            
            [EtyAd addNewAdByRequest:request withFinish:^(id result, BOOL success) {
                if (success) {
                    POP_CONTROLLER;
                    if (self.reloadDataBlock) {
                        self.reloadDataBlock(request);
                    }
                    [LZAlertView showMessage:@"Your listing is live now" byStyle:Alert_Success];
                    
                }else{
                    [LZAlertView showMessage:result byStyle:Alert_Error];
                }
                DISMISS_LOADING;
            }];

        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.overlayView =[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.alpha = 0.0;
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissCategoryView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.overlayView addGestureRecognizer:tap];


}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _footerView = LOAD_XIB_CLASS(NewAdFooterView);
    _footerView.frame = CGRectMake(0, 0, UIScreenWidth, 100);
    _footerView.delegate = self;
    self.table.tableFooterView = _footerView;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            if (self.photos.count>0) {
                return 140;
            }else{
                return 40;
            }
        }

            break;
        case 1:
            return 73;
            break;
        case 2:
            return 73;
            break;
        case 3:
            return 170;
            break;
        case 4:
            return 77;
            break;
        default:
            break;
    }
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
//        _imageCell = LOAD_XIB_CLASS(NewAdPhotosCollectionCell);
//        _imageCell.addNewsImageAction=^{
//            [self.photoSourceSheet showInView:self.view];
//        };
//        return _imageCell;
        
        NewAdPhotosCell *cell = LOAD_XIB_CLASS(NewAdPhotosCell);
        cell.addNewPhotoBlock=^{
            [self.photoSourceSheet showInView:self.view];
        };
        cell.deletePhotoReloadBlock=^(NSInteger index){
            [self.photos removeObjectAtIndex:index];
            [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [cell loadPhotos:self.photos];
        return cell;
    }else if (indexPath.row ==1){
        NewAdCategoryCell *cell = LOAD_XIB_CLASS(NewAdCategoryCell);
        [cell setCategory:_category];
        return cell;
    }else if (indexPath.row == 2){
        cellphone = LOAD_XIB_CLASS(NewAdContactCell);
        cellphone.phone = self.contactPhone;
        return cellphone;
    }else if (indexPath.row == 3){
        NewAdTitleDescCell *cell = LOAD_XIB_CLASS(NewAdTitleDescCell);
        [cell setAdTitle:self.adTitle];
        [cell setAdDesc:self.adDesc];
        cell.outputDescBlock=^(NSString *desc){
            self.adDesc = desc;
        };
        cell.outputTitleBlock=^(NSString *title){
            self.adTitle = title;
        };
        cell.TextViewBeginEditBlock=^(BOOL keyboard){
            if (keyboard) {
//                [self.table setContentOffset:CGPointMake(0, 110) animated:YES];
            }else{
//                [self.table setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        };
        return cell;
    }else if (indexPath.row == 4){
        NewAdPriceCell *cell = LOAD_XIB_CLASS(NewAdPriceCell);
        if (self.adPrice) {
            cell.price = self.adPrice;
        }

        cell.outputPriceBlock=^(NSString *price){
            self.adPrice = price;
        };
        cell.TextFieldBeginEditBlock=^(BOOL isshow){
            if (isshow) {
                isPriceEdit = YES;
//                [self.table setContentOffset:CGPointMake(0, 300) animated:YES];
            }else{
                isPriceEdit = NO;
//                [self.table setContentOffset:CGPointMake(0, 0) animated:YES];
            }

        };
        return cell;
    }
    return nil;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self.view endEditing:YES];
        [self showCategoryView];
        
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
- (void)viewWillAppear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    if (!registerKeyboard) {
    [self registerKeyboardNotification];
        registerKeyboard = YES;
    }
    [super viewWillAppear:animated];
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //camara
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [MAIN_NAVI_CONTROLLER presentViewController:self.imgPicker animated:YES completion:nil];

    }
    else if (buttonIndex == 1){
        
        self.libraryPicker.selectedAssets = [[NSMutableArray alloc]init];
        
        [MAIN_NAVI_CONTROLLER presentViewController:self.libraryPicker animated:YES completion:nil];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

//        self.imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        [MAIN_NAVI_CONTROLLER presentViewController:self.imgPicker animated:YES completion:nil];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (img) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage* pickedImage = [image limitImgWithLen:800];
//        [_imageCell addNewsImage:pickedImage];

        
        [self.photos addObject:pickedImage];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

}


//- (void)keyboardWillShow:(NSNotification *)sender {
////    if (isPriceEdit) {
////        return;
////    }
//    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    CGFloat height = UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]) ? kbSize.height : kbSize.width;
//    if (SYSTEM_VERSION_LATER_THAN_8_0) height = kbSize.height-20;
//    
//    [UIView animateWithDuration:duration animations:^{
//        UIEdgeInsets edgeInsets = [[self table] contentInset];
//        edgeInsets.bottom = height;
//        [[self table] setContentInset:edgeInsets];
//        edgeInsets = [[self table] scrollIndicatorInsets];
//        edgeInsets.bottom = height;
//        [[self table] setScrollIndicatorInsets:edgeInsets];
//    }];
//}
//
//- (void)keyboardWillHide:(NSNotification *)sender {
//    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    [UIView animateWithDuration:duration animations:^{
//        UIEdgeInsets edgeInsets = [[self table] contentInset];
//        edgeInsets.bottom = 0;
//        [[self table] setContentInset:edgeInsets];
//        edgeInsets = [[self table] scrollIndicatorInsets];
//        edgeInsets.bottom = 0;
//        [[self table] setScrollIndicatorInsets:edgeInsets];
//    }];
//}

//- (void)keyboardWillShow:(NSNotification *)notice{
//    
//#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_3_2
//    NSValue *keyboardBoundsValue = [[notice userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
//#else
//    NSValue *keyboardBoundsValue = [[notice userInfo] objectForKey:UIKeyboardBoundsUserInfoKey];
//#endif
//    CGRect keyboardEndRect = [keyboardBoundsValue CGRectValue];
//    CGFloat keyboardHeight = keyboardEndRect.size.height;
//    [UIView animateWithDuration:0.4 animations:^{
//
//        
//    }];
//}
//- (void)keyboardWillHide:(NSNotification *)notice{
//    [UIView animateWithDuration:0.4 animations:^{
//
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//}



#pragma mark - Assets Picker Delegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ALAsset *asset = obj;
        ALAssetRepresentation *repr = asset.defaultRepresentation;
        UIImage *img = [UIImage imageWithCGImage:repr.fullScreenImage];
//        [_imageCell addNewsImage:img];
        [self.photos addObject:img];
    }];
    [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
{
    // Enable video clips if they are at least 5s
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {
        NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        return lround(duration) >= 5;
    }
    else
    {
        return YES;
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    NSInteger selectcount = picker.selectedAssets.count;
    NSInteger canAddCount = 6-self.photos.count;
    
    if (selectcount >= canAddCount)
    {
        NSString*count = [NSString stringWithFormat:@"You can pick %ld photos",(long)canAddCount];
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Alert"
                                   message:count
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"Confirm", nil];
        
        [alertView show];
    }
    
    if (!asset.defaultRepresentation)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"Alert"
                                   message:@"No Image Data"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    
    return (picker.selectedAssets.count < (6-self.photos.count) && asset.defaultRepresentation != nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
