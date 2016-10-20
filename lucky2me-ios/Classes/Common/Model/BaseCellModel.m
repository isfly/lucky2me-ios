//
//  BaseCellModel.m
//  EasySchool
//
//  Created by GanWenPeng on 15/10/9.
//  Copyright © 2015年 甘文鹏. All rights reserved.
//

#import "BaseCellModel.h"

@implementation BaseCellModel
+ (instancetype)modelWithImage:(UIImage *)image title:(NSString *)title subTitle:(NSString *)subTitle targetClass:(__unsafe_unretained Class)targetClass clickHandler:(void (^)())clickHandler{
    BaseCellModel *model = [[self alloc] init];
    model.image = image;
    model.title = title;
    model.subTitle = subTitle;
    model.targetClass = targetClass;
    model.clickHandler = clickHandler;
    return model;
}
@end
