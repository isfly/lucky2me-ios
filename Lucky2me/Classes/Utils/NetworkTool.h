//
//  NetworkTool.h
//  EasySchool
//
//  Created by GanWenPeng on 15/10/20.
//  Copyright (c) 2015年 甘文鹏. All rights reserved.
//  网络请求工具类

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


#pragma mark - 状态字枚举
/**
 *  网络请求返回的状态字枚举
 */
typedef NS_ENUM(NSInteger, NetworkRetcode){
    /**
     * 执行成功 - 0
     * @var unknown
     */
    NetworkRetcodeSuccess              = 5,
    
    
    
    
    /**
     * 验证码发送次数达上限 - 99
     * @var unknown
     */
    NetworkRetcodeSMSCountOver         = 99,
    
    
    /**
     * 验证码错误 - 100
     * @var unknown
     */
    NetworkRetcodeVerifyCodeFalse      = 100,
    
    /**
     * 验证码过期 - 101
     * @var unknown
     */
    NetworkRetcodeVerifyCodeOverdue    = 101,
    
    /**
     * 参数不全 - 102
     * @var unknown
     */
    NetworkRetcodeIncompleteParameter  = 102,
    
    /**
     * 用户已注册 - 103
     * @var unknown
     */
    NetworkRetcodeAlreadyReg           = 103,
    
    /**
     * 密码错误 - 104
     * @var unknown
     */
    NetworkRetcodePasswdFalse          = 104,
    
    /**
     * 新密码与原密码相同 - 105
     * @var unknown
     */
    NetworkRetcodeSamePasswd           = 105,
    
    /**
     * 尚未登录 - 106
     * @var unknown
     */
    NetworkRetcodeNoLogin              = 106,
    
    /**
     * 手机号未注册 - 107
     * @var unknown
     */
    NetworkRetcodeNoRegister           = 107,
    
    /**
     * 身份校验失败 - 108
     * @var unknown
     */
    NetworkRetcodeAuthFailure          = 108,
    
    /**
     * 未知错误 - 999
     * @var unknown
     */
    NetworkRetcodeUnknownError         = 999
    
};

#pragma mark - MimeType
/** 文件后缀 .jpg */
extern NSString *const NetworkFileMimeTypeJPG;
/** 文件后缀 .jpeg */
extern NSString *const NetworkFileMimeTypeJPEG;
/** 文件后缀 .png */
extern NSString *const NetworkFileMimeTypePNG;
/** 文件后缀 .doc */
extern NSString *const NetworkFileMimeTypeDOC;
/** 文件后缀 .xls */
extern NSString *const NetworkFileMimeTypeXLS;


#pragma mark - UploadDataModel
/** 上传模型 */
@interface UploadDataModel : NSObject
/** 文件的二进制数据 */
@property (nonatomic, strong) NSData *data;
/** 上传后的文件名 */
@property (nonatomic, copy) NSString *fileName;
/** mimeType */
@property (nonatomic, copy) NSString *mimeType;
/** 对应服务器的参数名 */
@property (nonatomic, copy) NSString *paramName;

/**
 *  快速创建上传模型
 *
 *  @param data      文件数据（二进制数据）
 *  @param fileName  上传后的文件名
 *  @param mimeType  mimeType
 *  @param paramName 对应服务器的参数名
 */
+ (instancetype)modelWithData:(NSData *)data
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                    paramName:(NSString *)paramName;
@end

#pragma mark - ResponseDataModel
/** 上传文件后返回的数据模型 */
@interface ResponseDataModel : NSObject
@property (nonatomic, copy) NSString *fileThumbUrl;
@property (nonatomic, copy) NSString *fileUrl;
@property (nonatomic, copy) NSString *originName;
@end


#pragma mark  - NetworkTool
@interface NetworkTool : NSObject

+ (AFHTTPSessionManager *)sessionManager;
+ (NSURLSessionTask *)sessionTask;

/**
 *  GET 请求（不可上传文件）
 *
 *  @param URLString        请求地址  (必选)
 *  @param parameters       请求参数  (可选)
 *  @param showHUD          是否显示指示器  (可选)
 *  @param hudView          HUD文字显示的View  (可选，nil时显示在window上)
 *  @param hudStr           加载数据时指示器转菊花时显示的提示文字   (可选)
 *  @param success          HTTP请求成功 && togoServer返回ErrorCode为0(可选，传nil时不进行任何操作)
 *  @param tgError          HTTP请求成功 && togoServer返回ErrorCode不为0(可选，传nil时指示器弹出相应的提示文字)
 *  @param failure          HTTP请求失败（可选，传nil时指示器弹出网络故障的提示文字）
 */
+ (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    showHUD:(BOOL)showHUD
    hudView:(UIView *)hudView
     hudStr:(NSString *)hudStr
    success:(void(^)(id data))success
    tgError:(void(^)(id data, NetworkRetcode errorCode, NSString *message))tgError
    failure:(void(^)(NSError *error))failure;


/**
 *  POST 请求（不可上传文件）
 *
 *  @param URLString        请求地址  (必选)
 *  @param parameters       请求参数  (可选)
 *  @param showHUD          是否显示指示器  (可选)
 *  @param hudView          HUD文字显示的View  (可选，nil时显示在window上)
 *  @param hudStr           加载数据时指示器转菊花时显示的提示文字   (可选)
 *  @param success          HTTP请求成功 && togoServer返回ErrorCode为0(可选，传nil时不进行任何操作)
 *  @param tgError          HTTP请求成功 && togoServer返回ErrorCode不为0(可选，传nil时指示器弹出相应的提示文字)
 *  @param failure          HTTP请求失败（可选，传nil时指示器弹出网络故障的提示文字）
 */
+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     showHUD:(BOOL)showHUD
     hudView:(UIView *)hudView
      hudStr:(NSString *)hudStr
     success:(void(^)(id data))success
     tgError:(void(^)(id data, NetworkRetcode errorCode, NSString *message))tgError
     failure:(void(^)(NSError *error))failure;

/**
 *  POST 文件上传
 *
 *  @param URLString        请求地址  (必选)
 *  @param parameters       请求参数  (可选)
 *  @param showHUD          是否显示指示器  (可选)
 *  @param hudView          HUD文字显示的View  (可选，nil时显示在window上)
 *  @param hudStr           加载数据时指示器转菊花时显示的提示文字   (可选)
 *  @param files            待上传的文件数组，数组元素是 UploadDataModel 模型 (必选)
 *  @param tgUploadProgress 上传进度改变回调
 *  @param success          HTTP请求成功 && togoServer返回ErrorCode为0(可选，传nil时不进行任何操作)
 *  @param tgError          HTTP请求成功 && togoServer返回ErrorCode不为0(可选，传nil时指示器弹出相应的提示文字)
 *  @param failure          HTTP请求失败（可选，传nil时指示器弹出网络故障的提示文字）
 */
+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     showHUD:(BOOL)showHUD
     hudView:(UIView *)hudView
      hudStr:(NSString *)hudStr
       files:(NSArray<UploadDataModel*> *)files
    tgProgress:(void(^)(NSProgress * ))tgUploadProgress
     success:(void(^)(id data))success
     tgError:(void(^)(id data, NetworkRetcode errorCode, NSString *message))tgError
     failure:(void(^)(NSError *error))failure;


extern NSString *const NetworkFailureNotice;
@end
