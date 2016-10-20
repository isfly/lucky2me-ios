//
//  LCLoginViewController.m
//  lucky2me
//
//  Created by GanWenPeng on 16/1/12.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCLoginViewController.h"
#import "LCRegisterViewController.h"
#import "LCForgetPasswordViewController.h"

@interface LCLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNoField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmClick;
- (IBAction)forgetClick;

@end

@implementation LCLoginViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.phoneNoField.text = nil;
    self.passwordField.text = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.title = @"登录";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 44, 44);
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [btn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleDone target:self action:@selector(registerClick)];
    
    self.confirmBtn.layer.cornerRadius = 2;
    self.confirmBtn.clipsToBounds = YES;
    
    [TheNotificationCenter addObserver:self selector:@selector(inputChange) name:UITextFieldTextDidChangeNotification object:self.phoneNoField];
    [TheNotificationCenter addObserver:self selector:@selector(inputChange) name:UITextFieldTextDidChangeNotification object:self.passwordField];
}

- (void)dealloc{
    [TheNotificationCenter removeObserver:self];
}
#pragma mark - action
- (void)inputChange{
    if (self.phoneNoField.text.length>0 && self.passwordField.text.length>0) {
        self.confirmBtn.enabled = YES;
    } else {
        self.confirmBtn.enabled = NO;
    }
}
- (void)cancelClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerClick{
    [self.navigationController pushViewController:[[LCRegisterViewController alloc] init] animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)confirmClick {
    [self.view endEditing:YES];
    if (![self checkInput]) return;
    
    __weak typeof(self) weakSelf = self;
    [LCUserViewModel loginWithAccount:self.phoneNoField.text password:self.passwordField.text success:^(LCUser *user) {
        [MBProgressHUD showMessage:@"登陆成功"];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    } failed:nil];
}

- (IBAction)forgetClick {
    [self.navigationController pushViewController:[[LCForgetPasswordViewController alloc] init] animated:YES];
}



- (BOOL)checkInput{
    if (self.phoneNoField.text.length==0) {
        self.phoneNoField.textColor = DefaultColorTextRed;
        [MBProgressHUD showMessage:@"请填写手机号码" toView:self.view];
        return NO;
    }
    
    if (![self.phoneNoField.text isMobileNumber]) {
        self.phoneNoField.textColor = DefaultColorTextRed;
        [MBProgressHUD showMessage:@"您填写的手机号码有误" toView:self.view];
        return NO;
    }
    
    if (self.passwordField.text.length==0) {
        self.passwordField.textColor = DefaultColorTextRed;
        [MBProgressHUD showMessage:@"请填写密码" toView:self.view];
        return NO;
    }
    
    if ([self.passwordField.text match:@"[\\s]"]) {
        self.passwordField.textColor = DefaultColorTextRed;
        [MBProgressHUD showMessage:@"密码不得有空格" toView:self.view];
        return NO;
    }
    
    if (self.passwordField.text.length<6 || self.passwordField.text.length>20) {
        self.passwordField.textColor = DefaultColorTextRed;
        [MBProgressHUD showMessage:@"密码必须在6-20位之间" toView:self.view];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.textColor = DefaultColorGray68;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:_phoneNoField]) {
        if (textField.text.length==11 && (string.length>0)) {
            return NO;
        }
        if (!([string isNumber] || [string isEqualToString:@""])) {
            return NO;
        }
    }
    return YES;
}
@end
