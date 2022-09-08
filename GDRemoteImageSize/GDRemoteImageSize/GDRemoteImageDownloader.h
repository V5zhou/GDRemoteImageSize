//
//  GDRemoteImageDownloader.h
//  GDRemoteImageSize
//
//  Created by 心檠 on 2022/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDRemoteImageDownloader : NSObject

/// 开始下载
/// @param url url
/// @param onDataChanged 回调
- (void)startDownLoadWithUrl:(NSURL *)url
               onDataChanged:(BOOL(^)(NSError *error, BOOL ended, NSData *data))onDataChanged;

/// 取消下载
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
