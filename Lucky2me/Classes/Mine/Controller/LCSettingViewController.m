//
//  LCSettingViewController.m
//  lucky2me
//
//  Created by GanWenPeng on 16/1/13.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCSettingViewController.h"
#import <SDWebImage/SDImageCache.h>
#import "LCAboutViewController.h"
#import "LCTableViewCell.h"


@interface LCSettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak)   UITableView *tableView;
@property (nonatomic, strong) NSArray *tableDataArr;
@property (nonatomic, strong) BaseCellModel *cacheCellModel;
@end

@implementation LCSettingViewController
#pragma mark - lazy
- (NSArray *)tableDataArr{
    if (!_tableDataArr) {
        BaseCellModel *version = [BaseCellModel modelWithImage:[UIImage imageNamed:@"next2"] title:@"当前版本" subTitle:[NSString stringWithFormat:@"v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] targetClass:nil clickHandler:nil];
        
        BaseCellModel *about = [BaseCellModel modelWithImage:[UIImage imageNamed:@"next2"] title:@"关于我们" subTitle:nil targetClass:[LCAboutViewController class] clickHandler:nil];
        
        BaseCellModel *cache = [BaseCellModel modelWithImage:[UIImage imageNamed:@"delect"] title:@"清除缓存" subTitle:nil targetClass:nil clickHandler:nil];
        cache.subTitle = [self filesizeWithByte:[SDImageCache sharedImageCache].getSize];
        _cacheCellModel = cache;
        _tableDataArr = @[version, about, cache];
    }
    return _tableDataArr;
}

- (NSString *)filesizeWithByte:(NSUInteger)byte{
    if (byte<1024) { // B
        return [NSString stringWithFormat:@"%luB", (unsigned long)byte];
    }
    
    if (byte<1024*1024) {   // K
        return [NSString stringWithFormat:@"%.1fK", byte/1024.0];
    }
    
    if (byte<1024*1024*1024) {  // M
        return [NSString stringWithFormat:@"%.1fM", byte/1024.0/1024.0];
    }
    
    // G
    return [NSString stringWithFormat:@"%.1f", byte/1024.0/1024.0/1024.0];
    
}

#pragma mark - init system
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup{
    self.title = @"设置";
    UITableView *table = [[UITableView alloc] init];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.scrollEnabled = NO;
    table.delegate = self;
    table.dataSource = self;
    [self.view insertSubview:table atIndex:0];
    self.tableView = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];

    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LCTableViewCell class])];
    
    self.tableView.scrollEnabled = NO;
    
    if ([LCUserViewModel isLogin]) {
        UIButton *logout = [[UIButton alloc] init];
        [logout addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
        [logout setTitleColor:DefaultColorGreen forState:UIControlStateNormal];
        [logout setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [self.view insertSubview:logout aboveSubview:table];
        [logout mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(-28.5);
            make.centerX.equalTo(self.view);
            make.height.mas_equalTo(20);
        }];
    }
    
}

- (void)logoutClick{
    __weak typeof(self) weakSelf = self;
    [LCUserViewModel logoutSuccess:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failed:nil];

}

#pragma mark - UITableViewDataSource、Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseCellModel *model = self.tableDataArr[indexPath.row];
    
    NSString *const identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = DefaultColorGray153;
        if (model.title) {
            UIView *sep = [[UIView alloc] init];
            [cell addSubview:sep];
            sep.backgroundColor = DefaultColorGray229;
            sep.x = 16;
            sep.y = 50;
            sep.width = GWPScreenW - 32;
            sep.height = 1;
        }
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    if (indexPath.row==0) {
        cell.accessoryView = nil;
    } else if (indexPath.row==1) {
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        cell.accessoryView = icon;
    } else if (indexPath.row==2) {
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clear"]];
        icon.contentMode = UIViewContentModeRight;
        icon.width = 30;
        cell.accessoryView = icon;
    }
    
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subTitle;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseCellModel *model = self.tableDataArr[indexPath.row];
    
    return model.title ? 61.5 : 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseCellModel *model = self.tableDataArr[indexPath.row];
    
    if (indexPath.row==2) {
        MBProgressHUD *hud = [MBProgressHUD showLoadingMessage:nil toView:self.view];
        __weak typeof(self) weakSelf = self;
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [hud hide:YES];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
            model.subTitle = [self filesizeWithByte:[SDImageCache sharedImageCache].getSize];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [MBProgressHUD showMessage:@"清理完成" toView:self.view];
        }];
        
        return;
    }
    
    
    if (model.clickHandler) {
        model.clickHandler();
        return;
    }
    
    if (model.targetClass) {
        [self.navigationController pushViewController:[[model.targetClass alloc] init] animated:YES];
    }
}
@end
