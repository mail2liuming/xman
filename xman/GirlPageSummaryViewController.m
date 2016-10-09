//
//  GirlPageSummaryViewController.m
//  xman
//
//  Created by Liu Ming on 3/10/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "GirlPageSummaryViewController.h"
@import Firebase;

#define PAGEINDEX_BIO 0
#define PAGEINDEX_CONTACT 7
#define PAGEINDEX_SERVICE 10
#define PAGEINDEX_PICS  11


@interface GirlPageSummaryViewController()



@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@property (weak, nonatomic) IBOutlet UILabel *contactLabel;

@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UIButton *bioEdit;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;

@property (strong, nonatomic) FIRDatabaseReference *ref;


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
    [array addObject:@"==Bio\n"];
    [array addObject:@"Name:"];
    [array addObject:self.member.name];
    [array addObject:@"\n"];
    
    NSString *str = [array componentsJoinedByString:@""];
    [self.bioLabel setText:str];
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
