//
//  NetworkTool.m
//  EasySchool
//
//  Created by GanWenPeng on 15/10/20.
//  Copyright (c) 2015年 甘文鹏. All rights reserved.
//  网络请求工具类

#import "NetworkTool.h"

NSString *const NetworkFileMimeTypeJPG = @"image/jpeg";
NSString *const NetworkFileMimeTypeJPEG = @"image/jpeg";
NSString *const NetworkFileMimeTypePNG = @"image/png";
NSString *const NetworkFileMimeTypeDOC = @"application/msword";
NSString *const NetworkFileMimeTypeXLS = @"application/vnd.ms-excel";


@implementation UploadDataModel
- (instancetype)init{
    if (self = [super init]) {
        self.paramName = @"files";
    }
    return self;
}

+(instancetype)modelWithData:(NSData *)data
                    fileName:(NSString *)fileName
                    mimeType:(NSString *)mimeType
                   paramName:(NSString *)paramName{
    
    UploadDataModel *model = [[UploadDataModel alloc] init];
    model.data = data;
    model.fileName = fileName;
    model.mimeType = mimeType;
    model.paramName = paramName;
    return model;
}
@end

@implementation ResponseDataModel
@end


@implementation NetworkTool
static AFHTTPSessionManager *_nomarlMgr;
static NSURLSessionTask *_task;
static MBProgressHUD *_HUD;
+ (AFHTTPSessionManager *)sessionManager{
    return _nomarlMgr;
}
+ (NSURLSessionTask *)sessionTask{
    return _task;
}
+ (void)initialize{
    // 创建请求管理者
    _nomarlMgr = [AFHTTPSessionManager manager];
    // 请求超时时间
    _nomarlMgr.requestSerializer.timeoutInterval = 5.0f;
    // 设置请求头
    [_nomarlMgr.requestSerializer setValue:[NSString stringWithFormat:@"2/%@", [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]]
                        forHTTPHeaderField:@"User-Agent"];
    
    [_nomarlMgr.requestSerializer setValue:@"gzip"
                        forHTTPHeaderField:@"Accept-Encoding"];
    
    [_nomarlMgr.requestSerializer setValue:@"Keep-Alive"
                        forHTTPHeaderField:@"Connection"];
    //如果报接受类型不一致请替换一致text/json或别的
    _nomarlMgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    GWPLog(@"%@", _nomarlMgr.requestSerializer.HTTPRequestHeaders);
    
}

+ (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    showHUD:(BOOL)showHUD
    hudView:(UIView *)hudView
     hudStr:(NSString *)hudStr
    success:(void (^)(id))success
    tgError:(void (^)(id, NetworkRetcode, NSString *))tgError
    failure:(void (^)(NSError *))failure{
    if ([AFNetworkReachabilityManager sharedManager].isReachable==NO) {
        if (showHUD==YES) {
            [MBProgressHUD showMessage:NetworkFailureNotice];
        }
        return;
    }
    DLog(@"%@", URLString);
    MBProgressHUD *hud;
    if (showHUD) {
        hud = [MBProgressHUD showLoadingMessage:hudStr toView:hudView];
        _HUD = hud;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    params[@"app_name"] = @"tugou";
    _task = [_nomarlMgr GET:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"url:%@\nresponse:%@", task.response.URL.relativeString, responseObject);
        
        if (showHUD) {   // 如果有指示器，隐藏之
            [hud hide:YES];
            _HUD = nil;
        }
        
        NSInteger retCode = [responseObject[@"error"] integerValue];
        
        if (retCode==NetworkRetcodeSuccess) {               // 0    成功
            if (success) success(responseObject[@"data"]);
        } else if (tgError) {                                 // 失败
            tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
        } else {                      // -1
            [MBProgressHUD showMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@\n\n%@",URLString, error);
        if (showHUD) {
            [hud hide:YES];
            _HUD = nil;
        }
        
        if (failure) {
            failure(error);
        }else {
            [MBProgressHUD showMessage:NetworkFailureNotice toView:hudView];
        }
    }];
    
}

+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     showHUD:(BOOL)showHUD
     hudView:(UIView *)hudView
      hudStr:(NSString *)hudStr
     success:(void (^)(id))success
     tgError:(void (^)(id, NetworkRetcode, NSString *))tgError
     failure:(void (^)(NSError *))failure{
    DLog(@"%@", URLString);
//    if ([AFNetworkReachabilityManager sharedManager].isReachable==NO) {
//        if (showHUD==YES) {
//            [MBProgressHUD showMessage:NetworkFailureNotice];
//        }
//        return;
//    }
    MBProgressHUD *hud;
    if (showHUD) {
        hud = [MBProgressHUD showLoadingMessage:hudStr toView:hudView];
        _HUD = hud;
    }
   
    _task = [_nomarlMgr POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"url:%@\nresponse:%@", task.response.URL.relativeString, responseObject);
        
        if (showHUD) {   // 如果有指示器，隐藏之
            [hud hide:YES];
            _HUD = nil;
        }
        
        NetworkRetcode retCode = [responseObject[@"error"] integerValue];
        
        switch (retCode) {
            case NetworkRetcodeSuccess: {
                if (success) success(responseObject[@"data"]);
                break;
            }
            case NetworkRetcodeSMSCountOver: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"短信验证码请求次数超限"];
                }
                break;
            }
            case NetworkRetcodeVerifyCodeFalse: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"验证码错误"];
                }
                break;
            }
            case NetworkRetcodeVerifyCodeOverdue: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"验证码过期"];
                }
                break;
            }
            case NetworkRetcodeIncompleteParameter: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"请求参数不完整"];
                }
                break;
            }
            case NetworkRetcodeAlreadyReg: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"该手机号已被注册"];
                }
                break;
            }
            case NetworkRetcodePasswdFalse: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"密码错误"];
                }
                break;
            }
            case NetworkRetcodeSamePasswd: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"新密码与原密码相同"];
                }
                break;
            }
            case NetworkRetcodeNoLogin: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"您尚未登录"];
                }
                break;
            }
            case NetworkRetcodeNoRegister: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"该手机号尚未注册"];
                }
                break;
            }
            case NetworkRetcodeAuthFailure: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"身份校验失败"];
                }
                break;
            }
            case NetworkRetcodeUnknownError: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {                 
                    [MBProgressHUD showMessage:@"未知错误"];
                }
                break;
            }
        }
//        
//        if (retCode==NetworkRetcodeSuccess) {               // 0    成功
//            if (success) success(responseObject[@"data"]);
//        } else if (tgError) {                                 // 失败
//            tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
//        } else {                      // -1
//            [MBProgressHUD showMessage:responseObject[@"msg"]];
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@\n\n%@",URLString, error);
        if (showHUD) {
            [hud hide:YES];
            _HUD = nil;
        }
        
        if (failure) {
            failure(error);
        }else {
            [MBProgressHUD showMessage:NetworkFailureNotice toView:hudView];
        }
    }];
}

+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     showHUD:(BOOL)showHUD
     hudView:(UIView *)hudView
      hudStr:(NSString *)hudStr
       files:(NSArray<UploadDataModel *> *)files
  tgProgress:(void (^)(NSProgress *))tgUploadProgress
     success:(void (^)(id))success
     tgError:(void (^)(id, NetworkRetcode, NSString *))tgError
     failure:(void (^)(NSError *))failure{
//    if ([AFNetworkReachabilityManager sharedManager].isReachable==NO) {
//        if (showHUD==YES) {
//            [MBProgressHUD showMessage:NetworkFailureNotice];
//        }
//        return;
//    }
    MBProgressHUD *hud;
    if (showHUD) {
        hud = [MBProgressHUD showLoadingMessage:hudStr toView:hudView];
        _HUD = hud;
    }

    _task = [_nomarlMgr POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UploadDataModel *model in files) {
            [formData appendPartWithFileData:model.data name:model.paramName fileName:model.fileName mimeType:model.mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (tgUploadProgress) {
            tgUploadProgress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"url:%@\nresponse:%@", task.response.URL.relativeString, responseObject);
        if (showHUD) {   // 如果有指示器，隐藏之
            [hud hide:YES];
            _HUD = nil;
        }
        
        NetworkRetcode retCode = [responseObject[@"error"] integerValue];
        
        switch (retCode) {
            case NetworkRetcodeSuccess: {
                if (success) success(responseObject[@"data"]);
                break;
            }
            case NetworkRetcodeSMSCountOver: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"短信验证码请求次数超限"];
                }
                break;
            }
            case NetworkRetcodeVerifyCodeFalse: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"验证码错误"];
                }
                break;
            }
            case NetworkRetcodeVerifyCodeOverdue: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"验证码过期"];
                }
                break;
            }
            case NetworkRetcodeIncompleteParameter: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"请求参数不完整"];
                }
                break;
            }
            case NetworkRetcodeAlreadyReg: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"该手机号已被注册"];
                }
                break;
            }
            case NetworkRetcodePasswdFalse: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"密码错误"];
                }
                break;
            }
            case NetworkRetcodeSamePasswd: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"新密码与原密码相同"];
                }
                break;
            }
            case NetworkRetcodeNoLogin: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"您尚未登录"];
                }
                break;
            }
            case NetworkRetcodeNoRegister: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"该手机号尚未注册"];
                }
                break;
            }
            case NetworkRetcodeUnknownError: {
                if (tgError) {
                    tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
                } else {
                    [MBProgressHUD showMessage:@"未知错误"];
                }
                break;
            }
        }
        
//        NSInteger retCode = [responseObject[@"error"] integerValue];
//        
//        if (retCode==NetworkRetcodeSuccess) {               // 0    成功
//            if (success) success(responseObject[@"data"]);
//        } else if (tgError) {                                 // 失败
//            tgError(responseObject[@"data"],retCode, responseObject[@"msg"]);
//        } else {                      // -1
//            [MBProgressHUD showMessage:responseObject[@"msg"]];
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"%@\n\n%@",URLString, error);
        if (showHUD) {
            [hud hide:YES];
            _HUD = nil;
        }
        
        if (failure) {
            failure(error);
        }else {
            [MBProgressHUD showMessage:NetworkFailureNotice toView:hudView];
        }
    }];
    
}

NSString *const NetworkFailureNotice = @"网络似乎不太给力哦～";

@end
