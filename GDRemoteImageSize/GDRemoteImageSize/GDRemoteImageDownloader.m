//
//  GDRemoteImageDownloader.m
//  GDRemoteImageSize
//
//  Created by 心檠 on 2022/9/8.
//

#import "GDRemoteImageDownloader.h"

@interface GDRemoteImageDownloader () <NSURLSessionDataDelegate>

// 当前下载任务
@property (nonatomic, strong) NSURLSessionDataTask *task;

/// 已接收数据
@property (nonatomic, strong) NSMutableData *data;

/// 数据变动通知
/// @return 是否结束请求
@property (nonatomic, copy) BOOL(^onDataChanged)(NSError *error, BOOL ended, NSData *data);

@end

@implementation GDRemoteImageDownloader

- (void)startDownLoadWithUrl:(NSURL *)url onDataChanged:(BOOL(^)(NSError *error, BOOL ended, NSData *data))onDataChanged {
    self.onDataChanged = onDataChanged;
    self.data = [NSMutableData data];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration delegate:self delegateQueue:nil];
    self.task = [session dataTaskWithURL:url];
    [self.task resume];
}

- (void)cancel {
    [self.task cancel];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
//    NSLog(@"MIME TYPE %@", response.MIMEType);
    NSArray *rows = [response.MIMEType componentsSeparatedByString:@"/"];
    if (![rows containsObject:@"image"]) {
        NSAssert(NO, @"传入非法图片URL，请检查");
        completionHandler(NSURLSessionResponseCancel);
    }
    // 允许通过
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.data appendData:data];
//    NSLog(@"加载数据长度:%ld", self.data.length);
    if (self.onDataChanged) {
        if (self.onDataChanged(nil, NO, self.data)) { // 获取结束标识
            [self cancel];
        }
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (self.onDataChanged) {
        self.onDataChanged(error, YES, self.data);
    }
}

@end
