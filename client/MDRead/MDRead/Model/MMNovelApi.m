//
//  MMNovelApi.m
//  MDRead
//
//  Created by midoks on 16/5/28.
//  Copyright © 2016年 midoks. All rights reserved.
//

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
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [_manager.requestSerializer setTimeoutInterval:5.0];
        [_manager.requestSerializer setValue:@"MDREAD IOS Client/1.0(midoks@163.com)" forHTTPHeaderField:@"User-Agent"];
        
        _args = [[NSMutableDictionary alloc] init];
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
            
            if ([responseObject count] < 1) {
                failure(-1, [NSString stringWithFormat:@"%@:%@", search, @"搜索后没有数据!"]);
                return;
            }
            
            NSArray *check = [[NSArray alloc] initWithObjects:
                              @"book_id",@"book_name",@"book_author",
                              @"book_desc",@"book_type",@"book_status",
                              nil];
            
            NSString *tmpKeyName    = @"";
            NSString *tmpK          = @"";
        
            for (int i=0; i<[check count]; i++) {
                tmpK = [check objectAtIndex:i];
                tmpKeyName = [[responseObject objectAtIndex:0] objectForKey:tmpK];
                if (tmpKeyName == NULL) {
                    failure(-1,[NSString stringWithFormat:@"%@:%@,字段缺失!", search, tmpK]);
                    return;
                }
            }
        } else{
            //NSLog(@"%@", [responseObject class]);
            if([responseObject isKindOfClass:[NSArray class]]){
                success(responseObject);
                return;
            }
            
            if ([responseObject objectForKey:@"ret_code"]) {
                failure([[responseObject objectForKey:@"ret_code"] intValue], [responseObject objectForKey:@"ret_msg"]);
            }
            
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        failure(-1, [NSString stringWithFormat:@"%@:%@", search, @"Search:获取数据失败!"]);
    }];
}

#pragma mark - 章节列表 -
-(void)BookList:(NSString *)book_id
      source_id:(NSString *)source_id
        success:(void (^)(id responseObject))success
        failure:(void (^)(int ret_code, NSString *ret_msg))failure
{
    [self BookList:book_id source_id:source_id success:success failure:failure validate:TRUE];
}


-(void)BookList:(NSString *)book_id
      source_id:(NSString *)source_id
        success:(void (^)(id responseObject))success
        failure:(void (^)(int ret_code, NSString *ret_msg))failure
       validate:(BOOL)validate
{
    [self setArgs:@"book_id" value:book_id];
    if (![source_id isEqualToString:@""]) {
        [self setArgs:@"source_id" value:source_id];
    }
    
    NSString *book_list = [_callbackUrls objectForKey:@"book_list"];
    
    if (!book_list) {
        failure(-1, [NSString stringWithFormat:@"book_list未设置"]);
        return;
    }
    
    NSString *encoded = [book_list stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_manager POST:encoded parameters:_args progress:^(NSProgress * uploadProgress) {
    } success:^(NSURLSessionDataTask * task, id  responseObject) {

        if(validate){
            
            if ([responseObject count] < 1) {
                failure(-1, [NSString stringWithFormat:@"%@:%@", book_list, @"书籍章节没有数据!"]);
                return;
            }
            
            
            NSMutableArray *check = [[NSMutableArray alloc] initWithObjects:
                              @"chapter_id",@"chapter_name", @"sort", nil];
            
            if (![source_id isEqualToString:@""]) {
                [check addObject:@"source_id"];
            }
            
            NSString *tmpKeyName    = @"";
            NSString *tmpK          = @"";
            
            for (int i=0; i<[check count]; i++) {
                tmpK = [check objectAtIndex:i];
                tmpKeyName = [[responseObject objectAtIndex:0] objectForKey:tmpK];
                if (tmpKeyName == NULL) {
                    failure(-1,[NSString stringWithFormat:@"%@:%@,字段缺失!", book_list, tmpK]);
                    return;
                }
            }
        }
        success(responseObject);
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        failure(-1, [NSString stringWithFormat:@"%@:%@", book_list, @"BookList:获取数据失败!"]);
    }];
}

#pragma mark - 章节内容 -
-(void)BookContent:(NSString *)chapter_id
         source_id:(NSString *)source_id
           success:(void (^)(id responseObject))success
           failure:(void (^)(int ret_code, NSString *ret_msg))failure
{
    [self BookContent:chapter_id source_id:source_id success:success failure:failure validate:FALSE];
}

-(void)BookContent:(NSString *)chapter_id
      source_id:(NSString *)source_id
           success:(void (^)(id responseObject))success
           failure:(void (^)(int ret_code, NSString *ret_msg))failure
          validate:(BOOL)validate
{
    [self setArgs:@"chapter_id" value:chapter_id];
    if (![source_id isEqualToString:@""]) {
        [self setArgs:@"source_id" value:source_id];
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
        
        if([resultJson objectForKey:@"ret_code"]){
            failure(-1, @"入口获取数据失败!");
            return;
        }
        
        if (![resultJson objectForKey:@"search"]) {
            failure(-1, @"search:没有设置!");
            return;
        }
        
        if (![resultJson objectForKey:@"book_list"]) {
            failure(-1, @"book_list:没有设置!");
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
        
        //验证搜索
        [self Search:vail_search success:^(id responseObject) {
            
        } failure:^(int ret_code, NSString *ret_msg) {
            failure(ret_code, ret_msg);
        } validate:true];
        
        //验证书籍列表信息
        NSString *book_id = [[[resultJson objectForKey:@"vaildata"] objectForKey:@"book_list"] objectForKey:@"book_id"];
        NSString *source_id = [[[resultJson objectForKey:@"vaildata"] objectForKey:@"book_list"] objectForKey:@"source_id"];
        [self BookList:book_id source_id:source_id success:^(id responseObject) {
            
        } failure:^(int ret_code, NSString *ret_msg) {
            failure(ret_code, ret_msg);
        } validate:TRUE];
        
        //验证数据内容信息
        NSString *chapter_id = [[[resultJson objectForKey:@"vaildata"] objectForKey:@"book_content"] objectForKey:@"chapter_id"];
        NSString *bconent_source_id = [[[resultJson objectForKey:@"vaildata"] objectForKey:@"book_content"] objectForKey:@"source_id"];
        [self BookContent:chapter_id source_id:bconent_source_id success:^(id responseObject) {
            //NSLog(@"%@", responseObject);
        } failure:^(int ret_code, NSString *ret_msg) {
            failure(ret_code, ret_msg);
        } validate:TRUE];
        
        success();
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        failure(-1, @"test:入口获取数据失败!");
    }];
}



@end
