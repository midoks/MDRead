//
//  MMCommon.h
//  MDRead
//
//  Created by midoks on 16/5/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^mdItemClick)(NSDictionary *item);

@interface MMCommon : NSObject


+(void)asynTask:(void (^)())task;
+(UIColor *)randomColor;
+(NSArray *) getRgbWithColor:(UIColor *)color;

+(void)showMessage:(NSString *)message;

#pragma mark - 加密相关 -
+(NSString *)md5:(NSString *)md5Str;
+(NSString *)fileMd5:(NSString *)path;

#pragma mark - 文档相关方法 -
+(BOOL)isExistDocsModel:(NSString *)webSite folderName:(NSString *)folderName fileName:(NSString *)fileName;
+(BOOL)docsModelSave:(NSString *)webSite folderName:(NSString *)folderName fileName:(NSString *)fileName object:(NSObject *)object;
+(id)docsModelGet:(NSString *)webSite folderName:(NSString *)folderName fileName:(NSString *)fileName;
@end
