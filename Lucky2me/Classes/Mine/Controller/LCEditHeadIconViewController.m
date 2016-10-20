//
//  LCEditHeadIconViewController.m
//  ToGoDecoration
//
//  Created by GanWenPeng on 16/3/2.
//  Copyright © 2016年 GanWenPeng. All rights reserved.
//

#import "LCEditHeadIconViewController.h"
#import "LCHeadIconBgView.h"

@interface LCEditHeadIconViewController (){
    CGPoint _imageCenter;
}
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet LCHeadIconBgView *circularBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthC;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)backClick;
- (IBAction)exitClick;

@property (nonatomic, assign) CGRect imageDisplayRect;
@end

@implementation LCEditHeadIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    self.imageView.image = _headImage;
}


- (void)setup {
    _imageCenter = _circularBgView.center;
    self.circularBgView.backgroundColor = [UIColor clearColor];

    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.confirmBtn setTitleColor:DefaultColorGreen forState:UIControlStateNormal];
    self.imageView.image = nil;
    self.imageView.backgroundColor = [UIColor redColor];
    
    [self.view addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinImage:)]];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)]];
    
    [[self.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.confirmClick) {
            CGFloat r = self.circularBgView.radius;
            _imageDisplayRect = [self.imageView convertRect:CGRectMake(self.view.width/2-r, self.view.height/2-r, 2*r, 2*r) fromView:_circularBgView];
            UIImage *img = [[UIImage imageCompressForWidth:_headImage targetWidth:self.imageView.width] cutImageWithRect:_imageDisplayRect];
            self.confirmClick(img);
        }
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.circularBgView.radius = self.view.width/2 - 27;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.imageWidthC.constant = screenSize.width;
    self.imageHeightC.constant = _headImage.size.height * screenSize.width / _headImage.size.width;
}

- (void)panImage:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan translationInView:pan.view];
    if (pan.state == UIGestureRecognizerStateChanged || pan.state==UIGestureRecognizerStateBegan) {
        self.imageView.transform = CGAffineTransformMakeTranslation(point.x, point.y);
    } else{
        self.imageView.transform = CGAffineTransformIdentity;
        self.imageView.x += point.x;
        self.imageView.y += point.y;
        _imageCenter = self.imageView.center;
    }
}

- (void)pinImage:(UIPinchGestureRecognizer *)pin{
    
    if (pin.state == UIGestureRecognizerStateChanged || pin.state==UIGestureRecognizerStateBegan) {
        self.imageView.transform = CGAffineTransformMakeScale(pin.scale, pin.scale);
    } else{
        self.imageView.transform = CGAffineTransformIdentity;
        CGFloat w = self.imageView.width*pin.scale;
        CGFloat h = self.imageView.height*pin.scale;
        self.imageView.width = w;
        self.imageView.height = h;
        self.imageView.center = _imageCenter;

        CGFloat xiebian = sqrt(pow(w, 2) + pow(h, 2));
        if (xiebian < 2*self.circularBgView.radius) {
            __weak typeof(self) weakSelf = self;
            CGFloat scale = 2*self.circularBgView.radius/xiebian;
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.imageView.transform = CGAffineTransformMakeTranslation(scale, scale);
            } completion:^(BOOL finished) {
                weakSelf.imageView.transform = CGAffineTransformIdentity;
                weakSelf.imageView.width = weakSelf.imageView.width * scale;
                weakSelf.imageView.height = weakSelf.imageView.height * scale;
                weakSelf.imageView.center = _imageCenter;
            }];
        }
        
        CGFloat r = self.circularBgView.radius;
        _imageDisplayRect = [self.imageView convertRect:CGRectMake(self.view.width/2-r, self.view.height/2-r, 2*r, 2*r) fromView:_circularBgView];
    }
    
    
}



- (IBAction)backClick {
    if (self.sourceType==UIImagePickerControllerSourceTypeCamera) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)exitClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
