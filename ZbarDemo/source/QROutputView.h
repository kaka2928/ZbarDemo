//
//  QROutputView.h
//  ZbarDemo
//
//  Created by caochao on 16/11/9.
//  Copyright © 2016年 snailCC. All rights reserved.
//

#import "BasicView.h"

@class QROutputView;
@protocol QROutputDelegate <NSObject>

- (void) outputView:(QROutputView *)outputView viewOnClosed:(BOOL)isClosed;

@end


@interface QROutputView : BasicView
@property (nonatomic,assign) id<QROutputDelegate>delegate;
@property (nonatomic,retain) NSString *QRStr;
@end
