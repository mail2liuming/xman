//
//  SignupPasswordViewController.m
//  xman
//
//  Created by Liu Ming on 28/07/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "SignupPasswordViewController.h"
#import "User.h"
@import Firebase;

@interface SignupPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userPasswordField;
@end

@implementation SignupPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.title = @"Sing up";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    // Do any additional setup after loading the view.
    [self initKeyboradPanel];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.userPasswordField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)textBeginEditing:(id)sender {
    self.activeField= sender;
}

- (IBAction)textEndEditing:(id)sender {
    self.activeField = nil;
}


- (IBAction)textDoneEditing:(id)sender {
    [self requestSignup];
}

- (IBAction)tapOutside:(id)sender {
    if(self.activeField){
        [self.activeField resignFirstResponder];
    }
}

-(void) requestSignup{
    [self.activeField resignFirstResponder];
    
    [[FIRAuth auth] signInWithEmail:self.userPhoneNum password:self.userPasswordField.text  completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if(error){
            [[FIRAuth auth] createUserWithEmail:self.userPhoneNum password:self.userPasswordField.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                if(error){
                    //TODO
                    NSLog(@"%@",error);
                }
                else{
                    [self loginSucceedWithUser:user];
                }
            }];
        }else{
            [self loginSucceedWithUser:user];
        }
    }];
}

-(void)loginSucceedWithUser: (FIRUser*) user{
    User* currentUser = [[User alloc] initWithUserId:user.uid UserPWD:@"" UserEmail:user.email];
    [self.appDelegate saveLoginUser:currentUser];
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *obj = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GirlsListNavViewController"];
    
    [self.navigationController presentViewController:obj animated:YES completion:nil];
}

-(void)initKeyboradPanel{
    [self.keyboardPanel.leftButton setHidden:false];
    [self.keyboardPanel.middleButton setHidden:true];
    [self.keyboardPanel.rightButton setTitle:@"finish" forState:UIControlStateNormal];
    
    [self.keyboardPanel.leftButton addTarget:self action:@selector(goBackViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboardPanel.rightButton addTarget:self action:@selector(requestSignup) forControlEvents:UIControlEventTouchUpInside];
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
