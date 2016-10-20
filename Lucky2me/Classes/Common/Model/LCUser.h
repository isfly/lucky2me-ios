//
//  LCUser.h
//  lucky2me
//
//  Created by GanWenPeng on 16/1/12.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCUser : NSObject
/** 用户ID */
@property (nonatomic, copy)   NSString *user_id;
/** token，用于校验合法性 */
@property (nonatomic, copy)   NSString *token;
/** 用户名 */
@property (nonatomic, copy)   NSString *username;
/** 头像URL */
@property (nonatomic, copy)   NSString *avatarURL;
/** 头像 UIimage (优先级比avatarURL更高) */
@property (nonatomic, strong) UIImage *avatarImage;
/** 手机号 */
@property (nonatomic, copy)   NSString *phoneNo;

@end
