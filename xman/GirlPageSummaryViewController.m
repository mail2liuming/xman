//
//  GirlPageSummaryViewController.m
//  xman
//
//  Created by Liu Ming on 3/10/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "GirlPageSummaryViewController.h"
#import "UIImageView+AFNetworking.h"
#import "PhotoWrapper.h"
@import Firebase;

#define PAGEINDEX_BIO 0
#define PAGEINDEX_CONTACT 7
#define PAGEINDEX_SERVICE 9
#define PAGEINDEX_PICS  11


@interface GirlPageSummaryViewController()



@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@property (weak, nonatomic) IBOutlet UILabel *contactLabel;

@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UIButton *bioEdit;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (weak, nonatomic) IBOutlet UIImageView *imageview2;
@property (weak, nonatomic) IBOutlet UIImageView *imageview3;
@property (weak, nonatomic) IBOutlet UIImageView *imageview4;
@property (weak, nonatomic) IBOutlet UIImageView *imageview5;

@end

@implementation GirlPageSummaryViewController

-(void)viewDidLoad{
    [super viewDidLoad];

    [self.pageDelegate onShow:self.pageIndex title:@"summary"];
    UINavigationItem* nav = [self.pageDelegate getNavigationItem];
    if(nav){
        nav.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitInfo)];
    }
    self.ref = [[FIRDatabase database]reference];
    
    [self attachInfo];
}


-(void)attachInfo{
    //TODO
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:@"--Bio--\n"];
    [array addObject:@"Work name:"];
    [array addObject:self.member.name];
    [array addObject:@"\n"];
    [array addObject:@"Birth:"];
    [array addObject:self.member.birthday];
    [array addObject:@"\n"];
    [array addObject:@"Size:"];
    [array addObject:self.member.size];
    [array addObject:@"\n"];
    [array addObject:@"Height:"];
    [array addObject:self.member.height];
    [array addObject:@"(cm)\n"];
    [array addObject:@"Weight:"];
    [array addObject:self.member.weight];
    [array addObject:@"(kg)\n"];
    [array addObject:@"Eyes:"];
    [array addObject:self.member.eyecolor];
    [array addObject:@"\n"];
    [array addObject:@"Hair:"];
    [array addObject:self.member.haircolor];
    [array addObject:@"\n"];
    
    NSString *str = [array componentsJoinedByString:@""];
    [self.bioLabel setText:str];
    
    [array removeAllObjects];
    [array addObject:@"--Contact Details--\n"];
    [array addObject:@"Mobile:"];
    [array addObject:self.member.phonenum];
    [array addObject:@"\n"];
    [array addObject:@"Allow Txt:"];
    [array addObject:self.member.allowsms];
    [array addObject:@"\n"];
    
    str = [array componentsJoinedByString:@""];
    [self.contactLabel setText:str];
    
    [array removeAllObjects];
    [array addObject:@"--Service and Fees--\n"];
    for (NSString* s in self.member.options){
        [array addObject:s];
        [array addObject:@"\n"];
    }
    
    str = [array componentsJoinedByString:@""];
    [self.serviceLabel setText:str];
    
    if(self.member.pics != nil){
        int count = [self.member.pics count];
        PhotoWrapper* wrapper = nil;
        if(count >0){
            wrapper =self.member.pics[0];
            [self.imageview setImageWithURL:[NSURL URLWithString:wrapper.showImageUrl]];
        }
        if(count >1){
            wrapper =self.member.pics[1];
            [self.imageview2 setImageWithURL:[NSURL URLWithString:wrapper.showImageUrl]];
        }
        if(count >2){
            wrapper =self.member.pics[2];
            [self.imageview3 setImageWithURL:[NSURL URLWithString:wrapper.showImageUrl]];
        }
        if(count >3){
            wrapper =self.member.pics[3];
            [self.imageview4 setImageWithURL:[NSURL URLWithString:wrapper.showImageUrl]];
        }
        if(count >4){
            wrapper =self.member.pics[4];
            [self.imageview5 setImageWithURL:[NSURL URLWithString:wrapper.showImageUrl]];
        }
    }
}


- (IBAction)bioEditTapped:(id)sender {
    [self.pageDelegate gotoPage: PAGEINDEX_BIO];
}
- (IBAction)contactEditTapper:(id)sender {
    [self.pageDelegate gotoPage: PAGEINDEX_CONTACT];
}

- (IBAction)serviceEditTapped:(id)sender {
    [self.pageDelegate gotoPage: PAGEINDEX_SERVICE];
}
- (IBAction)imageEditTapped:(id)sender {
    [self.pageDelegate gotoPage: PAGEINDEX_PICS];
}

-(void)submitInfo{
    NSString* id = [self.appDelegate getUserID];
    if(self.member.uid == nil){
        [[[[self.ref child:id] child:@"members"] childByAutoId]setValue:[self.member toDictionary]];
    }else{
        [[[[self.ref child:id] child:@"members"]child:self.member.uid] setValue:[self.member toDictionary]];
    }
    
    [self.pageDelegate onCancel];
}
@end
