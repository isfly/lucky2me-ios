//
//  LCNavigationController.m
//  lucky2me
//
//  Created by GanWenPeng on 16/1/12.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCNavigationController.h"
#import <MLTransition/MLTransition.h>

//@implementation UINavigationBar (BackgroundColor)
//static char overlayKey;
//
//- (UIView *)overlay
//{    return objc_getAssociatedObject(self, &overlayKey);
//}
//
//- (void)setOverlay:(UIView *)overlay{
//    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
//{
//    
//    [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [self setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(1, 1)]];        // insert an overlay into the view hierarchy
//    if (IS_iOS10_Later) {
//    } else {
//        if (!self.overlay) {
//            self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
//            [self insertSubview:self.overlay atIndex:0];
//        }    self.overlay.backgroundColor = backgroundColor;
//    }
//
//}
//@end
//

@implementation LCNavigationController
+ (void)initialize{
    [MLTransition validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypeScreenEdgePan];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
        [self setup];
    }
    return self;
}


- (void)setup{
    [self enabledMLTransition:YES];
    // 1、设置导航栏主题
    // 取出导航条
    UINavigationBar *navBar = [UINavigationBar appearance];
//    [navBar setTranslucent:NO];
//    [navBar setShadowImage:[UIImage imageWithColor:DefaultColorGray244 size:CGSizeMake(1, 1)]];
    
    // 1.1、设置背景图片
//    [navBar lt_setBackgroundColor:[UIColor whiteColor]];
    // 1.2、设置字体属性
    NSMutableDictionary *navBarattrs = [NSMutableDictionary dictionary];
    navBarattrs[NSForegroundColorAttributeName] = DefaultColorGray68;
    navBarattrs[NSFontAttributeName] = [UIFont systemFontOfSize:17.0f];
    [navBar setTitleTextAttributes:navBarattrs];
    // 1.3、设置返回箭头的颜色
    navBar.tintColor = DefaultColorGreen;
    
    // 2、设置BarButtonItem的主题
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    itemAttrs[NSForegroundColorAttributeName] = GWPRGBColor(14, 201, 195, 1);
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.viewControllers.count>0) {
        
        // push后去掉TabBar
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -14;
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 44, 44);
        [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItems = @[
                                                             negativeSpacer,
                                                             [[UIBarButtonItem alloc] initWithCustomView:btn]
                                                             ];
    }
    
    [super pushViewController:viewController animated:animated];
    
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{

    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)backClick{
    [self.topViewController.view endEditing:YES];
    [self popViewControllerAnimated:YES];
}

@end

