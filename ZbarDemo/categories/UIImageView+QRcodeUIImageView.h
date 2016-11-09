//
//  UIImageView+QRcodeUIImageView.h
//  DRCodeDemo
//
//  Created by 曹  on 15-5-1.
//  Copyright (c) 2015年 caochao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (QRcodeUIImageView)
+(UIImageView *)generateQRCodeImageViewWithInfo:(NSString *)info QRcodeImageFrame:(CGRect)frame icon:(UIImage *)icon iconSize:(CGFloat)iconSize QRCodeRedColor:(CGFloat)red green:(float)green blue:(CGFloat)blue;
@end
