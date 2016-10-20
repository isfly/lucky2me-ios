//
//  LCUser.m
//  lucky2me
//
//  Created by GanWenPeng on 16/1/12.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCUser.h"

@implementation LCUser
MJCodingImplementation
- (NSString *)avatarURL{
    return [NSString stringWithFormat:@"%@/LC/img/headIcon/%@.png", SDK_OSS_Endpoint, self.user_id.md5];
}
@end
