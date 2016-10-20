//
//  LCFeedbackViewController.m
//  lucky2me
//
//  Created by GanWenPeng on 16/1/17.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCFeedbackViewController.h"

@interface LCFeedbackViewController ()
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmClick;

@end

@implementation LCFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"意见反馈";
    self.textView.placeholder = @"您好，我是滑坡监测App的开发者 甘文鹏，有问题可以和我留言。";
    self.textView.placeholderColor = DefaultColorGray204;
    self.textView.font = [UIFont systemFontOfSize:14];
    
    self.confirmBtn.layer.cornerRadius = 2;
    self.confirmBtn.clipsToBounds = YES;
 
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [TheNotificationCenter addObserver:self selector:@selector(inputChange) name:UITextViewTextDidChangeNotification object:self.textView];
}

- (void)dealloc{
    [TheNotificationCenter removeObserver:self];
}
#pragma mark - action
- (void)inputChange{
    if (self.textView.text.length>0) {
        self.confirmBtn.enabled = YES;
    } else {
        self.confirmBtn.enabled = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)confirmClick {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"feedback"] = self.textView.text;
    if ([LCUserViewModel isLogin]) {
        params[@"uid"] = [LCCommonTool sharedLCCommonTool].currentUser.user_id;
    }
    __weak typeof(self) weakSelf = self;
    [NetworkTool POST:API_Feedback parameters:params showHUD:YES hudView:nil hudStr:nil success:^(id data) {
        [MBProgressHUD showMessage:@"反馈成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } tgError:nil failure:nil];
}
@end
