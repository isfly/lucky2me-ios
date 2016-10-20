//
//  LCIMService.m
//  Lucky2me
//
//  Created by 甘文鹏 on 2016/10/18.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCIMService.h"
#import <CocoaAsyncSocket/GCDAsyncSocket.h>

@interface LCIMService ()<GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) dispatch_queue_t socket_queue;
@end

@implementation LCIMService
#pragma mark - init
static LCIMService *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)defaultService{
    if (_instance==nil) {
        _instance = [[LCIMService alloc] init];
    }
    return _instance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.socket_queue = dispatch_queue_create("socket-queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}
#pragma mark - lazy
- (GCDAsyncSocket *)socket{
    if (!_socket) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue() socketQueue:self.socket_queue];
    }
    return _socket;
}

/** 启动服务 */
+ (void)start{
//    return;
    
    GCDAsyncSocket *socket = [LCIMService defaultService].socket;
    if (socket.isConnected) {
        DLog(@"请勿重复连接");
        return;
    }
    
    NSError *err;
    [socket connectToHost:IM_HOST onPort:[IM_PORT intValue] withTimeout:-1 error:&err];
    
    if (err) {
        DLog(@"%@", err);
        return;
    }
}

/** 重启服务 */
+ (void)reStart{
    [self close];
    [self start];
}

/** 断开服务 */
+ (void)close{
    [[LCIMService defaultService].socket disconnect];
}

/** 发送消息 */
+ (void)postMessage:(NSString *)message{
    GCDAsyncSocket *socket = [LCIMService defaultService].socket;
    [socket writeData:[message dataUsingEncoding:NSUTF8StringEncoding] withTimeout:5 tag:0];
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [self.socket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock{
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err{
    
}
@end
