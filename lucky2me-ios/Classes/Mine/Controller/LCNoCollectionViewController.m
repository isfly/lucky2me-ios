//
//  LCNoCollectionViewController.m
//  ToGoDecoration
//
//  Created by GanWenPeng on 16/2/17.
//  Copyright © 2016年 GanWenPeng. All rights reserved.
//

#import "LCNoCollectionViewController.h"

@interface LCNoCollectionViewController ()

@end

@implementation LCNoCollectionViewController

- (instancetype)init{
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageV = [[UIImageView alloc] init];
        [self.view addSubview:imageV];
        self.iconVIew = imageV;
        __weak typeof(self) weakSelf = self;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).with.offset(144);
            make.size.mas_equalTo(CGSizeMake(90, 90));
            make.centerX.equalTo(weakSelf.view.mas_centerX);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = DefaultColorGray153;
        [self.view addSubview:label];
        self.titleLabel = label;
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageV.mas_bottom).with.offset(32);
            make.left.equalTo(weakSelf.view).with.offset(0);
            make.right.equalTo(weakSelf.view).with.offset(0);
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
