//
//  MMCommon.m
//  MDRead
//
//  Created by midoks on 16/5/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMCommon.h"
#import <CommonCrypto/CommonDigest.h>

@interface MMCommon()

@end

@implementation MMCommon


#pragma mark - 异步任务 -
+(void)asynTask:(void (^)())task
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            task();
        });
    });
}

#pragma mark - 随机颜色 -
+(UIColor *)randomColor
{
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

#pragma mark - 获取值(test) -
+(NSArray *) getRgbWithColor:(UIColor *)color
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}



-(void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
}

-(void)showAlert
{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"添加收藏成功!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:NO];
    [promptAlert show];
}


#pragma mark - 消息 -
+(void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window.superview removeFromSuperview];
    
    UIView *showview =  [[UIView alloc] init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 2.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc] init];
    
    
    UIFont *font = [UIFont systemFontOfSize:17];
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize bSzie = CGSizeMake(200, CGFLOAT_MAX);
    
    CGRect LabelSize = [message boundingRectWithSize:bSzie
                                      options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes: attribute
                                      context:nil];
    
    //NSLog(@"%@", NSStringFromCGRect(LabelSize));
    
    label.frame = CGRectMake(5, 5, ceil(LabelSize.size.width) + 10, ceil(LabelSize.size.height));
    label.text = message;
    label.numberOfLines = 0; //多行显示
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    [showview addSubview:label];
    
    CGSize Psize = [[UIScreen mainScreen] bounds].size;
    showview.frame = CGRectMake((Psize.width - (LabelSize.size.width + 20))/2, (Psize.height)/2,
                                ceil(LabelSize.size.width) + 20, ceil(LabelSize.size.height) + 10);
    
    [UIView animateWithDuration:3.0 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

#pragma mark - 加密相关 -
+(NSString *)md5:(NSString *)md5Str
{
    const char *cStr = [md5Str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);

    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0],result[1],result[2],result[3],
            result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],
            result[12],result[13],result[14],result[15]
            ];
}

+(NSString *)fileMd5:(NSString *)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    if( handle == nil ) {
        return @"Error File";
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    
    while (!done) {
        NSData *fileData = [handle readDataOfLength:1024];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if( [fileData length] == 0 ) {
            done = YES;
        }
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            digest[0],digest[1],digest[2],digest[3],
            digest[4],digest[5],digest[6],digest[7],
            digest[8],digest[9],digest[10],digest[11],
            digest[12],digest[13],digest[14],digest[15]
            ];
}

#pragma mark - 创建文件路径 -
+(BOOL)createFilePath:(NSString *)path
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path]){
        return TRUE;
    }
    
    @try {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        return TRUE;
    } @catch (NSException *exception) {
    } @finally {}
    
    return FALSE;
}

#pragma mark - 文档相关方法 -

+(NSString *)modelPathName
{
    return @"MDRead";
}

#pragma mark - 文档保存 -
+(BOOL)docsModelSave:(NSString *)webSite folderName:(NSString *)folderName fileName:(NSString *)fileName object:(NSObject *)object
{
    NSString *docsPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject;
    NSString *modelPathName = [self modelPathName];
    NSString *modelPath = [NSString stringWithFormat:@"%@/%@/%@/%@/", docsPath, modelPathName, webSite, folderName];
    
    if( [self createFilePath:modelPath] ){
        modelPath = [NSString stringWithFormat:@"%@/%@.txt", modelPath, fileName];
        [NSKeyedArchiver archiveRootObject:object toFile:modelPath];
    }
    
    //MDLog(@"%@", modelPath);
    return TRUE;
}

#pragma mark - 读取文档 -
+(id)docsModelGet:(NSString *)webSite folderName:(NSString *)folderName fileName:(NSString *)fileName
{
    NSString *docsPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject;
    NSString *modelPathName = [self modelPathName];
    NSString *modelPath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@.txt", docsPath, modelPathName, webSite, folderName, fileName];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:modelPath];
}


#pragma mark - 文档判断 -
+(BOOL)isExistDocsModel:(NSString *)webSite folderName:(NSString *)folderName fileName:(NSString *)fileName
{
    NSString *docsPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).lastObject;
    NSString *modelPathName = [self modelPathName];
    NSString *modelPath = [NSString stringWithFormat:@"%@/%@/%@/%@/%@.txt", docsPath, modelPathName, webSite, folderName,fileName];
    //MDLog(@"file:%@", modelPath);
    return [[NSFileManager defaultManager] fileExistsAtPath:modelPath];
}

@end
