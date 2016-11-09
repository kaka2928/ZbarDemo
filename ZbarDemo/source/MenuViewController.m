//
//  MenuViewController.m
//  ZbarDemo
//
//  Created by caochao on 16/11/9.
//  Copyright © 2016年 snailCC. All rights reserved.
//

#import "MenuViewController.h"
#import "QRResultView.h"
#import "QROutputView.h"
#import "QRInputView.h"
@interface MenuViewController ()<QROutputDelegate,QRInputDelegate>{

    CGFloat _margin;
    BOOL _isQROutputFlag;
}
@property (nonatomic,retain) UIButton *QRInputButton;
@property (nonatomic,retain) UIButton *QROutputButton;
@property (nonatomic,retain) QRResultView *resultView;
@property (nonatomic,retain) QROutputView *outputView;
@property (nonatomic,retain) QRInputView *inputView;
// Store some constraints that we intend to modify as part of the animation
@property (nonatomic, strong) NSLayoutConstraint *QROutputViewHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *QRInputViewHeightConstraint;

@property (nonatomic,assign) BOOL isAnimatingToEndState;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _margin = 20;
    self.navigationItem.title = @"二维码操作";
    // Do any additional setup after loading the view.
}
#pragma mark - layout
- (void)loadView
{
    self.view = [UIView new];
    
    [self.view addSubview:self.QRInputButton];
    [self.view addSubview:self.QROutputButton];
    [self.view addSubview:self.resultView];
    
    [self.view addSubview:self.outputView];
    [self.view addSubview:self.inputView];
    [self.view setNeedsUpdateConstraints]; // bootstrap Auto Layout
}

- (void)updateViewConstraints
{
    // Check a flag didSetupConstraints before creating constraints, because this method may be called multiple times, and we
    // only want to create these constraints once. Without this check, the same constraints could be added multiple times,
    // which can hurt performance and cause other issues. See Demo 7 (Animation) for an example of code that runs every time.
    if (!self.didSetupConstraints) {

        NSArray *buttons = @[self.QRInputButton,self.QROutputButton];
        
        CGFloat narbarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
        [self.QRInputButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:_margin*2+narbarHeight];
        
        [buttons autoSetViewsDimension:ALDimensionHeight toSize:_margin*2];
        
        // Distribute the views horizontally across the screen, aligned to one another's horizontal axis,
        // with 20 pt spacing between them and to their superview, and their widths matched equally
        [buttons autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:_margin insetSpacing:YES matchedSizes:YES];
        
        [self.resultView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.resultView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.resultView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [self.resultView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.QRInputButton withOffset:_margin];

        [self.outputView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.outputView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.outputView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        self.QROutputViewHeightConstraint =[self.outputView autoSetDimension:ALDimensionHeight toSize:0];

        [self.inputView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [self.inputView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.inputView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        self.QRInputViewHeightConstraint =[self.inputView autoSetDimension:ALDimensionHeight toSize:0];
    }
    CGFloat height = 0;
    if (self.isAnimatingToEndState) {
        
        height = CGRectGetHeight(self.view.frame);
        if (!_isQROutputFlag) {
            
            self.outputView.QRStr = self.resultView.text;
        }

    }
    if (!_isQROutputFlag) {
        
        self.QROutputViewHeightConstraint.constant = height;
    }else{
        
        self.QRInputViewHeightConstraint.constant = height;
    }
    
    self.didSetupConstraints = YES;
    [super updateViewConstraints];
}
#pragma mark - subviews
- (UIButton *)QRInputButton{

    if (!_QRInputButton) {
        _QRInputButton = [self newButtonWithTag:0];
   
    }
    return _QRInputButton;
}
- (UIButton *)QROutputButton{
    
    if (!_QROutputButton) {
        _QROutputButton = [self newButtonWithTag:1];
        
    }
    return _QROutputButton;
}
- (QRResultView *)resultView{

    if (!_resultView) {
        _resultView = [[QRResultView alloc]init];

    }
    return _resultView;
}
- (QROutputView *)outputView{

    if (!_outputView) {
        _outputView = [[QROutputView alloc]init];
        _outputView.delegate = self;
    }
    return _outputView;
}
- (QRInputView *)inputView{

    if (!_inputView) {
        _inputView = [[QRInputView alloc]init];
        _inputView.delegate = self;
    }
    return _inputView;
}
- (UIButton *)newButtonWithTag:(NSInteger)tag{

    NSArray *names =@[@"生成二维码",@"扫描二维码"];
    UIButton *button = [UIButton newAutoLayoutView];
    button.tag = tag;
    [button setTitle:names[tag] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonOnSelected:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    button.layer.borderWidth = 1.0;
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 2.0;
    
    return button;
}
#pragma mark - QROutputDelegate
- (void) outputView:(QROutputView *)outputView viewOnClosed:(BOOL)isClosed{

    if (isClosed) {
        [self animateLayoutWithRegularAnimation];
    }
}
#pragma mark - QRInputDelegate
- (void) inputView:(QROutputView *)inputView scanResult:(NSString *)scanResult {

    
    self.resultView.text = scanResult;
    [self animateLayoutWithRegularAnimation];

}
- (void) inputView:(QROutputView *)inputView viewOnClosed:(BOOL)isClosed {

    if (isClosed) {
        [self animateLayoutWithRegularAnimation];
    }
}
#pragma mark - private method
- (void)animateLayoutWithSpringAnimation
{
    // These 2 lines will cause -[updateViewConstraints] to be called again on this view controller, where the constraints will be adjusted to the new state
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    if (!_isQROutputFlag) {
        
        self.outputView.hidden = NO;
    }else{
        
         self.inputView.hidden = NO;
    }
    
   
    [UIView animateWithDuration:0.8
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0
                        options:0
                     animations:^{
                         self.outputView.alpha = 1.0;
                         self.inputView.alpha = 1.0;
                         [self.view layoutIfNeeded]; // this is what actually causes the views to animate to their new layout
                     }
                     completion:^(BOOL finished) {
                         // Run the animation again in the other direction
                         self.isAnimatingToEndState = !self.isAnimatingToEndState;
                         
                         if (_isQROutputFlag) {
                            [self.inputView startScan];
                         }
                         
                         
                     }];
}
- (void)animateLayoutWithRegularAnimation
{
    // These 2 lines will cause -[updateViewConstraints] to be called again on this view controller, where the constraints will be adjusted to the new state
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.outputView.alpha = 0.0;
                         self.inputView.alpha = 0.0;
                         [self.view layoutIfNeeded]; // this is what actually causes the views to animate to their new layout
                     }
                     completion:^(BOOL finished) {
                         // Run the animation again in the other direction
                         self.isAnimatingToEndState = !self.isAnimatingToEndState;
                         if (!_isQROutputFlag) {
                             
                             self.outputView.hidden = YES;
                         }else{
                             
                             self.inputView.hidden = YES;
                         }
                     }];
}
- (void)buttonOnSelected:(UIButton *)sender{

    _isQROutputFlag = sender.tag;
    [self.resultView resignFirstResponder];
    self.resultView.editable=NO;
    if (sender.tag == 0) {
        if ([self.resultView.text length]>0) {

            self.isAnimatingToEndState = YES;
            [self animateLayoutWithSpringAnimation];
            
        }else{
        
            [TopWindow makeToast:@"请输入内容"];
        }
    }else{
    
        
        self.isAnimatingToEndState = YES;
        [self animateLayoutWithSpringAnimation];
        
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{

    
}
@end
