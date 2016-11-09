//
//  UIImage+QRCodeImage.h
//  DRCodeDemo
//
//  Created by 曹  on 15-5-1.
//  Copyright (c) 2015年 caochao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (selfDefineImage)
+(UIImage *)generateQRCodeImageWithInput:(NSString *)input withSize:(CGFloat )size;

+(UIImage *)replaceBlackColorWithUIImage:(UIImage *)image andRed:(CGFloat) red andGreen:(CGFloat)green andBlue:(CGFloat) blue;

@end