//
//  QROutputViewController.m
//  ZbarDemo
//
//  Created by caochao on 16/11/9.
//  Copyright © 2016年 snailCC. All rights reserved.
//

#import "QROutputViewController.h"

@interface QROutputViewController (){

    CGFloat _width ;
}
@property (nonatomic,retain) UIImageView *QRImageView;
@end

@implementation QROutputViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    _QRImageView.image = [UIImage generateQRCodeImageWithInput:self.QRStr withSize:_width];
}
#pragma mark - layout
- (void)loadView
{
    self.view = [UIView new];
    
    [self.view addSubview:self.QRImageView];
    
    [self.view setNeedsUpdateConstraints]; // bootstrap Auto Layout
}

- (void)updateViewConstraints
{
    // Check a flag didSetupConstraints before creating constraints, because this method may be called multiple times, and we
    // only want to create these constraints once. Without this check, the same constraints could be added multiple times,
    // which can hurt performance and cause other issues. See Demo 7 (Animation) for an example of code that runs every time.
    if (!self.didSetupConstraints) {
        

        [self.QRImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:_width/2];
        [self.QRImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:_width/2];
        [self.QRImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:_width/2];
        [self.QRImageView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:self.QRImageView];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}
#pragma mark - subviews
- (UIImageView *)QRImageView{


    if (!_QRImageView) {
        _QRImageView = [UIImageView newAutoLayoutView];
        
        _QRImageView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        _QRImageView.layer.borderWidth = 1.0;
        _QRImageView.layer.cornerRadius = 2.0;
    }
    return _QRImageView;
}
@end
