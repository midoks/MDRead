//
//  MMNovelViewController.m
//  MDRead
//
//  Created by midoks on 16/4/12.
//  Copyright © 2016年 midoks. All rights reserved.
//

#import "MMBookMarkVC.h"


@interface MMBookMarkVC ()

@property (nonatomic, assign) int totalPages;
@property (nonatomic, assign) int currentPage;
//@property (nonatomic) NSInteger *totalPages;
@property (nonatomic, strong) UILabel *text;

@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) UIFont *tfont;

@end

@implementation MMBookMarkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小说";
    _totalPages = 0;
    _currentPage = 0;
    
    //_tfont = [UIFont fontWithName:@"Arial-BoldItalicMT"size:14];
    _tfont = [UIFont systemFontOfSize:12.0];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"txt"];
    
    //    NSFileManager *fm = [NSFileManager defaultManager];
    //
    //    NSData *data = [[NSData alloc] init];
    //    data = [fm contentsAtPath:path];
    //
    //    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    //    NSLog(@"%@", data);
    
    _content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"NSString类方法读取的内容是：\n%@",content);
    _content = [_content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    //_content = [_content stringByReplacingOccurrencesOfString:@" " withString:@"|"];
    _content = [_content stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    _content = [_content stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    
    //NSLog(@"%@", _content);
    
    
    _text = [[UILabel alloc] initWithFrame:CGRectMake(5, 80, 310, 200)];
    _text.backgroundColor = [UIColor yellowColor];
    _text.numberOfLines = 0;
    _text.lineBreakMode = NSLineBreakByCharWrapping; // NSLineBreakByClipping |NSLineBreakByCharWrapping
    //_text.adjustsFontSizeToFitWidth = TRUE;
    _text.text = _content;
    //_text.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    //[_text setTextContainerInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_text setFont:_tfont];//[UIFont systemFontOfSize:14.0]];
    //[_text setSelectable:FALSE];
    //[_text setEditable:FALSE];
    
    //    CGSize totalTextSize = [content sizeWithFont:[UIFont systemFontOfSize:14]
    //                               constrainedToSize:CGSizeMake(_text.frame.size.width, CGFLOAT_MAX)
    //                                   lineBreakMode:NSLineBreakByWordWrapping];
    //
    //    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    //    CGRect totalTextSize2 = [content boundingRectWithSize:CGSizeMake(_text.frame.size.width, CGFLOAT_MAX) options:options attributes:nil context:nil];
    //
    //
    //    NSLog(@"%f",totalTextSize.height);
    //    NSLog(@"%@", NSStringFromCGRect(totalTextSize2));
    //NSLog(@"%d", content.length);
    NSLog(@"begin");
    _list = [self getPagesOfString5:_content withFont:_tfont withRect:_text.frame];
    //NSLog(@"%@", list);
    
    
    
    UIButton *l = [[UIButton alloc] initWithFrame:CGRectMake(20, 300, 60, 30)];
    [l setBackgroundColor:[UIColor redColor]];
    [l setTitle:@"next" forState:UIControlStateNormal];
    [l addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:l];
    
    UIButton *r = [[UIButton alloc] initWithFrame:CGRectMake(90, 300, 60, 30)];
    [r setBackgroundColor:[UIColor redColor]];
    [r setTitle:@"prev" forState:UIControlStateNormal];
    [r addTarget:self action:@selector(prevAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:r];
    
    
//    NSLog(@"%@", _list);
//    
//    for (NSValue *r in _list) {
//        NSLog(@"%@", r);
//        
//        NSRange newRange;
//        [r getValue:&newRange];
//        
//        NSString *v = [_content substringWithRange:newRange];
//        NSLog(@"---------------------------\n%@",v);
//    }
    
    NSLog(@"end");
    
    [self.view addSubview:_text];
}


-(void)nextAction:(UIButton *)uib
{
    
    //NSLog(@"%d, limit:%u", _currentPage, _list.count - 1);
    if(_currentPage > _list.count - 1) {
        NSLog(@"超过限制了");
        //return;
    } else if (_currentPage == (_list.count - 1)){
        NSLog(@"最后一页");
    } else {
        _currentPage++;
    }
    NSValue *r = _list[ _currentPage];
    
    NSRange newRange;
    [r getValue:&newRange];
    
    NSString *v = [_content substringWithRange:newRange];
    NSLog(@"---------------------------\n%@",v);
    
    
    _text.text = v;
    
}

-(void)prevAction:(UIButton *)uib
{
    NSLog(@"%d", _currentPage);
    if(_currentPage < 1) {
        
        NSLog(@"超过限制了");
        //return;
    } else {
        _currentPage--;
    }
    
    NSValue *r = _list[ _currentPage];
    
    NSRange newRange;
    [r getValue:&newRange];
    
    NSString *v = [_content substringWithRange:newRange];
    NSLog(@"---------------------------\n%@",v);
    
    
    _text.text = v;
    
}

//- (NSArray *)getPagesOfString:(NSString *)cache withFont:(UIFont *)font withRect:(CGRect)rect {
//
//    CGFloat lineHeight = [@"本" sizeWithFont:[UIFont systemFontOfSize:14.0]].height;
//    NSInteger maxLine=floor(rect.size.height/lineHeight);
//
//    NSLog(@"%ld", (long)maxLine);
//    //NSLog(@"height:%d, lineHeight:%f", 200, lineHeight);
//
//    NSArray *paragraphs=[cache componentsSeparatedByString:@"\n"];
//
//    NSString *lastPLeft = nil;
//    NSInteger totalLines = 0;
//    NSRange range = NSMakeRange(0, 0);
//    NSMutableArray *ranges=[NSMutableArray array];
//
//    //NSLog(@"%d", [paragraphs count]);
//
//    for(int p=0;p<[paragraphs count];p++){
//
//        //NSLog(@"%@", paragraphs[p]);
//
//
//        NSString *para;
//
//        if (lastPLeft != nil) {
//
//            para = lastPLeft;
//            lastPLeft = nil;
//
//        } else  {
//            para = [paragraphs objectAtIndex:p];
////            if(p < [paragraphs count] - 1){
////                para = [para stringByAppendingString:@"\n"];
////            }
//        }
//
//        NSLog(@"para:%@", para);
//
//        CGSize pTextSize = [para sizeWithFont:[UIFont systemFontOfSize:14.0]
//                            constrainedToSize:CGSizeMake(rect.size.width, CGFLOAT_MAX)
//                                lineBreakMode:NSLineBreakByWordWrapping];
//
//
//        NSLog(@"-2--%f", pTextSize.height/lineHeight);
//        NSInteger paraLines = floor(pTextSize.height/lineHeight);
//        NSLog(@"-2--%d", paraLines);
//
//        totalLines += paraLines;
//        range.length+=[para length];
//
//        //NSLog(@"paraLines-%ld", (long)paraLines);
//        //NSLog(@"pTextSize-%@",NSStringFromCGSize(pTextSize));
//
//
//        if (p==[paragraphs count]-1) {
//
//            NSLog(@"ok!!");
//            [ranges addObject:[NSValue valueWithRange:range]];
//
//        } else if (totalLines + paraLines == maxLine) {
//            NSLog(@"prefect!!");
//
//            range.length += [para length];
//            [ranges addObject:[NSValue valueWithRange:range]];
//
//            range.location += range.length;
//            range.length=0;
//            totalLines=0;
//        } else {
//
//            //import, 页结束时候本段文字还有剩余
//            //NSInteger lineLeft = maxLine - totalLines;
//
//            //NSLog(@"%ld", (long)lineLeft);
//
//            CGSize tmpSize;
//            NSInteger i;
//
//            //逐字判断是否达到了本页最大容量
//            for (i=1; i<[para length]; i++) {
//                NSString *tmp=[para substringToIndex:i];
//
//                tmpSize = [tmp sizeWithFont:[UIFont systemFontOfSize:14.0]
//                         constrainedToSize:CGSizeMake(200, CGFLOAT_MAX)
//                             lineBreakMode:NSLineBreakByWordWrapping];
//
//                int nowLine=floor(tmpSize.height/lineHeight);
//                //NSLog(@"%d, %ld", nowLine, (long)maxLine);
//                if (nowLine > maxLine){
//
//                    //超出容量,跳出, 字符要回退一个, 应为当前字符已经超出范围了
//                    lastPLeft=[para substringFromIndex:i-1];
//                    break;
//                }
//            }
//
//
//            range.length+=i-1;
//            [ranges addObject:[NSValue valueWithRange:range]];
//
//
//            range.location+=range.length;
//            range.length=0;
//            totalLines=0;
//            //p--;
//        }
//    }
//    return ranges;
//}


//- (NSArray *)getPagesOfString2:(NSString *)cache withFont:(UIFont *)font withRect:(CGRect)rect {
//
//    CGFloat lineHeight = [@"本" sizeWithFont:[UIFont systemFontOfSize:14.0]].height;
//    NSInteger maxLine=floor(rect.size.height/lineHeight);
//
//    NSRange range = NSMakeRange(0, 0);
//    NSMutableArray *ranges=[NSMutableArray array];
//    int clenght = [cache length];
//
//    int start = 0;
//    int page = 0;
//    for (int i = 0; i<clenght; i++) {
//
//
//        NSString *content = [cache substringWithRange:NSMakeRange(start, i - start)];
//        CGSize tmpSize = [content sizeWithFont:[UIFont systemFontOfSize:14.0]
//                             constrainedToSize:CGSizeMake(rect.size.height, CGFLOAT_MAX)
//                                 lineBreakMode:NSLineBreakByCharWrapping];
//
//        int nowLine=floor(tmpSize.height/lineHeight);
//        //NSLog(@"%d, h:%f,w:%f", nowLine, tmpSize.height,tmpSize.width);
//        if (nowLine == maxLine) {
//
//            range.location = start;
//            range.length = i - start - 1;
//            [ranges addObject:[NSValue valueWithRange:range]];
//
//            start = i - 1;
//            page++;
//        } else if( i == clenght - 1 ){
//            range.location = start;
//            range.length = i - start;
//
//            [ranges addObject:[NSValue valueWithRange:range]];
//            page++;
//        }
//
//    }
//
//    return ranges;
//}

- (NSArray *)getPagesOfString3:(NSString *)cache withFont:(UIFont *)font withRect:(CGRect)rect {
    
    CGFloat lineHeight = [@"M" textSize:font size:CGSizeZero].height;
    NSLog(@"%f", lineHeight);
    
    NSInteger maxLine = floor(rect.size.height/lineHeight);
    NSLog(@"max:%ld, %f", (long)maxLine, rect.size.height/lineHeight);
    
    NSRange range = NSMakeRange(0, 0);
    NSMutableArray *ranges=[NSMutableArray array];
    NSUInteger clenght = [cache length];
    
    int startPos = 0;
    for (int i = 0; i<clenght; i++) {
        
        NSString *content = [cache substringWithRange:NSMakeRange(startPos, i - startPos)];
        CGSize tmpSize = [content textSize:font width:rect.size.height];
        
        int nowLine = floor(tmpSize.height/lineHeight);
        NSLog(@"%d, h:%f,w:%f", nowLine, tmpSize.height,tmpSize.width);
        if (nowLine == maxLine) {
            
            range.location = startPos;
            range.length = i - startPos - 1;
            
            NSLog(@"content:%@", [cache substringWithRange:range]);
            
            [ranges addObject:[NSValue valueWithRange:range]];
            
            startPos = i - 1;
        } else if( i == clenght - 1 ){
            range.location = startPos;
            range.length = i - startPos;
            
            [ranges addObject:[NSValue valueWithRange:range]];
        }
    }
    return ranges;
}

//- (NSArray *)getPagesOfString4:(NSString *)cache withFont:(UIFont *)font withRect:(CGRect)rect {
//    
//    CGFloat lineHeight = [@"M" textSize:font size:CGSizeZero].height;
//    
//    NSInteger maxLine=floor(rect.size.height/lineHeight);
//    NSRange range = NSMakeRange(0, 0);
//    NSMutableArray *ranges=[NSMutableArray array];
//    
//    NSArray *paragraphs=[cache componentsSeparatedByString:@"\n"];
//    NSLog(@"maxLine:%d", maxLine);
//    NSLog(@"maxLenght:%d", [cache length]);
//    
//    int startPos = 0;
//    int endPos = 0;
//    int totalLine = 0;
//    for (int i = 0; i<[paragraphs count]; i++) {
//        
//        NSString *t = paragraphs[i];
//        if (i == [paragraphs count] - 1){
//            
//        } else {
//            [t stringByAppendingString:@"\n"];
//        }
//        
//        //NSLog(@"%d:%@", i, t);
//        CGFloat tmpHeight = [t textSize:font width:200].height;
//        NSInteger tmpLine = floor(tmpHeight/lineHeight);
//        
//        if (totalLine + tmpLine > maxLine) {
//            //NSLog(@"大于, %d --- tmpLine:%d totalLine:%d", i,tmpLine, totalLine);
//            int startPos_j = 0;
//            for (int j=1; j <= [t length]; j++) {
//                endPos += 1;
//                NSString *tt = [t substringWithRange:NSMakeRange(startPos_j, j - startPos_j)];
//                
//                //NSLog(@"tt:%@", tt);
//                //tt = [tt stringByReplacingOccurrencesOfString:@" " withString:@"M"];
//                CGSize tmpSize = [tt textSize:font width:200];
//                CGFloat tmpHeight = tmpSize.height;
//                int nowLine = floor(tmpHeight/lineHeight);
//                
//                
//                //NSLog(@"tmpSize(%@) && nowLine(%d)", NSStringFromCGSize(tmpSize), nowLine);
//                
//                if(totalLine + nowLine >= maxLine){
//                    NSLog(@"index:(%d) totalLine(%d) + nowLine(%d)=%d",
//                          i,totalLine, nowLine, totalLine + nowLine);
//                    
//                    range.location = startPos;
//                    range.length = endPos - startPos;
//                    
//                    NSLog(@"大于--tt:%@", [cache substringWithRange:NSMakeRange(startPos, endPos - startPos)]);
//                    
//                    [ranges addObject:[NSValue valueWithRange:range]];
//                    
//                    totalLine = 0;
//                    startPos = endPos;
//                    startPos_j = j;
//                }
//                
//                if (j == [t length]){
//                    totalLine += nowLine;
//                    startPos_j = 0;
//                    
//                    NSLog(@"totalLine(%d)", totalLine);
//                }
//            }
//            
//        } else if( totalLine + tmpLine < maxLine ){
//            endPos += [t length];
//            totalLine += tmpLine;
//            
//            
//            if (i == [paragraphs count] - 1){
//                range.location = startPos;
//                range.length = [cache length] - startPos;
//                [ranges addObject:[NSValue valueWithRange:range]];
//            }
//            
//            NSLog(@"小于----index:%d", totalLine);
//            
//        } else if( (totalLine + tmpLine) == maxLine ){
//            endPos += [t length];
//            totalLine += tmpLine;
//            
//            range.location = startPos;
//            range.length = endPos - startPos;
//            
//            NSLog(@"totalLine(%d), tmpLine:(%d)", totalLine, tmpLine);
//            NSLog(@"等于(%d)--tt:%@", i,[cache substringWithRange:NSMakeRange(startPos, endPos - startPos)]);
//            
//            [ranges addObject:[NSValue valueWithRange:range]];
//            
//            totalLine = 0;
//            startPos = endPos;
//        }
//        
//        //NSLog(@"line:%d", tmpLine);
//        //NSLog(@"%@", paragraphs[i]);
//    }
//    return ranges;
//}

- (NSArray *)getPagesOfString5:(NSString *)cache withFont:(UIFont *)font withRect:(CGRect)rect {
    
    CGFloat lineHeight = [@"中文" textSize:font size:CGSizeZero].height;
    
    NSInteger maxLine = floor(rect.size.height/lineHeight);
    NSRange range = NSMakeRange(0, 0);
    NSMutableArray *ranges = [NSMutableArray array];
    
    NSArray *paragraphs=[cache componentsSeparatedByString:@"\n"];
    
    NSLog(@"maxLine:%ld", (long)maxLine);
    NSLog(@"maxLenght:%lu", (unsigned long)[cache length]);
    NSLog(@"paraLine:%lu", (unsigned long)[paragraphs count]);
    
    int startPos = 0;
    int endPos = 0;
    int totalLine = 0;
    for (int i = 0; i<[paragraphs count]; i++) {
        
        NSString *para = paragraphs[i];
        if (i < [paragraphs count] - 1){
            para = [para stringByAppendingString:@"\n"];
        }
        
        CGFloat tmpHeight = [para textSize:font width:rect.size.width].height;
        NSInteger tmpLine = floor(tmpHeight/lineHeight);
        
        NSLog(@"tmpLine:%ld,totalLine:%d", (long)tmpLine, totalLine);
        
        
        
        if( (totalLine + tmpLine) < maxLine ){
            
            endPos += [para length];
            totalLine += tmpLine;
            
            if (i == [paragraphs count] - 1){
                NSLog(@"小于-结束:startPos:%d, endPos:%d", startPos, endPos);
                range.location = startPos;
                range.length = endPos - startPos;
                
                NSLog(@"小于:content:%@", [cache substringWithRange:range]);
                [ranges addObject:[NSValue valueWithRange:range]];
            }
            
        } else if( (totalLine + tmpLine) == maxLine ){
            endPos += [para length];
            totalLine += tmpLine;
            
            range.location = startPos;
            range.length = endPos - startPos;
            
            if (i == [paragraphs count] - 1){
                NSLog(@"等于:content:%@", [cache substringWithRange:range]);
                NSLog(@"等于 - 结束:startPos:%d, endPos:%lu", startPos, (unsigned long)[cache length]);
            }
            
            [ranges addObject:[NSValue valueWithRange:range]];
            
            totalLine = 0;
            startPos = endPos;
        } else if (totalLine + tmpLine > maxLine) {
            //NSLog(@"大于, %d --- tmpLine:%d totalLine:%d", i,tmpLine, totalLine);
            int startPos_j = 0;
            for (int j=1; j <= [para length]; j++) {
                endPos += 1;
                
                NSString *tt = [para substringWithRange:NSMakeRange(startPos_j, j - startPos_j)];
                //NSString *tt = [cache substringWithRange:NSMakeRange(startPos, endPos - startPos)];
                
                CGSize tmpSize = [tt textSize:font width:rect.size.width];
                CGFloat tmpHeight = tmpSize.height;
                NSLog(@"%@", NSStringFromCGSize(tmpSize));
                int nowLine = floor(tmpHeight/lineHeight);
                
                if((totalLine + nowLine) == maxLine){
                
                    range.location = startPos == 0 ? 0 : startPos;
                    range.length = endPos - startPos - 1;
                    
                    NSLog(@"大于: %d --- nowLine:%d totalLine:%d", i,nowLine, totalLine);
                    NSLog(@"大于:content:%@", [cache substringWithRange:range]);
                    
                    [ranges addObject:[NSValue valueWithRange:range]];
                    
                    totalLine = 0;
                    startPos = endPos - 1;
                    startPos_j = j;
                }
                
                if (j == [para length] - 1){
                    totalLine = nowLine;
                    nowLine = 0;
                    startPos_j = 0;
                    
                    if (i == [paragraphs count] - 1){
                        NSLog(@"大于 - 结束:startPos:%d, endPos:%d", startPos, endPos);
                        
                        range.location = startPos;
                        range.length = endPos - startPos;
                        
                        NSLog(@"大于:content:%@", [cache substringWithRange:range]);
                        [ranges addObject:[NSValue valueWithRange:range]];
                    }
                }
            }
        }
    }
    return ranges;
}

- (NSArray *)getPagesOfString6:(NSString *)cache withFont:(UIFont *)font withRect:(CGRect)rect {
    
    CGSize line = [@"中" textSize:font size:CGSizeZero];
    
    NSInteger maxLine = floor(rect.size.height/line.height);
    NSInteger maxWord = floor(rect.size.width/line.width);
    
    NSRange range = NSMakeRange(0, 0);
    NSMutableArray *ranges = [NSMutableArray array];
    
    NSLog(@"maxLine:%ld", (long)maxLine);
    NSLog(@"maxWord:%ld", (long)maxWord);
    NSLog(@"maxLenght:%lu", (unsigned long)[cache length]);
    
    int startPos = 0;
    int nowLine = 0;
    for(int i=0 ; i<[cache length]; i++){
        
        //NSString *t = [cache substringWithRange:NSMakeRange(i, 1)];
        
        if (i % maxWord == 0) {
            
            nowLine++;
            NSLog(@"%d", nowLine);
            if (nowLine == maxLine) {
                
                range.location = startPos;
                range.length = i - startPos;
                
                [ranges addObject:[NSValue valueWithRange:range]];
                startPos = i;
                nowLine = 0;
            }
        }
        
        if(i == [cache length] - 1) {
        
            range.location = startPos;
            range.length = i - startPos;
            
            [ranges addObject:[NSValue valueWithRange:range]];
        }
        //NSLog(@"%@", t);
    }
    
    NSLog(@"%@", ranges);
    
    return ranges;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
