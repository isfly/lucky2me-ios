//
//  LCUserViewModel.h
//  lucky2me
//
//  Created by 甘文鹏 on 16/4/25.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCUserViewModel : NSObject
/**
 *  判断是否登录
 *
 *  @return 是否登录
 */
+ (BOOL)isLogin;

/**
 *  密码加密
 *
 *  @param password 密码明文
 *
 *  @return 加密过的密码
 */
+ (NSString *)getSkeyWithPassword:(NSString *)password;


/**
 *  登录
 *
 *  @param account  账号
 *  @param password 密码（明文，加密会在内部自动加密）
 *  @param success  成功回调
 *  @param faild    失败回调（此block暂时未用到，为后期扩展所留，现在全部传nil）
 */
+ (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
                 success:(void (^)(LCUser *user))success
                  failed:(void(^)(NSError *error))faild;
/**
 *  登出
 *
 *  @param success  成功回调
 *  @param faild    失败回调（此block暂时未用到，为后期扩展所留，现在全部传nil）
 *
 */
+ (void)logoutSuccess:(LCBlock)success
               failed:(void(^)(NSError *error))faild;

/**
 *  注册
 *
 *  @param account  账号
 *  @param password 密码（明文，加密会在内部自动加密）
 *  @param vcode    验证码
 *  @param success  成功回调
 *  @param faild    失败回调（此block暂时未用到，为后期扩展所留，现在全部传nil）
 */
+ (void)registerWithAccount:(NSString *)account
                   password:(NSString *)password
                      vcode:(NSString *)vcode
                    success:(void (^)(LCUser *user))success
                     failed:(void(^)(NSError *error))faild;
/**
 *  找回密码
 *
 *  @param account  账号
 *  @param password 密码（明文，加密会在内部自动加密）
 *  @param vcode    验证码
 *  @param skey     令牌
 *  @param success  成功回调
 *  @param faild    失败回调（此block暂时未用到，为后期扩展所留，现在全部传nil）
 */
+ (void)resetPasswordWithAccount:(NSString *)account
                        password:(NSString *)password
                           vcode:(NSString *)vcode
                         success:(void (^)(LCUser *user))success
                          failed:(void(^)(NSError *error))faild;

/**
 *  考虑到LCUser有两个属性可以作为头像，所以增加此方法专门设置头像
 *
 *  @param UIImageView/UIButton view 被设置的控件，只能是UIImageView或者UIButton
 */
+ (void)setCurrentUserAvatarForView:(id)view placeholder:(UIImage*)placeholder;
@end
