//
//  MMScanVC.m
//  MDRead
//
//  Created by midoks on 2017/6/20.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMScanVC.h"
#import "MMCommon.h"
#import "MMNovelApi.h"
#import "MMSystemInfo.h"
#import "MMScanVIew.h"
#import "MMSourceListModel.h"
#import <AVFoundation/AVFoundation.h>

@interface MMScanVC () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *session;
    AVCaptureVideoPreviewLayer *layer;
    MMScanVIew *scanVIew;
    
}

@end

@implementation MMScanVC


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [scanVIew stopScan];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    MMSourceListModel *source = [MMSourceListModel shareInstance];
//    [source addSource:@"https://raw.githubusercontent.com/midoks/MDRead/master/docs/api/index.json" title:@"Github测试"];
    
    [self initUI];
}


-(void)initUI
{
    UILabel *loading = [[UILabel alloc] initWithFrame:self.view.frame];
    loading.text = @"加载中";
    loading.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:loading];
    
    scanVIew = [[MMScanVIew alloc] initWithFrame:self.view.frame];
    
    [MMCommon asynTask:^{
        [self initScan];
        [loading removeFromSuperview];
    }];
}

-(void)initScan
{
    NSError * error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    session = [[AVCaptureSession alloc] init];
    AVCaptureInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (!input) {
        [MMCommon show:@"" message:@"无法使用" time:1.5f];
        [self closeVC];
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
    layer.frame = self.view.frame;
    [self.view.layer insertSublayer:layer above:0];
    [self.view addSubview:scanVIew];
    
    //MDLog(@"scanVIew.imagePick.frame:%@", NSStringFromCGRect(scanVIew.imagePick.frame));
    output.rectOfInterest = CGRectMake(0.2,0.2, 0.6, 0.6);
    //MDLog(@"intertRect:%@", NSStringFromCGRect(output.rectOfInterest));
    
    [session startRunning];
}

-(void)closeVC
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [self palySoundName:@"sound.caf"];
    
    MDLog(@"url:%@", code);
    
    BOOL vail = [self vaildURLForString:code];
    if (vail) {
        
        [[MMNovelApi shareInstance] test:code success:^{
            [MMCommon showMessage:@"验证通过" time:1.0 callback:^{
                
                [self closeVC];
                MMSourceListModel *source = [MMSourceListModel shareInstance];
                NSString *title = [[MMNovelApi shareInstance] getApiTitle];
                [source addSource:code title:title];
            }];
            
        } failure:^(int ret_code, NSString *ret_msg) {
            
            MDLog(@"sss:%d:%@", ret_code, ret_msg);
            
            [MMCommon showMessage:ret_msg time:1.0  callback:^{
                [self closeVC];
            }];
        }];
        
    } else {
        [MMCommon showMessage:code];
        [self closeVC];
    }
    
    [session stopRunning];
}


#pragma mark - 验证是否是正确的URL -
- (BOOL)vaildURLForString:(NSString *)strUrl
{
    NSError *error;
    NSString *regulaStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matchs = [regex matchesInString:strUrl options:0 range:NSMakeRange(0, [strUrl length])];
    
    if ( [matchs count] > 0 ) {
        return TRUE;
    }
    return FALSE;
}

#pragma mark -  播放声音 -
-(void)palySoundName:(NSString *)name
{
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    AudioServicesPlaySystemSound(soundID);
}

//-(void)soundCompleteCallback(SystemSoundID soundID, void *clientData)
//{
//}

@end
