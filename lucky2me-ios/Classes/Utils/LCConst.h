//
//  LCConst.h
//  lucky2me
//
//  Created by 甘文鹏 on 16/4/18.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#pragma mark - 自定义打印宏
#define DLog(...) GWPLog(__VA_ARGS__)

#pragma mark - 判断系统
// 判断是否是iOS7
#define IS_iOS7_Later ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
// 判断是否是iOS8
#define IS_iOS8_Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
// 判断是否是iOS9
#define IS_iOS9_Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
// 判断是否是iOS10
#define IS_iOS10_Later ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)

#pragma mark - 屏幕视频
#define K_ScreenK_W_5   ([UIScreen mainScreen].bounds.size.width/320)
#define K_ScreenK_W_6   ([UIScreen mainScreen].bounds.size.width/375)
#define K_ScreenK_W_6p  ([UIScreen mainScreen].bounds.size.width/414)
#define K_ScreenK_W_Pad ([UIScreen mainScreen].bounds.size.width/768)

#pragma mark - 系统定义宏
#define TheApp           ([UIApplication sharedApplication])
#define TheAppDelegate   ((AppDelegate *)TheApp.delegate)
#define TheUserDefaults  [NSUserDefaults standardUserDefaults]
#define TheNotificationCenter   ([NSNotificationCenter defaultCenter])

#pragma mark - 颜色
#define DefaultColorOrange140  GWPRGBColor(255, 140, 27, 1)
#define DefaultColorOrange102  GWPRGBColor(255, 102, 0, 1)
#define DefaultColorTextRed    GWPRGBColor(255, 90, 105, 1)
#define DefaultColorGreen      GWPRGBColor(14, 201, 195, 1)
#define DefaultColorGold       GWPRGBColor(255, 184, 27, 1)
#define DefaultColorGray68     GWPRGBColor(68, 68, 68, 1)
#define DefaultColorGray74     GWPRGBColor(74, 74, 74, 1)
#define DefaultColorGray153    GWPRGBColor(153, 153, 153, 1)
#define DefaultColorGray204    GWPRGBColor(204, 204, 204, 1)
#define DefaultColorGray229    GWPRGBColor(229, 229, 229, 1)
#define DefaultColorGray244    GWPRGBColor(244, 244, 244, 1)
#define DefaultColorGray246    GWPRGBColor(246, 246, 246, 1)
#define DefaultColorGray250    GWPRGBColor(250, 250, 250, 1)


#pragma mark - Fram
#define GWPScreenW  [UIScreen mainScreen].bounds.size.height
#define GWPScreenH  [UIScreen mainScreen].bounds.size.width

typedef void(^LCBlock)();

#pragma mark - 通知
// 登陆状态改变
extern NSString *const N_LoginStatusDidChangeNotification;
// 用户信息改变
extern NSString *const N_UserInfoDidChangeNotification;

#pragma mark - 沙盒存储Key
extern NSString *const KEY_User;
