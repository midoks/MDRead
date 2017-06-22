//
//  MMScanVIew.m
//  MDRead
//
//  Created by midoks on 2017/6/21.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMScanVIew.h"
#import <AVFoundation/AVFoundation.h>

/** 二维码冲击波动画时间 */
#define scanLineAmTime 0.05

@interface MMScanVIew()

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIImageView *imageLine;

@end

@implementation MMScanVIew



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
//    MDLog(@"MMScanVIew init")
    
    //屏幕框
    _imagePick = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"md_scan_pick"]];
    CGFloat wh = MD_FW *0.6;
    _imagePick.frame = CGRectMake( (MD_FW - wh)/2, (MD_FH-wh)/2, wh, wh);
    [self addSubview:_imagePick];
    
    
    //扫描线
    _imageLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"md_scan_line"]];
    _imageLine.frame = CGRectMake( (MD_FW - wh)/2, (MD_FH-wh)/2, wh, 4);
    [self addSubview:_imageLine];
    
    
    //扫描动画
    //    CABasicAnimation *lineAm = [CABasicAnimation animationWithKeyPath:@"scan_line"];
    //    lineAm.duration = 1;
    //    lineAm.beginTime = CACurrentMediaTime();
    //    lineAm.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //    lineAm.removedOnCompletion = YES;
    //    lineAm.repeatCount = HUGE_VALF;
    //    lineAm.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    //    lineAm.toValue =  [NSValue valueWithCGPoint:CGPointMake(320, 480)];
    //    lineAm.fillMode = kCAFillModeForwards;
    //    lineAm.autoreverses = YES;
    //    [imageLine.layer addAnimation:lineAm forKey:@"imageLine"];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:scanLineAmTime target:self selector:@selector(scanLineAm) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    
    
    //阴影设置
    CAShapeLayer *shadowLayer = [[CAShapeLayer alloc] init];
    shadowLayer.path = [UIBezierPath bezierPathWithRect:self.frame].CGPath;
    shadowLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.75].CGColor;
    shadowLayer.mask = [self makeMaskLayer:self.frame exceptRect:_imagePick.frame];
    [self.layer addSublayer:shadowLayer];
    
    CAShapeLayer *scanLayer = [[CAShapeLayer alloc] init];
    scanLayer.path = [UIBezierPath bezierPathWithRect:_imagePick.frame].CGPath;
    scanLayer.fillColor = [UIColor clearColor].CGColor;
    scanLayer.strokeColor = [UIColor grayColor].CGColor;
    [self.layer addSublayer:scanLayer];
    
    
    
    // 提示Label
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.backgroundColor = [UIColor clearColor];
    CGFloat promptLabelX = 0;
    CGFloat promptLabelY = CGRectGetMaxY(_imagePick.frame) + 30;
    CGFloat promptLabelW = self.frame.size.width;
    CGFloat promptLabelH = 25;
    promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
    promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    [self addSubview:promptLabel];
    
    // 添加闪光灯按钮
    UIButton *light_button = [[UIButton alloc] init];
    CGFloat light_buttonX = 0;
    CGFloat light_buttonY = CGRectGetMaxY(promptLabel.frame) + 10;
    CGFloat light_buttonW = self.frame.size.width;
    CGFloat light_buttonH = 25;
    light_button.frame = CGRectMake(light_buttonX, light_buttonY, light_buttonW, light_buttonH);
    [light_button setTitle:@"打开照明灯" forState:UIControlStateNormal];
    [light_button setTitle:@"关闭照明灯" forState:UIControlStateSelected];
    [light_button setTitleColor:promptLabel.textColor forState:(UIControlStateNormal)];
    light_button.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [light_button addTarget:self action:@selector(lightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:light_button];
    
    
    return self;
}


#pragma mark - 扫描动画 -
-(void)scanLineAm
{
    //CGRect frameOrgin = _imageLine.frame;
    __block CGRect frame = _imageLine.frame;
    //MDLog(@"%f:%f",_imageLine.frame.origin.y, _imagePick.frame.origin.y);
    
    CGFloat maxLineY = _imagePick.frame.origin.y + _imagePick.frame.size.height - 10;
    if (_imageLine.frame.origin.y > maxLineY) {
        
        frame.origin.y = _imagePick.frame.origin.y;
        _imageLine.frame = frame;
        
    } else {
        
        [UIView animateWithDuration:scanLineAmTime animations:^{
            frame.origin.y += 5;
            _imageLine.frame = frame;
        } completion:nil];
    }
    
}

#pragma mark - 照明灯的点击事件 -
- (void)lightBtnAction:(UIButton *)button {
    if (button.selected == NO) {
        [self turnOnLight:YES];
        button.selected = YES;
    } else {
        [self turnOnLight:NO];
        button.selected = NO;
    }
}

-(void)turnOnLight:(BOOL)on
{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([_device hasTorch]) {
        [_device lockForConfiguration:nil];
        if (on) {
            [_device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [_device setTorchMode: AVCaptureTorchModeOff];
        }
        [_device unlockForConfiguration];
    }
}

-(CAShapeLayer * )makeMaskLayer:(CGRect)rect exceptRect:(CGRect)exceptRect
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    

    if ( !CGRectContainsRect(rect, exceptRect) ){
        return maskLayer;
    } else if (CGRectEqualToRect(rect, exceptRect)) {
        maskLayer.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
        return maskLayer;
    }
    
    CGFloat aX = rect.origin.x;
    CGFloat aY = rect.origin.y;
    //CGFloat aW = rect.size.width;
    CGFloat aH = rect.size.height;
    
    CGFloat bX = exceptRect.origin.x;
    CGFloat bmX = exceptRect.origin.x + exceptRect.size.width;
    CGFloat bY = exceptRect.origin.y;
    CGFloat bmY = exceptRect.origin.y + exceptRect.size.height;
    CGFloat bW = exceptRect.size.width;
    //CGFloat bH = exceptRect.size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(aX, aY, bX, aH)];
    [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(bX, aY, bW, bY)]];
    [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(bmX, aY, bX, aH)]];
    [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(bX, bmY, bW, aH - bmY)]];

    maskLayer.path = path.CGPath;
    
    return maskLayer;
}

#pragma mark - 停止扫描 -
-(void)stopScan
{
    [self.timer invalidate];
    self.timer = nil;
}


@end
