//
//  IEMasaicView.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEMosaicView.h"
#import "MosaiView/MosaiPath.h"
#import "MosaiView/MosaiManager.h"
@interface IEMosaicView()
//存放顶层图片的UIImageView，图片为正常的图片
@property (nonatomic, strong) UIImageView *topImageView;

//展示马赛克图片的涂层
@property (nonatomic, strong) CALayer *mosaicImageLayer;

//遮罩层，用于设置形状路径
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

//手指涂抹的路径
@property (nonatomic, assign) CGMutablePathRef path;

//当前绘制的信息
@property (nonatomic, strong) MosaiPath *currentPath;

//绘制路径
@property (nonatomic, strong) NSMutableArray *pathArray;

//每一次作图后的马赛克图
@property (nonatomic ,strong) UIImage *mosaiFinalImage;

//MosaiManager
@property(nonatomic ,strong) MosaiManager *mosaiManager;
@end


@implementation IEMosaicView

#pragma mark - Public
-(void)redo{
    UIImage *image = [self.mosaiManager redo];
    if (!image)return;
    self.mosaiFinalImage = image;
    [self resetMosaiImage];
    
}

-(void)undo{
    UIImage *image = [self.mosaiManager undo];
    if (!image)return;
    self.mosaiFinalImage = image;
    [self resetMosaiImage];
}

-(BOOL)canUndo{
    if (self.mosaiManager.currentIndex > 0) {
        return YES;
    }
    return NO;
    
}


-(NSInteger)currentIndex{
    return self.mosaiManager.currentIndex;
}


-(BOOL)canRedo{
    if (self.mosaiManager.currentIndex < self.mosaiManager.operationCount) {
        return YES;
    }
    return NO;
}

-(UIImage*)render{
    return self.mosaiFinalImage;
}

//// 根据全图获取一张高斯模糊图
//- (UIImage *)getImageFilterForGaussianBlur:(int)blurNumber
//{
//    CGFloat blur = blurNumber * self.originImageView.frame.size.width / [UIScreen mainScreen].bounds.size.width;
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CIImage *inputImage = [CIImage imageWithCGImage:self.originImageView.image.CGImage];
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
//                                  keysAndValues:kCIInputImageKey, inputImage,
//                        @"inputRadius", @(blur),
//                        nil];
//    CIImage *outputImage = filter.outputImage;
//    return [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:CGRectMake(0, 0, self.originImageView.frame.size.width, self.originImageView.frame.size.height)]];
//}


//- (void)drawSmearView
//{
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
//}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _currentPath = [[MosaiPath alloc]init];
        _pathArray = [[NSMutableArray alloc]init];
        _operationCount = 0;
        
        
        //初始化顶层图片视图
        self.topImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.topImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.topImageView];
        
    }
    return self;
}

- (void)dealloc{
    if (self.path) {
        CGPathRelease(self.path);
    }
    [self.mosaiManager releaseAllImage];
}

- (void)setOriginalImage:(UIImage *)originalImage{
    _originalImage  = originalImage;//原始图片
    self.topImageView.image = originalImage;//顶层视图展示原始图片
    self.mosaiFinalImage = originalImage;
    _mosaiManager = [[MosaiManager alloc]initWithOriImage:originalImage];
    
}

- (void)setMosaicImage:(UIImage *)mosaicImage{
    _mosaicImage = mosaicImage;//马赛克图片
    [self resetMosaiImage];
}

//重新设置马赛克
-(void)resetMosaiImage{
    //重新设置Layer与Path
    if (self.path) {
        CGPathRelease(self.path);
        self.path = nil;
    }
    self.path = CGPathCreateMutable();
    self.topImageView.image = _mosaiFinalImage;
    
    //移除轨迹
    [self.pathArray removeAllObjects];
    [_currentPath resetStatus];
    
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    
    [self.mosaicImageLayer removeFromSuperlayer];
    self.mosaicImageLayer = nil;
    
    
    self.mosaicImageLayer = [CALayer layer];
    self.mosaicImageLayer.frame  = self.bounds;
    [self.layer addSublayer:self.mosaicImageLayer];
    self.mosaicImageLayer.contents = (__bridge id _Nullable)([self.mosaicImage CGImage]);//将马赛克图层内容设置为马赛克图片内容
    
    
    //初始化遮罩图层
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.bounds;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineWidth = 10.0f;
    self.shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
    self.shapeLayer.fillColor = nil;
    [self.layer addSublayer:self.shapeLayer];
    self.mosaicImageLayer.mask = self.shapeLayer;
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathMoveToPoint(self.path, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = path;
    CGPathRelease(path);
    
    
    CGSize size = self.topImageView.image.size;
    CGFloat rate = size.width/self.topImageView.bounds.size.width;
    _currentPath.startPoint = CGPointMake(point.x * rate, point.y * rate);
    
    if ([self.deleagate respondsToSelector:@selector(mosaicView:TouchesBegan:withEvent:)]) {
        [self.deleagate mosaicView:self TouchesBegan:touches withEvent:event];
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathAddLineToPoint(self.path, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = path;
    CGPathRelease(path);
    
    
    CGSize size = self.topImageView.image.size;
    CGFloat rate = size.width/self.topImageView.bounds.size.width;
    PathPoint *pointPath = [[PathPoint alloc]init];
    pointPath.xPoint = point.x * rate;
    pointPath.yPoint = point.y * rate;
    [_currentPath.pathPointArray addObject:pointPath];
    
    if ([self.deleagate respondsToSelector:@selector(mosaicView:TouchesMoved:withEvent:)]) {
        [self.deleagate mosaicView:self TouchesMoved:touches withEvent:event];
    }
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    //画完之后需要保存一张原图,因为做多层马赛克的话，就是在上一次马赛克画笔之后的图作为原图，后面再叠加一层
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGSize size = self.topImageView.image.size;
    CGFloat rate = size.width/self.topImageView.bounds.size.width;
    _currentPath.endPoint = CGPointMake(point.x * rate, point.y * rate);
    
    
    MosaiPath *path = [_currentPath copy];
    [_pathArray addObject:path];
    [_currentPath resetStatus];
    
    UIGraphicsBeginImageContext(size);
    [self.topImageView.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    for (MosaiPath *path in _pathArray) {
        
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), path.startPoint.x, path.startPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), path.startPoint.x, path.startPoint.y);
        
        for (PathPoint *point in path.pathPointArray) {
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point.xPoint, point.yPoint);
        }
        
    }
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10.f * rate);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    UIImage *finalPath = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0);
    
//    UIImage *renderImage = _isGuassianBlurMode?[self coreBlurImage:self.originalImage withBlurNumber:10]:self.mosaicImage;
    [self.mosaicImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [finalPath drawInRect:CGRectMake(0, 0, size.width, size.height)];
    _mosaiFinalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //写入缓存
    [self.mosaiManager writeImageToCache:_mosaiFinalImage];
    _operationCount = self.mosaiManager.operationCount;
    
    if ([self.deleagate respondsToSelector:@selector(mosaicView:TouchesEnded:withEvent:)]) {
        [self.deleagate mosaicView:self TouchesEnded:touches withEvent:event];
    }
}

+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

//+ (UIImage *)filterForGaussianBlur:(UIImage*)image{

//    GPUImageGaussianBlurFilter *filter = [[GPUImageGaussianBlurFilter alloc]init];
//    [filter forceProcessingAtSize:image.size];
//    filter.blurRadiusInPixels = 10.0;//这个越大，越模糊，模糊半径
//
//    GPUImagePicture *pic = [[GPUImagePicture alloc]initWithImage:image];
//    [pic addTarget:filter];
//    [pic processImage];
//    [filter useNextFrameForImageCapture];
//    return [filter imageFromCurrentFramebuffer];
//}

+(UIImage *)mosaicImage:(UIImage *)sourceImage mosaicLevel:(NSUInteger)level{
    
    //1、这一部分是为了把原始图片转成位图，位图再转成可操作的数据
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//颜色通道
    CGImageRef imageRef = sourceImage.CGImage;//位图
    CGFloat width = CGImageGetWidth(imageRef);//位图宽
    CGFloat height = CGImageGetHeight(imageRef);//位图高
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast);//生成上下午
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), imageRef);//绘制图片到上下文中
    unsigned char *bitmapData = CGBitmapContextGetData(context);//获取位图的数据
    
    
    //2、这一部分是往右往下填充色值
    NSUInteger index,preIndex;
    unsigned char pixel[4] = {0};
    for (int i = 0; i < height; i++) {//表示高，也可以说是行
        for (int j = 0; j < width; j++) {//表示宽，也可以说是列
            index = i * width + j;
            if (i % level == 0) {
                if (j % level == 0) {
                    //把当前的色值数据保存一份，开始为i=0，j=0，所以一开始会保留一份
                    memcpy(pixel, bitmapData + index * 4, 4);
                }else{
                    //把上一次保留的色值数据填充到当前的内存区域，这样就起到把前面数据往后挪的作用，也是往右填充
                    memcpy(bitmapData +index * 4, pixel, 4);
                }
            }else{
                //这里是把上一行的往下填充
                preIndex = (i - 1) * width + j;
                memcpy(bitmapData + index * 4, bitmapData + preIndex * 4, 4);
            }
        }
    }
    
    //把数据转回位图，再从位图转回UIImage
    NSUInteger dataLength = width * height * 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData, dataLength, NULL);
    
    CGImageRef mosaicImageRef = CGImageCreate(width, height,
                                              8,
                                              32,
                                              width*4 ,
                                              colorSpace,
                                              kCGBitmapByteOrderDefault,
                                              provider,
                                              NULL, NO,
                                              kCGRenderingIntentDefault);
    CGContextRef outputContext = CGBitmapContextCreate(nil,
                                                       width,
                                                       height,
                                                       8,
                                                       width*4,
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(outputContext, CGRectMake(0.0f, 0.0f, width, height), mosaicImageRef);
    CGImageRef resultImageRef = CGBitmapContextCreateImage(outputContext);
    UIImage *resultImage = nil;
    if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        float scale = [[UIScreen mainScreen] scale];
        resultImage = [UIImage imageWithCGImage:resultImageRef scale:scale orientation:UIImageOrientationUp];
    } else {
        resultImage = [UIImage imageWithCGImage:resultImageRef];
    }
    CFRelease(resultImageRef);
    CFRelease(mosaicImageRef);
    CFRelease(colorSpace);
    CFRelease(provider);
    CFRelease(context);
    CFRelease(outputContext);
    return resultImage;
}
@end
