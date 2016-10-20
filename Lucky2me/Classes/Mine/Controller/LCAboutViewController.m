//
//  LCAboutViewController.m
//  lucky2me
//
//  Created by GanWenPeng on 16/1/15.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCAboutViewController.h"

#define LINESPACE 20

@interface LCAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *sepLine1;
@property (weak, nonatomic) IBOutlet UIView *sepLine2;
@property (weak, nonatomic) IBOutlet UIView *sepLine3;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;


@end

@implementation LCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    [self setup];
}

- (void)setup {
    self.sepLine1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cutline"]];
    self.sepLine2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cutline"]];
    self.sepLine3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cutline"]];
    
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = DefaultColorGray68;
    self.subTitleLabel.font = [UIFont systemFontOfSize:12];
    self.subTitleLabel.textColor = DefaultColorGray153;
//    NSString *str = @"好装修，找兔狗！兔狗家装是全国领先互联网家装平台。好设计，好材料，好施工，好服务！提供一站式装修解决方案，权威监理严格验收，装修管家全程一对一专业指导。";
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    
//    paragraphStyle.minimumLineHeight = LINESPACE;
//    paragraphStyle.maximumLineHeight = LINESPACE;
//    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
//    self.introduceLabel.attributedText = attrStr;
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
