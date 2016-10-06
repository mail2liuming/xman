//
//  GirlsListViewController.m
//  xman
//
//  Created by Liu Ming on 27/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "GirlsListViewController.h"
#import "CellOfGirlList.h"
@import Firebase;

#import "AddNewGirlViewController.h"

@interface GirlsListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *girlsListView;
@property NSArray* girls;
@property NSDictionary* curGirl;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (nonatomic) FIRDatabaseHandle refHandle;

@end

@implementation GirlsListViewController

-(void)dealloc{
    [[self.ref child:@"members"]removeObserverWithHandle:self.refHandle];
}

-(void)configDatabase{
    self.ref = [[FIRDatabase database]reference];
    self.refHandle = [[self.ref child:@"members"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self.girls = snapshot.value;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self action:@selector(addTapped:)];
    [self.navigationController setNavigationBarHidden:NO];
    [self configDatabase];
}

-(void)addTapped :(id)sender{
    [self performSegueWithIdentifier:@"ShowGirlDetailSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.girls isMemberOfClass:[NSArray class]]){
        return [self.girls count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellOfGirlList *cell = [tableView dequeueReusableCellWithIdentifier:@"CellForGirls" forIndexPath:indexPath];
    if(cell == nil){
        cell = [[CellOfGirlList alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellForGirls"];
    }
    
    // Configure the cell...
    [ cell attachMemberInfo: self.girls[indexPath.row]];
    return cell;
}


//TableView row on click.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.curGirl =self.girls[indexPath.row];
    [self performSegueWithIdentifier:@"ShowGirlDetailSegue" sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AddNewGirlViewController* gvc = [segue destinationViewController];
    if(self.curGirl){
        gvc.girl =[[Member alloc]initFromDictionary:self.curGirl];
    }else{
        gvc.girl = nil;
    }
    
    self.curGirl = nil;
}


@end
