//
//  SignupPhoneNumberViewController.m
//  xman
//
//  Created by Liu Ming on 28/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "SignupPhoneNumberViewController.h"
#import "SignupPasswordViewController.h"

@interface SignupPhoneNumberViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userPhoneNumField;

@end

@implementation SignupPhoneNumberViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.title = @"Sing up";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self initKeyboradPanel];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.userPhoneNumField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldDidBeginEditing:(id)sender {
    self.activeField = sender;
}
- (IBAction)textFieldDidEndEditing:(id)sender {
    self.activeField = nil;
}

- (IBAction)textFileldReturn:(id)sender {
    [self nextScreen];
}

-(void) nextScreen{
   [self performSegueWithIdentifier:@"ShowSignupPasswordSegue" sender:self];
}
- (IBAction)tabOutside:(id)sender {
    if(self.activeField){
        [self.activeField resignFirstResponder];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController* vc = segue.destinationViewController;
    if ([vc isMemberOfClass: [SignupPasswordViewController class] ]){
        SignupPasswordViewController* svc = (SignupPasswordViewController*)vc;
        svc.userPhoneNum = [self.userPhoneNumField text];
    }
}

-(void)initKeyboradPanel{
    [self.keyboardPanel.leftButton setHidden:true];
    [self.keyboardPanel.middleButton setHidden:true];
    [self.keyboardPanel.rightButton setTitle:@"password" forState:UIControlStateNormal];
    
    [self.keyboardPanel.rightButton addTarget:self action:@selector(nextScreen) forControlEvents:UIControlEventTouchUpInside];
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
