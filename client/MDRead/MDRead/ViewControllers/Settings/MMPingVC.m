//
//  MMPingVC.m
//  MDRead
//
//  Created by midoks on 2017/6/23.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMPingVC.h"
#import "MMCommon.h"
#import "LDNetDiagnoService.h"

@interface MMPingVC () <LDNetDiagnoServiceDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextView *content;
@property (nonatomic, strong) LDNetDiagnoService *servie;
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, strong) NSString *logInfo;
@property (nonatomic, strong) UIButton *beginBtn;
@property (nonatomic, strong) UIButton *cpBtn;


@end

@implementation MMPingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

-(void)initUI
{
    //输出应用版本信息和用户ID
    
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    UIDevice *device = [UIDevice currentDevice];
   
    
    _logInfo = @"";
    _logInfo = [_logInfo stringByAppendingString:[NSString stringWithFormat:@"应用名称: %@\n", appName]];
    _logInfo = [_logInfo stringByAppendingString:[NSString stringWithFormat:@"应用版本: %@\n", appVersion]];
    _logInfo = [_logInfo stringByAppendingString:[NSString stringWithFormat:@"机器类型: %@\n", [device systemName]]];
    _logInfo = [_logInfo stringByAppendingString:[NSString stringWithFormat:@"系统版本: %@\n", [device systemVersion]]];
    _logInfo = [_logInfo stringByAppendingString:[NSString stringWithFormat:@"机器UUID : %@\n", [device identifierForVendor].UUIDString]];
    //_logInfo = [_logInfo stringByAppendingString:[NSString stringWithFormat:@"sUUID : %@\n", [device systemVersion]]];
    
    
    
    if([self isJailBreak]){
        _logInfo = [_logInfo stringByAppendingString:[NSString stringWithFormat:@"是否越狱: YES\n"]];
    } else {
        _logInfo = [_logInfo stringByAppendingString:[NSString stringWithFormat:@"是否越狱: NO\n"]];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;// 字体的行间距
    
    _content = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, MD_W - 20, MD_H - 70)];
    _content.text = _logInfo;
    _content.backgroundColor = [UIColor whiteColor];
    _content.textColor = [UIColor blackColor];
    _content.textAlignment = NSTextAlignmentLeft;
    _content.scrollEnabled = YES;
    _content.editable = NO;
    _content.linkTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:8],NSParagraphStyleAttributeName:paragraphStyle};
    [self.view addSubview:_content];
    
    
    
    
    _servie = [[LDNetDiagnoService alloc] initWithAppCode:appName
                                                  appName:appName
                                               appVersion:appVersion
                                                   userID:@"0"
                                                 deviceID:nil
                                                  dormain:nil
                                              carrierName:nil
                                           ISOCountryCode:nil
                                        MobileCountryCode:nil
                                            MobileNetCode:nil];
    _servie.delegate = self;
    
    _beginBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, MD_H - 110, MD_W - 20, 40)];
    [_beginBtn setTitle:@"开始诊断" forState:UIControlStateNormal];
    [_beginBtn setTintColor:[UIColor whiteColor]];
    [_beginBtn setBackgroundColor:[UIColor blueColor]];
    _beginBtn.layer.cornerRadius = 3;
    [_beginBtn addTarget:self action:@selector(startSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_beginBtn];
    _isRunning = NO;
    
    _cpBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, MD_H - 60, MD_W - 20, 40)];
    [_cpBtn setTitle:@"复制" forState:UIControlStateNormal];
    [_cpBtn setTintColor:[UIColor whiteColor]];
    [_cpBtn setBackgroundColor:[UIColor blueColor]];
    _cpBtn.layer.cornerRadius = 3;
    [_cpBtn addTarget:self action:@selector(copyText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cpBtn];
    
    //检查诊断地址
    if (!_apiUrl) {
        [self.navigationController popViewControllerAnimated:YES];
        [MMCommon showMessage:@"无诊断地址"];
    }
}

-(void)startSelected
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否traceroute"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self startNetDiagnosis];
        
    }];
    [alertController addAction:ok];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)startNetDiagnosis
{
    
    _beginBtn.hidden = YES;
  
    _logInfo = [_logInfo stringByAppendingString:[NSString stringWithFormat:@"诊断时间: %@\n\n",  [self getCurrentTime]]];
    _content.text = _logInfo;
    
    [_content resignFirstResponder];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *s = [[NSURL alloc] initWithString:_apiUrl];
        //MDLog(@"%@", s.host);
        _servie.dormain = s.host;
        if (!_isRunning) {
            [_servie startNetDiagnosis];
        } else {
            [_servie stopNetDialogsis];
        }
    });
    
}


#pragma mark - LDNetDiagnoServiceDelegate -
-(void)netDiagnosisDidStarted {
    //MDLog(@"开始诊断～～～");
}

-(void)netDiagnosisStepInfo:(NSString *)stepInfo {
    //MDLog(@"%@", stepInfo);
    _logInfo = [_logInfo stringByAppendingString:stepInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        _content.text = _logInfo;
    });
}

-(void)netDiagnosisDidEnd:(NSString *)allLogInfo
{
    //可以保存到文件，也可以通过邮件发送回来
    dispatch_async(dispatch_get_main_queue(), ^{
        //_content.text = allLogInfo;
        _isRunning = NO;
    });
}


#pragma mark - textFieldDelegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 复制诊断内容 -
-(void)copyText
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _content.text;
    
    [MMCommon showMessage:@"诊断内容复制成功"];
    
}

-(NSString *)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    //MDLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
}

#define ARRAY_SIZE(a) sizeof(a)/sizeof(a[0])

- (BOOL)isJailBreak
{
    const char* jailbreak_tool_pathes[] = {
        "/Applications/Cydia.app",
        "/Library/MobileSubstrate/MobileSubstrate.dylib",
        "/bin/bash",
        "/usr/sbin/sshd",
        "/etc/apt"
    };
    
    for (int i=0; i<ARRAY_SIZE(jailbreak_tool_pathes); i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]]) {
            NSLog(@"The device is jail broken!");
            return YES;
        }
    }
    NSLog(@"The device is NOT jail broken!");
    return NO;
}


@end
