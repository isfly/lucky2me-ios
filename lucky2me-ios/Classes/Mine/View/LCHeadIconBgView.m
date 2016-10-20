//
//  LCHeadIconBgView.m
//  ToGoDecoration
//
//  Created by GanWenPeng on 16/3/2.
//  Copyright © 2016年 GanWenPeng. All rights reserved.
//

#import "LCHeadIconBgView.h"

@implementation LCHeadIconBgView

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    _radius = 100;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat w_h = 2*_radius;
    [GWPRGBColor(27, 29, 29, 0.88) set];

    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    /** 左侧 */
    CGContextMoveToPoint(ctx, rect.size.width/2, 0);
    CGContextAddLineToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, 0, rect.size.height);
    CGContextAddLineToPoint(ctx, rect.size.width/2, rect.size.height);
    CGContextAddLineToPoint(ctx, rect.size.width/2, rect.size.height-(rect.size.height-w_h)/2);
    CGContextAddArc(ctx, rect.size.width/2, rect.size.height/2, w_h/2, M_PI_2, M_PI_2*3, 0);
    CGContextAddLineToPoint(ctx, rect.size.width/2, 0);
    CGContextFillPath(ctx);
    
    /** 右侧 */
    CGContextMoveToPoint(ctx, rect.size.width/2, 0);
    CGContextAddLineToPoint(ctx, rect.size.width, 0);
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(ctx, rect.size.width/2, rect.size.height);
    CGContextAddLineToPoint(ctx, rect.size.width/2, rect.size.height-(rect.size.height-w_h)/2);
    CGContextAddArc(ctx, rect.size.width/2, rect.size.height/2, w_h/2, M_PI_2, M_PI_2*3, 1);
    CGContextAddLineToPoint(ctx, rect.size.width/2, 0);
    CGContextFillPath(ctx);
}

- (void)setRadius:(CGFloat)radius{
    _radius = radius;
    
    [self setNeedsDisplay];
}
@end
