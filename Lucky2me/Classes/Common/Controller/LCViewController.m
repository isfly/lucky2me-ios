//
//  LCViewController.m
//  lucky2me
//
//  Created by 甘文鹏 on 16/4/12.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCViewController.h"
#import "LCLoginViewController.h"

@interface LCViewController ()

@end

@implementation LCViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}


- (void)goLogin{
    [self presentViewController:[[LCNavigationController alloc] initWithRootViewController:[[LCLoginViewController alloc] init]] animated:YES completion:nil];
}
@end
