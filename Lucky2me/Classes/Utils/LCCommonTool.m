//
//  LCCommonTool.m
//  lucky2me
//
//  Created by GanWenPeng on 16/1/12.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCCommonTool.h"

@implementation LCCommonTool

#pragma mark - init
singleton_implementation(LCCommonTool)
+ (void)initialize{
    LCCommonTool *tool = [self sharedLCCommonTool];
    
    /** 用户信息 */
    tool.currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:[TheUserDefaults objectForKey:KEY_User]];
    
    
}


#pragma mark - setter
- (void)setCurrentUser:(LCUser *)currentUser{
    _currentUser = currentUser;
    
    if (currentUser) {
        [TheUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:currentUser] forKey:KEY_User];
    } else {
        [TheUserDefaults removeObjectForKey:KEY_User];
    }
    
    [TheUserDefaults synchronize];
}



@end
