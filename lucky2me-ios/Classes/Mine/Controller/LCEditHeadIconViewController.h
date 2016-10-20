//
//  LCEditHeadIconViewController.h
//  ToGoDecoration
//
//  Created by GanWenPeng on 16/3/2.
//  Copyright © 2016年 GanWenPeng. All rights reserved.
//

#import "LCViewController.h"

@interface LCEditHeadIconViewController : LCViewController
@property (nonatomic, strong) UIImage *headImage;

@property(nonatomic, assign)  UIImagePickerControllerSourceType     sourceType;
@property (nonatomic, copy)   void(^confirmClick)(UIImage *image);
@end
