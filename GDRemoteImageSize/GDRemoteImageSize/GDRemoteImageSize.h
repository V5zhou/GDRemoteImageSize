//
//  GDRemoteImageSize.h
//  GDRemoteImageSize
//
//  Created by 心檠 on 2022/9/8.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface GDRemoteImageSize : NSObject

/// 同步获取Size
/// @param url url
+ (CGSize)imageSizeWithUrl:(NSURL *)url;

/// 异步获取Size
/// @param url url
/// @param completed 数据回调
+ (void)asyncImageSizeWithUrl:(NSURL *)url completed:(void(^)(CGSize size))completed;

@end

NS_ASSUME_NONNULL_END
