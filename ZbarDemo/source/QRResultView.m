//
//  QRResultView.m
//  ZbarDemo
//
//  Created by caochao on 16/11/9.
//  Copyright © 2016年 snailCC. All rights reserved.
//

#import "QRResultView.h"

@interface QRResultView()<UITextViewDelegate>

@end

@implementation QRResultView

- (instancetype)init{

    if (self = [super init]) {
        self.font =[UIFont systemFontOfSize:16];
        self.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 2.0;
        self.dataDetectorTypes=UIDataDetectorTypeAll;
        self.returnKeyType = UIReturnKeyDone;
        self.delegate = self;
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    self.editable = YES;
    [self becomeFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        self.editable = NO;
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
@end
