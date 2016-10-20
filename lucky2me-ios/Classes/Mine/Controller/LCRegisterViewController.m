//
//  LCRegisterViewController.m
//  lucky2me
//
//  Created by GanWenPeng on 16/1/12.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#define kVerifyTimeInterval 60

#import "LCRegisterViewController.h"
#import "LCLoginViewController.h"

@interface LCRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *getVerifyLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoField;
@property (weak, nonatomic) IBOutlet UITextField *verifyField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (nonatomic, assign) NSInteger surplusTime;
@property (nonatomic, strong) NSTimer   *timer;

@property (nonatomic, copy)   NSString *token;

- (IBAction)goLoginClick;


- (IBAction)confirmClick;
- (IBAction)eyeClick:(UIButton *)sender;

@end

@implementation LCRegisterViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.phoneNoField.text = nil;
    self.passwordField.text = nil;
    self.verifyField.text = nil;
}
- (void)dealloc{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [TheNotificationCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.title = @"注册";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back2"] style:UIBarButtonItemStyleDone target:nil action:nil];
    self.confirmBtn.layer.cornerRadius = 2;
    self.confirmBtn.clipsToBounds = YES;
    [self.getVerifyLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getVerifyClick)]];
    
    
    [TheNotificationCenter addObserver:self selector:@selector(inputChange) name:UITextFieldTextDidChangeNotification object:self.phoneNoField];
    [TheNotificationCenter addObserver:self selector:@selector(inputChange) name:UITextFieldTextDidChangeNotification object:self.passwordField];
    [TheNotificationCenter addObserver:self selector:@selector(inputChange) name:UITextFieldTextDidChangeNotification object:self.verifyField];
}


#pragma mark - action
- (void)inputChange{
    if (self.phoneNoField.text.length>0 && self.passwordField.text.length>0 && self.verifyField.text.length>0) {
        self.confirmBtn.enabled = YES;
    } else {
        self.confirmBtn.enabled = NO;
    }
}
- (IBAction)goLoginClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmClick {
    [self.view endEditing:YES];
    if (![self checkInput]) return;
    __weak typeof(self) weakSelf = self;
    [LCUserViewModel registerWithAccount:self.phoneNoField.text password:self.passwordField.text vcode:self.verifyField.text success:^(LCUser *user) {
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [MBProgressHUD showMessage:@"注册成功"];
        }];
    } failed:nil];
}
- (IBAction)eyeClick:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    self.passwordField.secureTextEntry = !sender.selected;
    
}
- (void)getVerifyClick{
    [self.view endEditing:YES];
    if (![self checkPhoneNo]) return;
    
    self.getVerifyLabel.textColor = DefaultColorGray153;
    self.getVerifyLabel.text = [NSString stringWithFormat:@"重新发送(%zds)", kVerifyTimeInterval];
    self.getVerifyLabel.userInteractionEnabled = NO;
    self.surplusTime = kVerifyTimeInterval;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(cutDownTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    __weak typeof(self) weakSelf = self;
    [NetworkTool POST:API_RegSMS
           parameters:@{@"phoneNo" : self.phoneNoField.text}
              showHUD:YES
              hudView:nil
               hudStr:nil
              success:^(id data) {
                  weakSelf.token = @"9999";
              }
              tgError:^(id data, NetworkRetcode errorCode, NSString *message) {
                  
                  [MBProgressHUD showMessage:message toView:self.view];
                  [weakSelf.timer invalidate];
                  weakSelf.timer = nil;
                  weakSelf.getVerifyLabel.text = @"获取验证码";
                  weakSelf.getVerifyLabel.userInteractionEnabled = YES;
                  weakSelf.getVerifyLabel.textColor = DefaultColorGreen;
              }
              failure:^(NSError *error) {
                  [MBProgressHUD showMessage:NetworkFailureNotice toView:self.view];
                  [weakSelf.timer invalidate];
                  weakSelf.timer = nil;
                  weakSelf.getVerifyLabel.text = @"获取验证码";
                  weakSelf.getVerifyLabel.userInteractionEnabled = YES;
                  weakSelf.getVerifyLabel.textColor = DefaultColorGreen;
              }];
}

- (BOOL)checkPhoneNo{
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
    return YES;
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
    
    if ((!self.token) || self.token.length==0) {
        [MBProgressHUD showMessage:@"请先获取验证码" toView:self.view];
        return NO;
    }
    
    if (self.verifyField.text.length==0) {
        self.verifyField.textColor = DefaultColorTextRed;
        [MBProgressHUD showMessage:@"请填写验证码" toView:self.view];
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

#pragma private
- (void)cutDownTime{
    if (--self.surplusTime==0) {
        [self.timer invalidate];
        self.timer = nil;
        self.getVerifyLabel.text = @"获取验证码";
        self.getVerifyLabel.userInteractionEnabled = YES;
        self.getVerifyLabel.textColor = DefaultColorGreen;
        return;
    }
    
    self.getVerifyLabel.textColor = DefaultColorGray153;
    self.getVerifyLabel.text = [NSString stringWithFormat:@"重新发送(%lds)", (long)self.surplusTime];
    
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
    } else if ([textField isEqual:_verifyField]) {
        if (textField.text.length==6 && (string.length>0)) {
            return NO;
        }
        if (!([string isNumber] || [string isEqualToString:@""])) {
            return NO;
        }
    }
    return YES;
}
@end
