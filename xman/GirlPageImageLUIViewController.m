//
//  GirlPageImageLUIViewController.m
//  xman
//
//  Created by Liu Ming on 5/08/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import <CTAssetsPickerController/CTAssetsPickerController.h>

#import "GirlPageImageLUIViewController.h"
#import "Constants.h"
#import "GirlImageCell.h"
@import Firebase;


@interface GirlPageImageLUIViewController ()

@property (strong,nonatomic)NSMutableArray* imageUrlList;
@property (strong, nonatomic) FIRStorageReference *storageRef;

@property(strong,nonatomic)PhotoWrapper* dummyWrapper;
@end

@implementation GirlPageImageLUIViewController



-(void)viewDidLoad{
    [super viewDidLoad];
    [self.pageDelegate onShow:self.pageIndex title:@"pictures"];
    UINavigationItem* nav = [self.pageDelegate getNavigationItem];
    if(nav){
        nav.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextScreen)];
    }
    
    self.storageRef =[[FIRStorage storage] referenceForURL:@"gs://xman-f20d9.appspot.com"];
    self.dummyWrapper = [[PhotoWrapper alloc]init];
    self.dummyWrapper.imageUrl=nil;
    
    self.imageUrlList = [[NSMutableArray alloc]init];
}



-(void)nextScreen{
    if(self.pageIndex<MAX_PAGES_GIRLS-1){
        [self.pageDelegate goForward];
    }
    else{
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.member.pics = self.imageUrlList;
}

-(void)previousScreen{
    [self.pageDelegate goBack];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return (self.imageUrlList.count +1);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"GirlImageCell";
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSLog(@"row is %ld",(long)indexPath.row);
    GirlImageCell *girlCell = (GirlImageCell*)cell;
    if(indexPath.row == self.imageUrlList.count){
        self.dummyWrapper.index=self.imageUrlList.count;
        girlCell.imageDataWrapper = self.dummyWrapper;
    }else{
        girlCell.imageDataWrapper = self.imageUrlList[indexPath.row];
    }
    girlCell.delegate = self;
    return girlCell;
}

-(void)onDelete:(int)index{
    [self.imageUrlList removeObjectAtIndex:index];
    [self.collectionView reloadData];
}

-(void)onClick:(int)index{
    //this is the "add" click
    if(index == self.imageUrlList.count ){
        //TODO show picker
        [self showPicker];
    }
}

-(void)showPicker{
    // request authorization status
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // init picker
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            
            // set delegate
            picker.delegate = self;
            
            // Optionally present picker as a form sheet on iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;
            
            // present picker
            [self presentViewController:picker animated:YES completion:nil];
        });
    }];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    // assets contains PHAsset objects.
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAsset *asset = obj;
        
        
        [asset requestContentEditingInputWithOptions:nil
                                   completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
                                       NSURL *imageFile = contentEditingInput.fullSizeImageURL;
                                       NSString *filePath = [NSString stringWithFormat:@"%@/%lld",
                                                             [FIRAuth auth].currentUser.uid,
                                                             (long long)([[NSDate date] timeIntervalSince1970] * 1000.0)];
                                       [[_storageRef child:filePath]
                                        putFile:imageFile metadata:nil
                                        completion:^(FIRStorageMetadata *metadata, NSError *error) {
                                            if (error) {
                                                NSLog(@"Error uploading: %@", error);
                                                return;
                                            }
                                            PhotoWrapper *wrapper = [[PhotoWrapper alloc]init];
                                            wrapper.index = self.imageUrlList.count;
                                            wrapper.imageUrl =metadata.downloadURL.absoluteString;
                                            NSLog(@"add new index %d",wrapper.index);
                                            [self.imageUrlList addObject:wrapper];
                                            [self.collectionView reloadData];
                                        }
                                        ];
                                   }];
        
    }];
//    [self.collectionView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}



- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
{
    NSInteger selectcount = picker.selectedAssets.count;
    NSInteger canAddCount = 9-self.imageUrlList.count;
    
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
    
    return (picker.selectedAssets.count < (9-self.imageUrlList.count));
}

@end
