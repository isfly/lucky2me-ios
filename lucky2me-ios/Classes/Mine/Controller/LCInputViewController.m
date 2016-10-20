//
//  LCInputViewController.m
//  lucky2me
//
//  Created by GanWenPeng on 16/1/13.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCInputViewController.h"

@interface LCInputViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@end

@implementation LCInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self setup];
}

- (void)setup {
    [self.saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (_placeholder) {
        self.textField.placeholder = _placeholder;
    }
    
    if (_contentStr) {
        self.textField.text = _contentStr;
    }
    
    [TheNotificationCenter addObserver:self selector:@selector(inputChange) name:UITextFieldTextDidChangeNotification object:self.textField];
    
    self.saveBtn.layer.cornerRadius = 2;
    self.saveBtn.clipsToBounds = YES;
    
    [self inputChange];
}

- (void)dealloc{
    [TheNotificationCenter removeObserver:self];
}

- (NSString *)statisticTitle{
    return self.title;
}

#pragma mark - action
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

- (void)saveClick{
    if ([_delegate respondsToSelector:@selector(inputViewController:completeInputWith:)]) {
        [_delegate inputViewController:self completeInputWith:self.textField.text];
    }
}

- (void)inputChange{
    if (self.textField.text.length) {
        self.saveBtn.enabled = YES;
    } else {
        self.saveBtn.enabled = NO;
    }
}
@end
