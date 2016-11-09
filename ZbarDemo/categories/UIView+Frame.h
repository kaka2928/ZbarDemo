//
//  UIView+Frame.h
//  SnailGameShield
//
//  Created by caochao on 16/4/13.
//  Copyright © 2016年 snailCC. All rights reserved.
//



#import <UIKit/UIKit.h>
#define TopWindow [[[UIApplication sharedApplication] delegate] window]
@interface UIView (Frame)

// 自己模仿frame写出他的四个属性
@property (nonatomic, assign) CGFloat  x;
@property (nonatomic, assign) CGFloat  y;
@property (nonatomic, assign) CGFloat  width;
@property (nonatomic, assign) CGFloat  height;

//提示及加载动画
- (void) startLoading;
- (void) stopLoading;
+ (void) startLoading:(UIView *) baseView;
+ (void) stopLoading;


@end
