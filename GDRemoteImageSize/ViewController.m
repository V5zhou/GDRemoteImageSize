//
//  ViewController.m
//  GDRemoteImageSize
//
//  Created by 心檠 on 2022/9/8.
//

#import "ViewController.h"
#import "GDRemoteImageSize.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSString *url = @"https://inews.gtimg.com/newsapp_match/0/13677386628/0";
    NSString *url = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farticle%2Fe2ca04d9aba88c2f0b5de979ee1622f2954d294e.jpg&refer=http%3A%2F%2Fi0.hdslb.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1665223640&t=ee609c48beb256028d3a12b618333c5f";
    BOOL bImageIO = arc4random()%2;
    CFAbsoluteTime start0 = CFAbsoluteTimeGetCurrent();
    if (bImageIO) {
        CGSize size = [GDRemoteImageSize imageSizeWithUrl:[NSURL URLWithString:url]];
        CFAbsoluteTime start1 = CFAbsoluteTimeGetCurrent();
        NSLog(@"ImageIO: size:%@ 时长：%f", NSStringFromCGSize(size), start1 - start0);
    } else {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [UIImage imageWithData:data];
        CFAbsoluteTime start1 = CFAbsoluteTimeGetCurrent();
        NSLog(@"普通: size:%@ 时长：%f", NSStringFromCGSize(image.size), start1 - start0);
    }
}

@end
