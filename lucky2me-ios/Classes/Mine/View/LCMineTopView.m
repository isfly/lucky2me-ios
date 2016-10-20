//
//  LCMineTopView.m
//  ToGoDecoration
//
//  Created by GanWenPeng on 16/2/16.
//  Copyright © 2016年 GanWenPeng. All rights reserved.
//

#import "LCMineTopView.h"

@interface LCMineTopView ()

@end

@implementation LCMineTopView
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.iconBtn.imageView.layer.cornerRadius = self.iconBtn.width/2;
    self.iconBtn.imageView.clipsToBounds = YES;
    self.iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    __weak typeof(self) weakSelf = self;
    [[_iconBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([_delegate respondsToSelector:@selector(mineTopViewClickIconBtn:)]) {
            [_delegate mineTopViewClickIconBtn:weakSelf];
        }
    }];
    
    [[_titleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([_delegate respondsToSelector:@selector(mineTopViewClickTitleBtn:)]) {
            [_delegate mineTopViewClickTitleBtn:weakSelf];
        }
    }];
}

@end
