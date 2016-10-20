//
//  LCIMService.h
//  Lucky2me
//
//  Created by 甘文鹏 on 2016/10/18.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCIMService : NSObject
/** 单例 */
+ (instancetype)defaultService;

/** 启动服务 */
+ (void)start;
/** 重启服务 */
+ (void)reStart;
/** 断开服务 */
+ (void)close;

+ (void)postMessage:(NSString*)message;
@end
