//
//  LCTabbarController.m
//  lucky2me
//
//  Created by 甘文鹏 on 16/4/12.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCTabbarController.h"
#import "LCMessageViewController.h"
#import "LCContactViewController.h"
#import "LCMineViewController.h"
#import "LCNavigationController.h"

@interface LCTabbarController ()

@end

@implementation LCTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = DefaultColorOrange140;
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    [self addChildViewController:[[LCMessageViewController alloc] init] WithItemTitle:@"消息" normalImage:[UIImage imageNamed:@"message"] selectedImage:nil];
    
    [self addChildViewController:[[LCContactViewController alloc] init] WithItemTitle:@"联系人" normalImage:[UIImage imageNamed:@"contact"] selectedImage:nil];
    
    [self addChildViewController:[[LCMineViewController alloc] init] WithItemTitle:@"我的" normalImage:[UIImage imageNamed:@"mine"] selectedImage:nil];
}


/**
 *  添加自控制器
 *
 *  @param childVc       将被添加的控制器
 *  @param itemTitle     控制器Item标题
 *  @param normalImage   正常状态下的图片
 *  @param selectedImage 选中时得图片
 */
- (void)addChildViewController:(UIViewController *)childVc WithItemTitle:(NSString *)itemTitle normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage{
    
    childVc.title = itemTitle;      // 这一句相当于上面注释掉得那两句，可以同时设置tabBar和nav的title
    
    if (normalImage && selectedImage) {
        childVc.tabBarItem.image = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        childVc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.image = normalImage;
    }
    
    
    // 选中状态的文字的字体属性
    NSMutableDictionary *selectedTextAttr = [NSMutableDictionary dictionary];
    selectedTextAttr[NSForegroundColorAttributeName] = DefaultColorOrange140;
    selectedTextAttr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:10];
    
    // 正常状态下的文字字体属性
    NSMutableDictionary *normalTextAttr = [NSMutableDictionary dictionary];
    normalTextAttr[NSForegroundColorAttributeName] = DefaultColorGray153;
    normalTextAttr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:10];
    
    // 设置tabbarItem字体属性
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttr forState:UIControlStateSelected];
    [childVc.tabBarItem setTitleTextAttributes:normalTextAttr forState:UIControlStateNormal];
    
    LCNavigationController *nav = [[LCNavigationController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
}

@end
