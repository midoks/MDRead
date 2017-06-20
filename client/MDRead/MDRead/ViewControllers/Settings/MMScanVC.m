//
//  MMScanVC.m
//  MDRead
//
//  Created by midoks on 2017/6/20.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMScanVC.h"
#import <AVFoundation/AVFoundation.h>

@interface MMScanVC () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *layer;
    
}

@end

@implementation MMScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
}


-(void)initUI
{
    [self initScan];
}


-(BOOL)isCanUsed
{
    NSError * error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    AVCaptureInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        MDLog(@"input:%@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

-(void)initScan
{
    
    NSError * error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    session = [[AVCaptureSession alloc] init];
    AVCaptureInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        MDLog(@"input:%@", [error localizedDescription]);
        return;
    }
    
    
    [session addInput:input];
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    [session addOutput:output];
    
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code];
    
    layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    
    layer.frame = CGRectMake(self.view.center.x - 140, self.view.center.y -140, 280, 280);
    [self.view.layer insertSublayer:layer above:0];
    
    [session startRunning];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate -

-(void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *code = nil;
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            code = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            break;
        }
    }
    
    
    MDLog(@"code:%@", code);
    
    
    [session stopRunning];
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
