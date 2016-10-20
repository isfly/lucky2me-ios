//
//  LCInputViewController.h
//  lucky2me
//
//  Created by GanWenPeng on 16/1/13.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCInputViewController;

@protocol LCInputViewControllerDelegate <NSObject>
@optional
- (void)inputViewController:(LCInputViewController *)inputViewController completeInputWith:(NSString *)str;
@end

@interface LCInputViewController : LCViewController
@property (nonatomic, weak)   id<LCInputViewControllerDelegate> delegate;

/** 占位字 */
@property (nonatomic, copy)   NSString *placeholder;
/** 内容 */
@property (nonatomic, copy)   NSString *contentStr;

@end
