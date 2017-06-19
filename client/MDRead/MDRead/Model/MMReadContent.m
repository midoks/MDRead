//
//  MMReadContent.m
//  MDRead
//
//  Created by midoks on 2017/6/3.
//  Copyright © 2017年 midoks. All rights reserved.
//

#import "MMReadContent.h"
#import "MMReadChapterModel.h"
#import "MMCommon.h"
#import "MMNovelApi.h"
#import <CoreText/CoreText.h>

@interface MMReadContent() <NSCoding>

@end


@implementation MMReadContent

-(id)init
{
    self = [super init];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
     _content = [aDecoder decodeObjectForKey:@"content"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_content forKey:@"content"];
}

+(MMReadContent*)shareInstance
{
    static  MMReadContent *shareInstance = NULL;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[MMReadContent alloc] init];
    });
    return shareInstance;
}


#pragma mark - 获取文章内容 -
-(void)getChapterInfo:(MMReadChapterModel *)chapterInfo
          success:(void (^)(id responseObject))success
          failure:(void (^)(int ret_code, NSString *ret_msg))failure;
{
    
    NSString *book_id = chapterInfo.bid;
    NSString *chapter_id = chapterInfo.cid;
    NSString *source_id = chapterInfo.sid;
    
    NSString *folderName = [NSString stringWithFormat:@"%@_%@", book_id, source_id];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@", book_id, chapter_id];

    
    BOOL r = [MMCommon isExistDocsModel:[self getWebSite] folderName:folderName fileName:fileName];
    if (r) {
        MMReadContent *m = [MMCommon docsModelGet:[self getWebSite] folderName:folderName fileName:fileName];
        MDLog(@"cahce chapter content:%@", fileName);
        NSMutableArray *page = [self contentParse:m.content];
        NSValue *v = [page objectAtIndex:0];
        NSRange c;
        [v getValue:&c];
        
        MDLog(@"text_nsrange:%@", NSStringFromRange(c));
        
        
        NSString *text = [m.content substringWithRange:c];
        
        MDLog(@"text:%@", text);
    
        success(text);
    } else {
        [[MMNovelApi shareInstance] BookContent:book_id chapter_id:chapter_id source_id:source_id success:^(id responseObject) {
            MDLog(@"net chapter content:%@", fileName);
            
            _content = [responseObject objectForKey:@"content"];
            
            
            [self contentParse:_content];
            [MMCommon docsModelSave:[self getWebSite] folderName:folderName fileName:fileName object:self];
            success(_content);
        } failure:^(int ret_code, NSString *ret_msg) {
            failure(ret_code, ret_msg);
        }];
    }
}

-(NSMutableArray *)contentParse:(NSString *)content
{
    
    MDLog(@"content:%@", content);
    NSMutableArray *page = [[NSMutableArray alloc] init];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 6; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.f];
    
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paraStyle,
                          NSKernAttributeName:@1.5f};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:content attributes:dic];
    CTFramesetterRef framesetter =  CTFramesetterCreateWithAttributedString( (CFAttributedStringRef) attrString );
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, 320, 568) );
    
    NSRange rangeText = NSMakeRange(0, 0);
    NSInteger rangeOffset = 0;
    
    do {
        
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(rangeOffset, 0), path, nil);
        CFRange nn = CTFrameGetVisibleStringRange(frame);
        
        MDLog(@"page -- location:%ld,length:%ld", nn.location, nn.length);
        
        rangeOffset += nn.length;
        rangeText.location = nn.location;
        rangeText.length = nn.length;
        
        MDLog(@"page -- rangeText -- location:%ld,length:%ld", (unsigned long)rangeText.location, (unsigned long)rangeText.length);
        
        NSValue *value = [NSValue valueWithBytes:&rangeText objCType:@encode(NSRange)];
        [page addObject:value];
        
    } while (rangeText.location + rangeText.length < attrString.length);
    
    return page;
}

#pragma mark - 获取来源地址 -
-(NSString *)getWebSite
{
    return @"website";
}

@end
