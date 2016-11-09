//
//  ViewController.h
//  ParseBarcode
//
//  Created by snail on 14-8-8.
//  Copyright (c) 2014年 snail. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@class ParseBarcode;
@protocol ParseBarcodeDelegate <NSObject>

- (void) parseBarcode:(ParseBarcode *)parseBarcode scanResult:(NSString *)scanResult ;


@end


@interface ParseBarcode : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate>
{
    UIImageView *scanLine;          //used to show the scan line
    NSTimer *timer;                 //used to move the scan line
    int iNum;                       //used to show the scan line to move in the scan area
    NSDate *pressScanBtnTime;       //used to write down the time of pressing the scan barcode button
    int cancelFlag;
//    UILabel *alterShow;
}
@property (nonatomic,assign) id<ParseBarcodeDelegate> delegate;
@property (strong, nonatomic, readonly) ZBarReaderViewController *reader;     //used to add a subview of the camera overlay view to scan the barcode

-(ZBarReaderViewController *)makeReaderWithSuperView:(UIView *)superView;

@end
