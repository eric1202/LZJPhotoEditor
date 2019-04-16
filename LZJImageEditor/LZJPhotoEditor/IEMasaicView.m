//
//  IEMasaicView.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEMasaicView.h"

@interface IEMasaicView()

@property (nonatomic, strong) IEImageView *imageView;
@end


@implementation IEMasaicView

// 根据全图获取一张高斯模糊图
- (UIImage *)getImageFilterForGaussianBlur:(int)blurNumber
{
    CGFloat blur = blurNumber * self.originImageView.frame.size.width / [UIScreen mainScreen].bounds.size.width;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:self.originImageView.image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage,
                        @"inputRadius", @(blur),
                        nil];
    CIImage *outputImage = filter.outputImage;
    return [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:CGRectMake(0, 0, self.originImageView.frame.size.width, self.originImageView.frame.size.height)]];
}


- (void)drawSmearView
{
//    UIImage *originImage = self.originImageView.image;
//    UIGraphicsBeginImageContext(self.originImageView.frame.size); // 开启上下文
//    CGContextRef context = UIGraphicsGetCurrentContext(); // 获取当前的上下
//    CGContextSetLineCap(context, kCGLineCapRound); // 设置线尾的样式
//    [originImage drawInRect:CGRectMake(0, 0, originImage.size.width, originImage.size.height)]; // 绘制原图用于地图显示
//
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithPatternImage:[self getImageFilterForGaussianBlur:4]].CGColor); //获取高斯图的颜色
//
//    CGContextSetLineWidth(context, 10 * originImage.size.width / self.bounds.size.width); //线宽
//    for (int i = 0 ; i < self.imageView.allLineArr.count ; i ++ ) {
//        NSMutableArray *array = [self.allLineArr objectAtIndex:i];
//
//        for (int i = 0 ; i < array.count ; i ++ ) {
//            NSValue *value = [array objectAtIndex:i];
//            CGPoint p = [value CGPointValue];
//            p.x = p.x * self.originImage.size.width / self.bounds.size.width;
//            p.y = p.y * self.originImage.size.height / self.bounds.size.height;
//            if (i == 0) {
//                CGContextMoveToPoint(context, p.x, p.y); // 设置起点
//                CGContextAddLineToPoint(context, p.x, p.y); //添加移动的点
//            }else{
//                CGContextAddLineToPoint(context, p.x, p.y);
//            }
//        }
//    }
//    CGContextDrawPath(context, kCGPathStroke);  //将路径绘制到上下问
//
//    // 将绘制的结果存储在内存中
//    self.nowImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    // 结束绘制
//    UIGraphicsEndImageContext();
//    [self setNeedsDisplay]; //重绘制
}


@end
