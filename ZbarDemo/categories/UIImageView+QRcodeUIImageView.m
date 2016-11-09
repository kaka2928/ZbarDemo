//
//  UIImageView+QRcodeUIImageView.m
//  DRCodeDemo
//
//  Created by 曹  on 15-5-1.
//  Copyright (c) 2015年 caochao. All rights reserved.
//

#import "UIImageView+QRcodeUIImageView.h"
#import "UIImage+QRCodeImage.h"

@implementation UIImageView (QRcodeUIImageView)

+(UIImageView *)generateQRCodeImageViewWithInfo:(NSString *)info QRcodeImageFrame:(CGRect)frame icon:(UIImage *)icon iconSize:(CGFloat)iconSize QRCodeRedColor:(CGFloat)red green:(float)green blue:(CGFloat)blue{

    
    UIImageView *QRCodeImageView = [[UIImageView alloc]initWithFrame:frame];
    QRCodeImageView.image = [UIImage replaceBlackColorWithUIImage:[UIImage generateQRCodeImageWithInput:info withSize:frame.size.height] andRed:red andGreen:green andBlue:blue];

    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-iconSize)/2, (frame.size.height-iconSize)/2,iconSize,iconSize)];
    iconImageView.image = icon;
    
    [QRCodeImageView addSubview:iconImageView];
    
    return QRCodeImageView;
}
@end
