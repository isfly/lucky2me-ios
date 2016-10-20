//
//  LCMessageViewController.m
//  Lucky2me
//
//  Created by 甘文鹏 on 2016/10/17.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCMessageViewController.h"
#import "LCIMService.h"

@interface LCMessageViewController ()

@end

@implementation LCMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *reConnect = [[UIBarButtonItem alloc] initWithTitle:@"reset" style:UIBarButtonItemStyleDone andBlock:^{
        [LCIMService reStart];
    }];
    self.navigationItem.rightBarButtonItem = reConnect;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate、UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld组-第%ld行",indexPath.section, indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [LCIMService postMessage:@"hahaha"];
}

@end
