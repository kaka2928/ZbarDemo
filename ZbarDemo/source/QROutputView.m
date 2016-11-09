//
//  QROutputView.m
//  ZbarDemo
//
//  Created by caochao on 16/11/9.
//  Copyright © 2016年 snailCC. All rights reserved.
//

#import "QROutputView.h"
#import "UIImage+QRCodeImage.h"
@interface QROutputView(){
    
    CGFloat _width ;
}


@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) UIButton *closeButton;
@end

@implementation QROutputView

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        _width = CGRectGetWidth(TopWindow.frame);
        [self setupSubViews];
    }
    
    return self;
}
#pragma mark - Setup

- (void)setupSubViews{
    
    [self addSubview:self.imageView];
    [self addSubview:self.closeButton];
}
- (UIImageView *)imageView{

    if (!_imageView) {
        _imageView = [UIImageView newAutoLayoutView];
        
    }
    return _imageView;
}
- (UIButton *)closeButton{

    if (!_closeButton) {
        _closeButton = [UIButton newAutoLayoutView];
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonOnSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
#pragma mark - Update auto layout constraints

- (void)updateConstraints
{
    if (!self.didSetupConstraints)
    {
        
        [self.imageView autoCenterInSuperview];
        [self.imageView autoSetDimensionsToSize:CGSizeMake(_width*2/3, _width*2/3)];

        [self.closeButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.closeButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
        [self.closeButton autoSetDimensionsToSize:CGSizeMake(60, 60)];
        
        self.didSetupConstraints = YES;
        
    }
    
    [super updateConstraints];
}
- (void)setQRStr:(NSString *)QRStr{

    if (QRStr!=nil) {
        _QRStr = QRStr;
        self.imageView.image = [UIImage generateQRCodeImageWithInput:_QRStr withSize:_width];
    }
}
- (void)closeButtonOnSelected:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(outputView:viewOnClosed:)]) {
        [self.delegate outputView:self viewOnClosed:YES];
    }
}
@end
