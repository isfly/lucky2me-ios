//
//  LCUserViewModel.m
//  lucky2me
//
//  Created by 甘文鹏 on 16/4/25.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCUserViewModel.h"

@implementation LCUserViewModel
+ (BOOL)isLogin{
    LCUser *u = [LCCommonTool sharedLCCommonTool].currentUser;
    return (u.token!=nil);
}

+ (NSString *)getSkeyWithPassword:(NSString *)password{
    return password.md5;
}

+ (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                 success:(void (^)(LCUser *))tgSuccess
                  failed:(void (^)(NSError *))faild{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNo"]   = account;
    params[@"password"] = password.md5;
    DLog(@"%@", params);
    [NetworkTool POST:API_Login parameters:params showHUD:YES hudView:nil hudStr:nil success:^(id data) {
        
        LCUser *user = [LCUser mj_objectWithKeyValues:data];
        user.phoneNo = [account isMobileNumber] ? account : nil;
        [LCCommonTool sharedLCCommonTool].currentUser = user;
        [TheNotificationCenter postNotificationName:N_LoginStatusDidChangeNotification object:nil];
        
        if (tgSuccess) {
            tgSuccess(user);
        }
    } tgError:nil failure:nil];
}

+ (void)logoutSuccess:(LCBlock)success failed:(void (^)(NSError *))faild{
    [LCCommonTool sharedLCCommonTool].currentUser = nil;
    [TheNotificationCenter postNotificationName:N_LoginStatusDidChangeNotification object:nil];
    if (success) {
        success();
    }
}

+ (void)registerWithAccount:(NSString *)account
                   password:(NSString *)password
                      vcode:(NSString *)vcode
                    success:(void (^)(LCUser *))tgSuccess
                     failed:(void (^)(NSError *))faild{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNo"]   = account;
    params[@"password"] = password.md5;
    params[@"sms"]    = vcode;
    [NetworkTool POST:API_Register parameters:params showHUD:YES hudView:nil hudStr:nil success:^(NSDictionary *responseObject) {
        [self loginWithAccount:account password:password success:^(LCUser *user) {
            if (tgSuccess) {
                tgSuccess(user);
            }
        } failed:^(NSError *error) {
            if (faild) {
                faild(error);
            }
        }];
    } tgError:nil failure:nil];
    
}

+ (void)resetPasswordWithAccount:(NSString *)account
                        password:(NSString *)password
                           vcode:(NSString *)vcode
                         success:(void (^)(LCUser *))success
                          failed:(void (^)(NSError *))faild{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phoneNo"]   = account;
    params[@"password"] = password.md5;
    params[@"sms"]    = vcode;
    DLog(@"%@", params);
    
    [NetworkTool POST:API_UserChangePwd parameters:params showHUD:YES hudView:nil hudStr:nil success:^(NSDictionary *responseObject) {
        [self loginWithAccount:account password:password success:^(LCUser *user) {
            if (success) {
                success(user);
            }
        } failed:^(NSError *error) {
            if (faild) {
                faild(error);
            }
        }];
    } tgError:nil failure:nil];
    
}

+ (void)setCurrentUserAvatarForView:(id)view placeholder:(UIImage *)placeholder{
    NSAssert([view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UIButton class]], @"%s的参数必须是UIImageView或UIButton或他们的子类",__func__);
    
    LCUser *u = [LCCommonTool sharedLCCommonTool].currentUser;
    
    if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imgV = view;
        if (u.avatarImage) {
            imgV.image = u.avatarImage;
        } else {
            [imgV sd_setImageWithURL:[NSURL URLWithString:u.avatarURL] placeholderImage:placeholder];
        }
    }
    
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *btn = view;
        if (u.avatarImage) {
            [btn setImage:u.avatarImage forState:UIControlStateNormal];
        } else {
            [btn sd_setImageWithURL:[NSURL URLWithString:u.avatarURL] forState:UIControlStateNormal placeholderImage:placeholder];
        }
    }
}
@end
