//
//  ViewController.m
//  ParseBarcode
//
//  Created by snail on 14-8-8.
//  Copyright (c) 2014年 snail. All rights reserved.
//

#import "ParseBarcode.h"

@interface ParseBarcode ()<NSURLSessionDelegate>

@end
@implementation ParseBarcode
{
    //UIImageView *_scanAreaImageView;
    UIView *_scanLineView;
    UIView *_superView;
    UIView *_overlayImageView;
}

@synthesize reader = _reader;

-(void)dealloc
{
    _reader.readerDelegate = nil;
    [timer invalidate];
}

#pragma mark --Start scan barcode
-(ZBarReaderViewController *)makeReaderWithSuperView:(UIView *)superView
{
    if (!_reader)
    {
        NSLog(@"Scan Barcode");
        pressScanBtnTime = [NSDate date];
        iNum = 0;
        cancelFlag = 0;
        //init the timer to set the scan line in the initial location
        [timer invalidate];
        _reader = [[ZBarReaderViewController alloc] init];
        _reader.readerDelegate = self;
        _reader.showsZBarControls = NO;
        _reader.readerView.torchMode = 0;
        _reader.supportedOrientationsMask = UIInterfaceOrientationMaskPortrait;
        _reader.tracksSymbols = NO;
        
        //define the scan area

        CGFloat scale = 0.8;
        _reader.scanCrop = CGRectMake((1-scale)/2, (1-scale)/2, scale, scale);
        ZBarImageScanner *scanner = _reader.scanner;
        [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
        
        
        //reader view
        UIView *view = _reader.view;
        view.frame = CGRectMake(0, 0, CGRectGetWidth(superView.frame), CGRectGetHeight(superView.frame));

        view.center = CGPointMake(superView.bounds.size.width / 2, superView.bounds.size.height / 2);
        [superView addSubview:view];
        
        
        UIView *overlayImageView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(superView.frame)*(1-scale)/2, (CGRectGetHeight(superView.frame)-CGRectGetWidth(superView.frame)*scale)/2, CGRectGetWidth(superView.frame)*scale, CGRectGetWidth(superView.frame)*scale)];
        overlayImageView.layer.borderColor = [[UIColor redColor]CGColor];
        overlayImageView.layer.borderWidth = 2.0;
        [view addSubview:overlayImageView];
        overlayImageView.alpha = 1.0;
        _overlayImageView = overlayImageView;
        
        //line
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _overlayImageView.bounds.size.width, 2)];
        line.image = [UIImage imageNamed:@"progress"];
        line.backgroundColor = [UIColor clearColor];
        [_overlayImageView addSubview:line];
        _scanLineView = line;
        timer = [NSTimer scheduledTimerWithTimeInterval:.005 target:self selector:@selector(scanAction) userInfo:nil repeats:YES];
    }
    _superView = superView.superview;
    //_superView = [[[UIApplication sharedApplication] delegate] window];
    
    return _reader;
}

-(void)scanAction
{
    int currentLineY = _scanLineView.frame.origin.y;
    if (currentLineY >= _overlayImageView.bounds.size.height)
    {
        currentLineY = 0;
    }
    currentLineY++;
    _scanLineView.frame = CGRectMake(0, currentLineY, _overlayImageView.bounds.size.width, 2);
}

//used to move the scan line and make the scan area look like real
//-(void)scanAction
//{
//    if (iNum >= _reader.view.bounds.size.height - [UIView standardHeight:25])
//    {
//        iNum = [UIView standardHeight:25];
//    }
//    iNum++;
//    scanLine.frame = CGRectMake(_reader.view.bounds.origin.x, _reader.view.bounds.origin.y+iNum, _reader.view.bounds.size.width, 2);
//}

#pragma mark --Start to parse barcode
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Parse Barcode");
//    [picker.view removeFromSuperview];
//    [picker removeFromParentViewController];
    
    //use an image to pick the barcode information and parse it to the string value
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    ZBarReaderController * read = [ZBarReaderController new];
    read.readerDelegate = self;
    CGImageRef cgImageRef = image.CGImage;
    ZBarSymbol * symbol = nil;
    id <NSFastEnumeration> results = [read scanImage:cgImageRef];
    for (symbol in results)
    {
        break;
    }
    NSString * result;          //used to pick the parse result of the barcode
    if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
    {
        result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
    }
    else
    {
        result = symbol.data;
    }
    //if the barcode can't be parsed, will show the error messgae
    if ([self.delegate respondsToSelector:@selector(parseBarcode:scanResult:)]) {
        [self.delegate parseBarcode:self scanResult:result];
    }
    cancelFlag = 1;
    [self cancelToMainView]; 
}




//pick the response from the server and show the message code if something wrong


#pragma mark --Cancel to the formal view
-(void)cancelToMainView
{
    NSTimeInterval d = -[pressScanBtnTime timeIntervalSinceNow];
    NSLog(@"time: %f, flag: %d",d,cancelFlag);
    if (d < 1) {
        if (cancelFlag == 1) {
            
        }
        else
        {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告！" message:@"操作太过频繁！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];

        }
    }
    else
    {
        NSLog(@"Press Cancel Button");
        //[_reader.view removeFromSuperview];
        //    [reader removeFromParentViewController];
    }
}

@end
