//
//  HomeSettingView.m
//  NearBuy
//
//  Created by URoad_MP on 15/6/19.
//  Copyright (c) 2015年 nearbuy. All rights reserved.
//

#import "HomeSettingView.h"
#import "AccountManager.h"
#import "UserLoginController.h"
#import "AboutController.h"
#import "UserRegisterFirstController.h"
#import "ChangePasswordController.h"
#import "FeedbackController.h"
#import "SettingCell.h"
@interface HomeSettingView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)NSArray *datas;
@property (nonatomic,strong)NSArray *imgs;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UILabel *nameLb;
@property (nonatomic,strong)UILabel *phoneLb;
@end

@implementation HomeSettingView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.table = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        self.table.backgroundColor = RGB(246, 246, 246);
        self.table.delegate = self;
        self.table.dataSource = self;
        [self addSubview:self.table];
        self.backgroundColor = [UIColor redColor];
        self.table.tableFooterView = [[UIView alloc]init];
        if (SYSTEM_VERSION_LATER_THAN_7_0) {
            self.table.separatorInset = UIEdgeInsetsZero;
        }
        if (SYSTEM_VERSION_LATER_THAN_8_0) {
            self.table.layoutMargins = UIEdgeInsetsZero;
        }
        [self.table registerClass:[SettingCell class] forCellReuseIdentifier:@"SettingCellIdentifier"];
    }
    return self;
}

- (void)viewAppearOrDisapper:(BOOL)isAppear{
    if (isAppear) {
        self.table.dataSource = self;
        self.table.delegate =self;
    }else{
        self.table.dataSource = nil;
        self.table.delegate = nil;
    }
}

- (void)checkHasLogin{

    if ([AccountManager sharedInstance].hasLogin) {
        EtyUser *currentUser = [AccountManager sharedInstance].currentUser;
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIScreenWidth, 70)];
        _headerView.backgroundColor = RGB(241, 241, 241);
        _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, UIScreenWidth, 21)];
        _nameLb.text = currentUser.name;
        _nameLb.textColor = UI_NAVIBAR_COLOR;
        _nameLb.font = FONT(17);
        _nameLb.backgroundColor = RGB(241, 241, 241);
        [_headerView addSubview:_nameLb];
        
        _phoneLb =[[UILabel alloc]initWithFrame:CGRectMake(10, 70 - 21 - 5, UIScreenWidth, 21)];
        _phoneLb.textColor = [UIColor blackColor];
        _phoneLb.text =currentUser.phone;
        _phoneLb.font = FONT(17);
        _phoneLb.backgroundColor = RGB(241, 241, 241);
        
        [_headerView addSubview:_phoneLb];
        self.table.tableHeaderView = _headerView;

        _datas = @[@"About",@"Terms & Conditions",@"Privacy",@"Change Password",@"Change Mobile Number",@"Send us feedback",@"Logout"];
        _imgs = @[[UIImage imageNamed:@"setting_about"],[UIImage imageNamed:@"setting_terms-condition"],[UIImage imageNamed:@"setting_privacy"],[UIImage imageNamed:@"setting_login_pwd"],[UIImage imageNamed:@"setting_change_mobile"],[UIImage imageNamed:@"setting_about"],[UIImage imageNamed:@"setting_logout"]];
        [self.table reloadData];
    }else{
        _datas = @[@"Register",@"Login",@"About",@"Terms & Conditions",@"Privacy",@"Send us feedback"];
        _imgs = @[[UIImage imageNamed:@"setting_register"],[UIImage imageNamed:@"setting_login"],[UIImage imageNamed:@"setting_about"],[UIImage imageNamed:@"setting_terms-condition"],[UIImage imageNamed:@"setting_privacy"],[UIImage imageNamed:@"setting_about"]];
        self.table.tableHeaderView = nil;
        [self.table reloadData];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingCell *cell = LOAD_XIB_CLASS(SettingCell);
    cell.contentView.backgroundColor = RGB(246, 246, 246);
    cell.imgV.image = _imgs[indexPath.row];
    cell.titleLb.text = _datas[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString*txt = _datas[indexPath.row];
    if ([txt isEqualToString:@"Login"]) {
        UserLoginController *vc = [[UserLoginController alloc]initController];
        PUSH_CONTROLLER(vc);
    }else if ([txt isEqualToString:@"Register"]){
        UserRegisterFirstController *vc = [[UserRegisterFirstController alloc]initController];
        PUSH_CONTROLLER(vc);
    }else if ([txt isEqualToString:@"About"]){
        AboutController *cv = [[AboutController alloc]initWithTitle:txt withType:AboutPage];
        PUSH_CONTROLLER(cv);
    }else if ([txt isEqualToString:@"Terms & Conditions"]){
        AboutController *cv = [[AboutController alloc]initWithTitle:txt withType:TermPage];
        PUSH_CONTROLLER(cv);

    }else if ([txt isEqualToString:@"Privacy"]){
        AboutController *cv = [[AboutController alloc]initWithTitle:txt withType:PrivacyPage];
        PUSH_CONTROLLER(cv);

    }else if ([txt isEqualToString:@"Rate Us"]){
        
    }else if ([txt isEqualToString:@"Change Password"]){
        ChangePasswordController *vc = [[ChangePasswordController alloc]initController];
        PUSH_CONTROLLER(vc);
    }else if ([txt isEqualToString:@"Change Mobile Number"]){
        UserRegisterFirstController *vc = [[UserRegisterFirstController alloc]initWithChangeMobile];
        PUSH_CONTROLLER(vc);
    }else if ([txt isEqualToString:@"Logout"]){
        [LZAlertControl showAlertWithTitle:@"Logout?" withRemark:nil withBlock:^(BOOL confirm) {
            if (confirm) {
                [[NSNotificationCenter defaultCenter]postNotificationName:LOGOUT_NOTIFICATION_POST object:nil];
                [SSKeychain deletePasswordForService:kKeyChainSaveAccountService account:[AccountManager sharedInstance].currentUser.name];
                [[SSKeychain accountsForService:kKeyChainSaveAccountService] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSLog(@"%@",obj);
                    BOOL delete = [SSKeychain deletePasswordForService:kKeyChainSaveAccountService account:[obj valueForKey:@"acct"]];
                    if (delete) {
                        NSLog(@"删除密码成功");
                    }else{
                        NSLog(@"删除密码失败");
                        
                    }
                }];

                [AccountManager sharedInstance].currentUser = nil;
                [self checkHasLogin];
            }
        }];
    }else if ([txt isEqualToString:@"Send us feedback"]){
        FeedbackController*vc = [[FeedbackController alloc]initController];
        PUSH_CONTROLLER(vc);
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
