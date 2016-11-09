//
//  UIView+Frame.h
//  SnailGameShield
//
//  Created by caochao on 16/4/13.
//  Copyright © 2016年 snailCC. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}
#pragma mark - 加载动画

#pragma mark- object
- (void) startLoading
{
    [UIView startLoading:self];
    //NSLog(@"start in :%@", self);
}
- (void) stopLoading
{
    [UIView stopLoading];
    //NSLog(@"stop in :%@", self);
}

static NSMutableArray *arrayForActivityView;
#pragma mark- class
+ (void) startLoading:(UIView *) baseView{
    
    if (!arrayForActivityView)
    {
        arrayForActivityView = [NSMutableArray array];
    }
    
    baseView.userInteractionEnabled=NO;
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake((baseView.frame.size.width-60.0)/2.0, (baseView.frame.size.height-60)/2.0, 60.0, 60.0)];
    //    bigView.center=baseView.center;
    //NSLog(@"%f,%f,%f,%f",bigView.center.x,bigView.center.y,baseView.center.x,baseView.center.y);
    bigView.layer.cornerRadius=5.0;
    bigView.layer.masksToBounds=YES;

    [bigView setBackgroundColor:[UIColor colorWithRed:0 green:.0 blue:0 alpha:0.6]];
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView setFrame:CGRectMake((bigView.frame.size.width-40)/2.0, (bigView.frame.size.height-40)/2.0, 40, 40)];
    [bigView addSubview:loadingView];
    [baseView addSubview:bigView];
    [loadingView startAnimating];
    [arrayForActivityView addObject:bigView];
}

+ (void) stopLoading{
    UIView *bigView = [arrayForActivityView lastObject];
    [arrayForActivityView removeLastObject];
    UIView *baseView = bigView.superview;
    baseView.userInteractionEnabled=YES;
    [bigView removeFromSuperview];
}
@end
