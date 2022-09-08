//
//  GDRemoteImageSize.m
//  GDRemoteImageSize
//
//  Created by 心檠 on 2022/9/8.
//

#import "GDRemoteImageSize.h"
#import "GDRemoteImageDownloader.h"

#import <ImageIO/ImageIO.h>
#import <UIKit/UIKit.h>

@implementation GDRemoteImageSize

+ (CGSize)imageSizeWithUrl:(NSURL *)url {
    __block CGSize result = CGSizeZero;
    // 将异步方法拍平成同步
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    [self asyncImageSizeWithUrl:url completed:^(CGSize size) {
        result = size;
        dispatch_semaphore_signal(sem);
    }];
    dispatch_semaphore_wait(sem, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 30/*防止线程持续锁死*/));
    return result;
}

+ (void)asyncImageSizeWithUrl:(NSURL *)url completed:(void(^)(CGSize size))completed {
    __block CGImageSourceRef sourceRef = CGImageSourceCreateIncremental(NULL);
    GDRemoteImageDownloader *downloader = GDRemoteImageDownloader.new;
    [downloader startDownLoadWithUrl:url onDataChanged:^(NSError *error, BOOL ended, NSData *data) {
        if (sourceRef == NULL) {
            !completed ?: completed(CGSizeZero);
            return YES; // 结束下载标识
        }
        CGImageSourceUpdateData(sourceRef, (__bridge CFDataRef)data, NO);
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
        if (imageRef != NULL) {
            CGSize size = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
            CGImageRelease(imageRef);
            if (!CGSizeEqualToSize(size, CGSizeZero)) {
                CFRelease(sourceRef);
                sourceRef = NULL;
                !completed ?: completed(size);
                return YES; // 结束下载标识
            }
        }
        if (ended) {
            // 数据下载结束，还未识别出来，启用补救措施
            UIImage *image = [UIImage imageWithData:data];
            !completed ?: completed(image ? image.size : CGSizeZero);
        }
        return ended;
    }];
}

@end
