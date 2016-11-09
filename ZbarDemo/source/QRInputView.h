//
//  QRInputView.h
//  ZbarDemo
//
//  Created by caochao on 16/11/9.
//  Copyright © 2016年 snailCC. All rights reserved.
//

#import "BasicView.h"


@class QRInputView;
@protocol QRInputDelegate <NSObject>

- (void) inputView:(QRInputView *)inputView scanResult:(NSString *)scanResult ;
- (void) inputView:(QRInputView *)inputView viewOnClosed:(BOOL)isClosed ;

@end
@interface QRInputView : BasicView

@property (nonatomic,assign) id<QRInputDelegate>delegate;
- (void)startScan;
- (void)stopScan;
@end
