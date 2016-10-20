//
//  LCMineViewController.m
//  lucky2me
//
//  Created by 甘文鹏 on 16/4/12.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCMineViewController.h"
#import "LCMineTopView.h"
#import "LCProfileViewController.h"

#import "LCSettingViewController.h"
#import "LCFeedbackViewController.h"

@interface LCMineViewController ()<LCMineTopViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *tableArr;
@property (nonatomic, strong) LCMineTopView *topView;
@end

@implementation LCMineViewController
#pragma mark - lazy
- (LCMineTopView *)topView{
    if (!_topView) {
        _topView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LCMineTopView class]) owner:nil options:nil] firstObject];
        _topView.delegate = self;
    }
    return _topView;
}
- (NSArray *)tableArr{
    if (!_tableArr) {
        GWPBaseCellModel *feedback = [GWPBaseCellModel modelWithImage:[UIImage imageNamed:@"opinion"] title:@"意见反馈" subTitle:nil targetClass:[LCFeedbackViewController class] clickHandler:nil];
        GWPBaseCellModel *setting = [GWPBaseCellModel modelWithImage:[UIImage imageNamed:@"set"] title:@"设置" subTitle:nil targetClass:[LCSettingViewController class] clickHandler:nil];
        _tableArr = @[@[feedback, setting]];
    }
    return _tableArr;
}

#pragma mark - init
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateProfile];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = DefaultColorGray246;
//    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);

    [TheNotificationCenter addObserver:self selector:@selector(updateProfile) name:N_LoginStatusDidChangeNotification object:nil];
    [TheNotificationCenter addObserver:self selector:@selector(updateProfile) name:N_UserInfoDidChangeNotification object:nil];
    
    [self updateProfile];
    
}

#pragma mark - action

/** 更新用户信息，头像、昵称等 */
- (void)updateProfile{
    if ([LCUserViewModel isLogin]) {
        LCUser *u = [LCCommonTool sharedLCCommonTool].currentUser;
        [self.topView.titleBtn setTitle:u.username forState:UIControlStateNormal];
        
        [LCUserViewModel setCurrentUserAvatarForView:self.topView.iconBtn placeholder:[UIImage imageNamed:@"headicon"]];
    } else {
        [self.topView.titleBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        [self.topView.iconBtn setImage:[UIImage imageNamed:@"headicon"] forState:UIControlStateNormal];
        
    }
}

#pragma mark - UITableViewDataSource、Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.tableArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GWPBaseCellModel *model = self.tableArr[indexPath.section][indexPath.row];
    NSString *const identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = DefaultColorGray153;
        UIView *sep = [[UIView alloc] init];
        sep.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cutline"]];
        [cell addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(cell);
            make.height.mas_equalTo(1);
        }];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = model.title;
    cell.imageView.image = model.image;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GWPBaseCellModel *model = self.tableArr[indexPath.section][indexPath.row];
    if (model.clickHandler) {
        model.clickHandler();
        return;
    }
    
//    if (indexPath.section==0 && ![LCUserViewModel isLogin]) {
//        [self goLogin];
//        return;
//    }
    
    UIViewController *vc = [[model.targetClass alloc] init];
    if ([vc isKindOfClass:[UIViewController class]]) {
        vc.view.backgroundColor = [UIColor whiteColor];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0 ? 100 : 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section==0 ? 0.00000001 : 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return section==0 ? self.topView : nil;
}

#pragma mark - LCMineTopViewDelegate
- (void)mineTopViewClickIconBtn:(LCMineTopView *)topView{
    if (![LCUserViewModel isLogin]) {
        [self goLogin];
        return;
    }
    
    [self.navigationController pushViewController:[[LCProfileViewController alloc] init] animated:YES];
}

- (void)mineTopViewClickTitleBtn:(LCMineTopView *)topView{
    if (![LCUserViewModel isLogin]) {
        [self goLogin];
    }
}
@end
