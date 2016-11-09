//
//  QRInputView.m
//  ZbarDemo
//
//  Created by caochao on 16/11/9.
//  Copyright © 2016年 snailCC. All rights reserved.
//

#import "QRInputView.h"
#import "ParseBarcode.h"

@interface QRInputView ()<UIAlertViewDelegate,ParseBarcodeDelegate>
@property (nonatomic,retain)ParseBarcode *barCoder;
@property (nonatomic,retain) UIView *readerBg;
@property (nonatomic,retain) UIButton *closeButton;
@end

@implementation QRInputView

- (instancetype)init{
    
    if (self = [super init]) {
        
    }
    
    return self;
}
#pragma mark - Setup

- (void)setupSubViews{
    
    self.didSetupConstraints = NO;
    [self addSubview:self.readerBg];
    [_readerBg addSubview:self.closeButton];
    [self setNeedsLayout];
}
- (UIButton *)closeButton{
    
    if (!_closeButton) {
        _closeButton = [UIButton newAutoLayoutView];
        [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonOnSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UIView *)readerBg{

    if (!_readerBg) {
        _readerBg = [UIView newAutoLayoutView];
        
        _readerBg.clipsToBounds = YES;
      
    }
    return _readerBg;
}
#pragma mark - Update auto layout constraints

- (void)updateConstraints
{
    if (!self.didSetupConstraints)
    {
        if (_readerBg!=nil) {
            [self.closeButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.closeButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
            [self.closeButton autoSetDimensionsToSize:CGSizeMake(60, 60)];
            
            [self.readerBg autoPinEdgesToSuperviewEdges];
        }
        self.didSetupConstraints = YES;
        
    }
    
    [super updateConstraints];
}
- (void)startScan{

    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请在iPhone的“设置-隐私-相机”中，允许访问你的相机。" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
        
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _barCoder = [[ParseBarcode alloc] init];
            _barCoder.delegate = self;
            //bg
             [self setupSubViews];
            [_barCoder makeReaderWithSuperView:_readerBg];
            
            //start
            _barCoder.reader.readerView.zoom = 10;
            [_barCoder.reader.readerView start];
            _barCoder.reader.readerView.layer.borderWidth = _barCoder.reader.view.layer.borderWidth = 0;
            [_readerBg bringSubviewToFront:self.closeButton];
        });
    });
}
- (void)stopScan{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_barCoder.reader.readerView stop];
        });
    });
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"%ld",(long)buttonIndex);
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>8.0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
#pragma mark - ParseBarcodeDelegate
- (void) parseBarcode:(ParseBarcode *)parseBarcode scanResult:(NSString *)scanResult{

    [self stopScan];
    if ([self.delegate respondsToSelector:@selector(inputView:scanResult:)]) {
        [self.delegate inputView:self scanResult:scanResult];
    }
}
- (void)closeButtonOnSelected:(UIButton *)sender{
    
    [self stopScan];
    if ([self.delegate respondsToSelector:@selector(inputView:viewOnClosed:)]) {
        [self.delegate inputView:self viewOnClosed:YES];
    }
}
@end
