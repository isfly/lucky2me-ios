//
//  LCMineTopView.h
//  ToGoDecoration
//
//  Created by GanWenPeng on 16/2/16.
//  Copyright © 2016年 GanWenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCMineTopView;

@protocol LCMineTopViewDelegate <NSObject>
- (void)mineTopViewClickIconBtn:(LCMineTopView *)topView;
- (void)mineTopViewClickTitleBtn:(LCMineTopView *)topView;

@end

@interface LCMineTopView : UIView
@property (weak, nonatomic) IBOutlet GWPNoHighlightButton *iconBtn;
@property (weak, nonatomic) IBOutlet GWPNoHighlightButton *titleBtn;
@property (nonatomic, weak)   id<LCMineTopViewDelegate> delegate;
@end
