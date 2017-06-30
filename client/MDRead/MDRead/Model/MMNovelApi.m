//
//  MMNovelApi.m
//  MDRead
//
//  Created by midoks on 16/5/28.
//  Copyright © 2016年 midoks. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "MMNovelApi.h"
#import "MMCommon.h"

@interface MMNovelApi()

@property (nonatomic, strong) NSDictionary *callbackUrls;

@end


@implementation MMNovelApi

+(MMNovelApi*)shareInstance
{
    static  MMNovelApi *shareInstance = NULL;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[MMNovelApi alloc] init];
    });
    return shareInstance;
}


-(id)init
{
    if (self == [super init])
    {
        
        self->_manager = [[AFHTTPSessionManager alloc] init];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"application/xhtml+xml", @"application/xml", @"text/plain",nil];;
        [_manager.requestSerializer setTimeoutInterval:5.0];
        [_manager.requestSerializer setValue:@"MDREAD IOS Client/1.0(midoks@163.com)" forHTTPHeaderField:@"User-Agent"];
        
        _args = [[NSMutableDictionary alloc] init];
        
        NSString *identifierNumber = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        MDLog(@"手机序列号: %@",identifierNumber);
        
        
    }
    return self;
}

#pragma mark - 设置POST参数 -
-(void)setArgs:(NSString *)key value:(NSString *)value
{
    [self->_args setValue:value forKey:key];
}

#pragma mark - 添加新字典 -
-(void)addArgs:(NSString *)key dic:(NSMutableDictionary *)dic
{
    _args[key] = dic;
}

#pragma mark - 接口注入 -
-(void)initInjection:(NSDictionary *)callbackUrls
{
    _callbackUrls = callbackUrls;
}

#pragma mark - 搜索 -
-(void)Search:(NSString *)word
      success:(void (^)(id responseObject))success
      failure:(void (^)(int ret_code, NSString *ret_msg))failure
{
    [self Search:word success:success failure:failure validate:FALSE];
}

-(void)Search:(NSString *)word
      success:(void (^)(id responseObject))success
      failure:(void (^)(int ret_code,  NSString *ret_msg))failure
     validate:(BOOL)validate
{
    NSString *search = [_callbackUrls objectForKey:@"search"];
    
    if (!search) {
        failure(-1, [NSString stringWithFormat:@"search未设置"]);
        return;
    }
    
    NSString *encoded = [search stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self setArgs:@"w" value:word];
    
    [_manager POST:encoded parameters:_args progress:^(NSProgress * uploadProgress) {
    } success:^(NSURLSessionDataTask * task, id responseObject) {
        
        if(validate){
            
            //MDLog(@"%@", responseObject);
            
            if ([[responseObject objectForKey:@"ret_code"] intValue] < 0 ){
                failure(-1, [NSString stringWithFormat:@"%@:%@", search, [responseObject objectForKey:@"ret_msg"]]);
                return;
            };
            
            if ([responseObject count] < 1) {
                failure(-1, [NSString stringWithFormat:@"%@:%@", search, @"搜索后没有数据!"]);
                return;
            }
            
            NSArray *check = [[NSArray alloc] initWithObjects:@"bid",@"sid", @"image", @"name",@"author",@"desc",nil];
            
            NSString *tmpKeyName    = @"";
            NSString *tmpK          = @"";
            
            for (int i=0; i<[check count]; i++) {
                tmpK = [check objectAtIndex:i];
                tmpKeyName = [[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:tmpK];
                if (tmpKeyName == NULL) {
                    failure(-1,[NSString stringWithFormat:@"%@:%@,字段缺失!", search, tmpK]);
                    return;
                }
            }
        } else{
            
            //MDLog(@"%@", [responseObject class]);
            if([responseObject isKindOfClass:[NSArray class]]){
                success(responseObject);
                return;
            }
            
            if ([[responseObject objectForKey:@"ret_code"] intValue] < 0) {
                failure([[responseObject objectForKey:@"ret_code"] intValue], [responseObject objectForKey:@"ret_msg"]);
                return;
            }
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        failure(-1, [NSString stringWithFormat:@"%@:%@", search, @"Search:获取数据失败!"]);
    }];
}

#pragma mark - 书籍信息 -
-(void)BookInfo:(NSString *)book_id
      source_id:(NSString *)source_id
        success:(void (^)(id responseObject))success
        failure:(void (^)(int ret_code, NSString *ret_msg))failure
{
    [self BookInfo:book_id source_id:source_id success:success failure:failure validate:FALSE];
}

-(void)BookInfo:(NSString *)book_id
      source_id:(NSString *)source_id
        success:(void (^)(id responseObject))success
        failure:(void (^)(int ret_code, NSString *ret_msg))failure
       validate:(BOOL)validate
{
    [self setArgs:@"bid" value:book_id];
    [self setArgs:@"sid" value:source_id];
    
    NSString *book_info_url = [_callbackUrls objectForKey:@"book_info"];
    
    //MDLog(@"%@", book_info_url);
    
    if (!book_info_url) {
        failure(-1, [NSString stringWithFormat:@"book_list未设置!"]);
        return;
    }
    
    NSString *encoded = [book_info_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [_manager POST:encoded parameters:_args progress:^(NSProgress * uploadProgress) {
    } success:^(NSURLSessionDataTask * task, id  responseObject) {
        MDLog(@"%@:%@", responseObject,book_info_url);
        
        if (validate){
            if ([[responseObject objectForKey:@"data"] count] < 1){
                failure(-1, [NSString stringWithFormat:@"%@:%@", book_info_url, @"书籍INFO没有数据!"]);
                return;
            }
        }
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        MDLog(@"%@", error);
        failure(-1, [NSString stringWithFormat:@"%@:%@", book_info_url, @"BookContent:获取数据失败!"]);
    }];
    
}

#pragma mark - 章节列表 -
-(void)BookList:(NSString *)book_id
      source_id:(NSString *)source_id
        success:(void (^)(id responseObject))success
        failure:(void (^)(int ret_code, NSString *ret_msg))failure
{
    [self BookList:book_id source_id:source_id success:success failure:failure validate:FALSE];
}


-(void)BookList:(NSString *)book_id
      source_id:(NSString *)source_id
        success:(void (^)(id responseObject))success
        failure:(void (^)(int ret_code, NSString *ret_msg))failure
       validate:(BOOL)validate
{
    
    [self setArgs:@"bid" value:book_id];
    [self setArgs:@"sid" value:source_id];
    
    NSString *book_list_url = [_callbackUrls objectForKey:@"book_list"];
    
    if (!book_list_url) {
        failure(-1, [NSString stringWithFormat:@"book_list未设置!"]);
        return;
    }
    
    NSString *encoded = [book_list_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_manager POST:encoded parameters:_args progress:^(NSProgress * uploadProgress) {
    } success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        int ret_code = [[responseObject objectForKey:@"ret_code"] intValue];
        if ( ret_code < 0){
            failure(-1, [NSString stringWithFormat:@"%d:%@", ret_code, [responseObject objectForKey:@"ret_msg"]]);
            return;
        }
        
        if(validate){
            //MDLog(@"%@", responseObject);
            
            if ([responseObject count] < 1) {
                failure(-1, [NSString stringWithFormat:@"%@:%@", book_list_url, @"书籍章节没有数据!"]);
                return;
            }
            
            NSMutableArray *check = [[NSMutableArray alloc] initWithObjects:@"bid",@"sid",@"cid",@"name", nil];
            
            NSString *tmpKeyName    = @"";
            NSString *tmpK          = @"";
            
            for (int i=0; i<[check count]; i++) {
                tmpK = [check objectAtIndex:i];
                tmpKeyName = [[[responseObject objectForKey:@"data"] objectAtIndex:0] objectForKey:tmpK];
                if (tmpKeyName == NULL) {
                    failure(-1,[NSString stringWithFormat:@"%@:%@,字段缺失!", book_list_url, tmpK]);
                    return;
                }
            }
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        failure(-1, [NSString stringWithFormat:@"%@:%@", book_list_url, @"BookList:获取数据失败!"]);
    }];
}

#pragma mark - 章节内容 -
-(void)BookContent:(NSString *)book_id
        chapter_id:(NSString *)chapter_id
         source_id:(NSString *)source_id
           success:(void (^)(id responseObject))success
           failure:(void (^)(int ret_code, NSString *ret_msg))failure
{
    [self BookContent:book_id chapter_id:chapter_id source_id:source_id success:success failure:failure validate:FALSE];
}

#pragma mark - 章节内容 validate -
-(void)BookContent:(NSString *)book_id
        chapter_id:(NSString *)chapter_id
         source_id:(NSString *)source_id
           success:(void (^)(id responseObject))success
           failure:(void (^)(int ret_code, NSString *ret_msg))failure
          validate:(BOOL)validate
{
    [self setArgs:@"bid" value:book_id];
    [self setArgs:@"cid" value:chapter_id];
    if (![source_id isEqualToString:@""]) {
        [self setArgs:@"sid" value:source_id];
    }
    
    NSString *book_content = [_callbackUrls objectForKey:@"book_content"];
    
    
    if (!book_content) {
        failure(-1, [NSString stringWithFormat:@"book_content未设置"]);
        return;
    }
    NSString *encoded = [book_content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [_manager POST:encoded parameters:_args progress:^(NSProgress * uploadProgress) {
    } success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        if(validate){
            if ([responseObject count] < 1) {
                failure(-1, [NSString stringWithFormat:@"%@:%@", book_content, @"书籍章节内容没有数据!"]);
                return;
            }
            
            NSMutableArray *check = [[NSMutableArray alloc] initWithObjects:@"content", nil];
            
            NSString *tmpKeyName    = @"";
            NSString *tmpK          = @"";
            
            for (int i=0; i<[check count]; i++) {
                tmpK = [check objectAtIndex:i];
                tmpKeyName = [responseObject objectForKey:tmpK];
                if (tmpKeyName == NULL) {
                    failure(-1,[NSString stringWithFormat:@"%@:%@,字段缺失!", book_content, tmpK]);
                    return;
                }
            }
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        MDLog(@"%@", error);
        failure(-1, [NSString stringWithFormat:@"%@:%@", book_content, @"BookContent:获取数据失败!"]);
    }];
}

#pragma mark - 章节源 -
-(void)BookSource:(NSString *)book_id
          success:(void (^)(id responseObject))success
          failure:(void (^)())failure
{
    
}

-(void)recommend:(void (^)(id responseObject))success
         failure:(void (^)(int ret_code, NSString *ret_msg))failure
{
    [self recommend:success failure:failure validate:FALSE];
}

#pragma mark - 推荐 -
-(void)recommend:(void (^)(id responseObject))success
         failure:(void (^)(int ret_code, NSString *ret_msg))failure
        validate:(BOOL)validate
{
    NSString *recommend = [_callbackUrls objectForKey:@"recommend"];
    
    if (!recommend) {
        failure(-1, [NSString stringWithFormat:@"recommend未设置"]);
        return;
    }
    
    NSString *encoded = [recommend stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [_manager POST:encoded parameters:_args progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(-1, [NSString stringWithFormat:@"%@:%@", recommend, @"获取数据失败!"]);
    }];
}

#pragma mark - 随机 -
-(void)rand:(void (^)(id responseObject))success
    failure:(void (^)(int ret_code, NSString *ret_msg))failure
{
    [self rand:success failure:failure validate:FALSE];
}

-(void)rand:(void (^)(id responseObject))success
    failure:(void (^)(int ret_code, NSString *ret_msg))failure
   validate:(BOOL)validate
{
    NSString *rand = [_callbackUrls objectForKey:@"rand"];
    
    if (!rand) {
        failure(-1, [NSString stringWithFormat:@"rand未设置"]);
        return;
    }
    
    NSString *encoded = [rand stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [_manager POST:encoded parameters:_args progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(-1, [NSString stringWithFormat:@"%@:%@", rand, @"获取数据失败!"]);
    }];
}

#pragma mark - 榜单数据 -
-(void)BangList:(void (^)(id responseObject))success
        failure:(void (^)(int ret_code, NSString *ret_msg))failure
{
    NSString *bang = [_callbackUrls objectForKey:@"list"];
    if (!bang) {
        failure(-1, [NSString stringWithFormat:@"list未设置"]);
        return;
    }
    
    NSString *encoded = [bang stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [_manager POST:encoded parameters:_args progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(-1, [NSString stringWithFormat:@"%@:%@", bang, @"获取数据失败!"]);
    }];
}

#pragma mark - 作者其它数据 -
-(void)AuthorList:(void (^)(id responseObject))success
          failure:(void (^)(int ret_code, NSString *ret_msg))failure
{
    
    NSString *book_author = [_callbackUrls objectForKey:@"book_author"];
    if (!book_author) {
        failure(-1, [NSString stringWithFormat:@"book_author未设置"]);
        return;
    }
    
    NSString *encoded = [book_author stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self setArgs:@"book_author" value:@"萧鼎"];
    
    [_manager POST:encoded parameters:_args progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(-1, [NSString stringWithFormat:@"%@:%@", book_author, @"获取数据失败!"]);
    }];
    
    //NSLog(@"%@", _callbackUrls)
}

#pragma mark - 获取来源接口标题 -
-(NSString *)getApiTitle
{
    NSString *title = [_callbackUrls objectForKey:@"title"];
    if (title) {
        return title;
    }
    return @"default";
}

#pragma mark - 是否存在意见反馈 -
-(BOOL)isExistFeedBack
{
    NSString *feedback = [_callbackUrls objectForKey:@"feedback"];
    if (feedback) {
        return YES;
    }

    return NO;
}

#pragma mark - 意见反馈 -
-(void)feedBack:(NSString *)content
        success:(void (^)(id responseObject))success
        failure:(void (^)(int ret_code, NSString *ret_msg))failure
{
    NSString *feedback = [_callbackUrls objectForKey:@"feedback"];
    if (!feedback) {
        failure(-1, [NSString stringWithFormat:@"feedback未设置"]);
        return;
    }
    
    [self setArgs:@"content" value:content];
    
    NSString *encoded = [feedback stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [_manager POST:encoded parameters:_args progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(-1, [NSString stringWithFormat:@"%@:%@", feedback, @"获取数据失败!"]);
    }];
}

#pragma mark - 测试 -

-(void)downloadFile
{
    
    //    NSString *fileName = [NSString stringWithFormat:@"%@.json", @"api"];
    //    NSString *bundleFile = NSHomeDirectory();//[[NSBundle mainBundle] bundlePath];
    //    NSString *downloadFile = [NSString stringWithFormat:@"%@/%@", bundleFile, fileName];
    //
    //    NSLog(@"%@" ,[[NSBundle mainBundle] bundlePath]);
    //    NSLog(@"%@",[NSURL fileURLWithPath:downloadFile]);
    //    NSLog(@"%@", downloadFile);
    //
    //    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://121.42.151.169/api"]];
    //
    //    [_manager downloadTaskWithRequest:req progress:^(NSProgress * _Nonnull downloadProgress) {
    //
    //    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
    //        return [NSURL fileURLWithPath:downloadFile];
    //
    //    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
    //
    //        NSLog(@"%@",response);
    //        NSLog(@"%@", filePath);
    //        NSLog(@"%@", error);
    //
    //    }];
    
}

-(void)test:(NSString *)url
    success:(void (^)())success
    failure:(void (^)(int ret_code, NSString *ret_msg))failure
{
    NSString *encoded = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_manager GET:encoded parameters:nil progress:^(NSProgress * downloadProgress) {
        
    } success:^(NSURLSessionDataTask * task, id responseObject) {
        
        NSString *tmpDa = [responseObject JSONString];
        NSData *jsonData = [tmpDa dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultJson = [jsonData objectFromJSONData];
        
        
        MDLog(@"test:%@", resultJson);
        
//        if(![resultJson objectForKey:@"ret_code"]){
//            failure(-1, @"入口获取数据失败!");
//            return;
//        }
        
        if(![resultJson objectForKey:@"title"]){
            failure(-1, @"缺少标题!");
            return;
        }
        
        if (![resultJson objectForKey:@"search"]) {
            failure(-1, @"Search:没有设置!");
            return;
        }
        
        if (![resultJson objectForKey:@"book_list"]) {
            failure(-1, @"book_list:没有设置!");
            return;
        }
        
        if (![resultJson objectForKey:@"book_info"]) {
            failure(-1, @"book_info:没有设置!");
            return;
        }
        
        if (![resultJson objectForKey:@"book_content"]) {
            failure(-1, @"book_content:没有设置!");
            return;
        }
        
        if(![resultJson objectForKey:@"vaildata"]){
            failure(-1, @"缺少验证数据!");
            return;
        }
        
        NSString *vail_search = [[resultJson objectForKey:@"vaildata"] objectForKey:@"search"];
        if (!vail_search) {
            failure(-1, @"缺少验证search值!");
            return;
        }
        
        NSString *vail_book_list = [[resultJson objectForKey:@"vaildata"] objectForKey:@"book_list"];
        if (!vail_book_list) {
            failure(-1, @"缺少验证book_list值!");
            return;
        }
        
        //注入数据
        [self initInjection:resultJson];
        
        //验证搜索API
        [self Search:vail_search success:^(id responseObject) {
            MDLog(@"-- BookSearch Vail OK --");
        } failure:^(int ret_code, NSString *ret_msg) {
            MDLog(@"-- BookSearch Vail Fail --");
            failure(ret_code, ret_msg);
        } validate:TRUE];
        
        //验证书籍列表信息API
        NSString *book_id = [[[resultJson objectForKey:@"vaildata"] objectForKey:@"book_list"] objectForKey:@"bid"];
        NSString *source_id = [[[resultJson objectForKey:@"vaildata"] objectForKey:@"book_list"] objectForKey:@"sid"];
        [self BookList:book_id source_id:source_id success:^(id responseObject) {
            MDLog(@"-- BookList Vail OK --");
        } failure:^(int ret_code, NSString *ret_msg) {
            MDLog(@"-- BookList Vail Fail --");
            failure(ret_code, ret_msg);
        } validate:TRUE];
        
        //验证书籍信息接口API
        [self BookInfo:book_id source_id:source_id success:^(id responseObject) {
            MDLog(@"-- BookInfo Vail OK --");
        } failure:^(int ret_code, NSString *ret_msg) {
            MDLog(@"-- BookInfo %@ Fail --", responseObject);
            failure(ret_code, ret_msg);
        } validate:TRUE];
        
        //验证书籍章节内容API
        NSString *chapter_id = [[[resultJson objectForKey:@"vaildata"] objectForKey:@"book_content"] objectForKey:@"cid"];
        NSString *bconent_source_id = [[[resultJson objectForKey:@"vaildata"] objectForKey:@"book_content"] objectForKey:@"sid"];
        [self BookContent:book_id chapter_id:chapter_id source_id:bconent_source_id success:^(id responseObject) {
            MDLog(@"-- BookContent Vail OK --");
        } failure:^(int ret_code, NSString *ret_msg) {
            MDLog(@"-- BookContent %@ Fail --", responseObject);
            failure(ret_code, ret_msg);
        } validate:TRUE];
        
        success();
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        //MDLog(@"test root fail:%@", [error localizedDescription]);
        failure(-1, @"test:入口获取数据失败!");
    }];
}



@end
