//
//  IEImageView.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEImageView.h"
#import "IEStack.h"

@implementation IEDrawingModel


@end

@interface IEImageView ()

//layer存储栈
@property (nonatomic, strong) IEStack *drawStack;

//layer删除存储栈
@property (nonatomic, strong) IEStack *removeStack;

@property (nonatomic, strong) CAShapeLayer *currentShapeLayer;
@property (nonatomic, strong) UIBezierPath *bezierPath;


@property (nonatomic, strong) NSMutableArray<IEDrawingModel *> *allPathArr; // 路径数组
@property (nonatomic, strong) NSMutableArray *imageArr;// 图片的数组

@end

@implementation IEImageView

#pragma mark - Public
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        _lineWidth = 10.0;
        self.userInteractionEnabled = YES;
//        [self _addpanGesture];
        
    }
    
    return self;
}

- (BOOL)canBack{
    return ![self.drawStack isEmpty];
}

- (BOOL)canForward{
    return ![self.removeStack isEmpty];
}

- (UIImage *)outputImage{
    
    return [self captureImage];
}

- (void)backDraw{
    
    CAShapeLayer *shapeLayer = [self.drawStack popObj];
    if(shapeLayer){
        [shapeLayer removeFromSuperlayer];
        [self.removeStack push:shapeLayer];
    }
    
    [self stackChange];
}

- (void)forwardDraw{
    
    CAShapeLayer *shapeLayer = [self.removeStack popObj];
    if(shapeLayer){
        [self.layer addSublayer:shapeLayer];
        [self.drawStack push:shapeLayer];
    }
    
    [self stackChange];
}

- (void)stackChange{
    
    if(_drawBackListCountChange){
        self.drawBackListCountChange([self.drawStack stackLength]);
    }
    if(_drawForwardListCountChange){
        self.drawForwardListCountChange([self.removeStack stackLength]);
    }
}

#pragma mark - Private



//- (void)_addpanGesture
//{
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drawingPanAction:)];
//    [self addGestureRecognizer:pan];
//}
//
//- (void)drawingPanAction:(UIPanGestureRecognizer *)pan
//{
//    CGPoint currentPoint = [pan locationInView:self];
//    if (pan.state == UIGestureRecognizerStateBegan)
//    {
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        path.lineCapStyle = kCGLineCapRound;
//        path.lineJoinStyle = kCGLineJoinRound;
//        [path moveToPoint:currentPoint];
//        IEDrawingModel *model = _drawModel?:[IEDrawingModel new];
//        model.path = path;
//        if (self.drawModel.pathWidth == 0)
//        {
//            self.drawModel.pathWidth = 25;
//        }
//        if (self.drawModel.pathColor == nil)
//        {
//            self.drawModel.pathColor = [UIColor redColor];
//        }
//
//        [self.allPathArr addObject:model];
//    }
//    else if (pan.state == UIGestureRecognizerStateChanged)
//    {
//        if (self.isDrawing)
//        {
//            self.isDrawing();
//        }
//        [[((IEDrawingModel *) self.allPathArr.lastObject) path] addLineToPoint:currentPoint];
//        [self setNeedsDisplay];
//    }
//    else if (pan.state == UIGestureRecognizerStateEnded)
//    {
//        if (self.isEndDrawing)
//        {
//            self.isEndDrawing();
//        }
//    }
//}
//#pragma mark 绘制
//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//
//    for (IEDrawingModel *model in self.imageArr)
//    {
//        UIImage *image = model.drawingImage;
//        CGRect drawingRect = model.drawingRect;
//        [image drawInRect:CGRectMake(drawingRect.origin.x, drawingRect.origin.y + 30, drawingRect.size.width, drawingRect.size.height)];
//    }
//
//    for (IEDrawingModel *model in self.allPathArr)
//    {
//        [model.pathColor set];
//        model.path.lineWidth = model.pathWidth;
//        [model.path stroke];
//    }
//}
//
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    [self.removeStack removeAllObjects];
//
//    CGPoint point = [[touches anyObject] locationInView:self];
//
//
//    _currentShapeLayer = [CAShapeLayer layer];
//    _currentShapeLayer.frame = self.layer.bounds;
//    _currentShapeLayer.masksToBounds = YES;
//    [self.layer addSublayer:_currentShapeLayer];
//
//    [self.drawStack push:_currentShapeLayer];
//
//    _currentShapeLayer.strokeColor = _strokeColor.CGColor;
//    _currentShapeLayer.fillColor = [UIColor clearColor].CGColor;
//    _currentShapeLayer.lineJoin = kCALineJoinRound;
//    _currentShapeLayer.lineCap = kCALineCapRound;
//    _currentShapeLayer.lineWidth = _lineWidth;
//
//    _bezierPath = [UIBezierPath new];
//    [_bezierPath moveToPoint:point];
//    _currentShapeLayer.path = _bezierPath.CGPath;
//
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    CGPoint point = [[touches anyObject] locationInView:self];
//
//    [_bezierPath addLineToPoint:point];
//    _currentShapeLayer.path = _bezierPath.CGPath;
//
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    CGPoint point = [[touches anyObject] locationInView:self];
//    [_bezierPath addLineToPoint:point];
//    _currentShapeLayer.path = _bezierPath.CGPath;
//
//    [self stackChange];
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//}

- (UIImage *)captureImage{
    
    CGSize viewSize = self.bounds.size;
    
    if([self isKindOfClass:[UIImageView class]]){
        
        UIImageView *imageView = (UIImageView *)self;
        CGSize imageSize = imageView.image.size;
        UIGraphicsBeginImageContextWithOptions(viewSize, NO, imageSize.height/viewSize.height);
    }else{
        UIGraphicsBeginImageContext(viewSize);
    }
    
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:contextRef];
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return returnImage;
}

- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}


#pragma mark - GET

- (IEStack *)drawStack{
    
    if(!_drawStack){
        _drawStack = [[IEStack alloc] init];
    }
    return _drawStack;
}

- (IEStack *)removeStack{
    
    if(!_removeStack){
        _removeStack = [[IEStack alloc] init];
    }
    return _removeStack;
}

- (NSMutableArray *)allPathArr
{
    if (!_allPathArr)
    {
        _allPathArr = [NSMutableArray array];
    }
    return _allPathArr;
}
- (NSMutableArray *)imageArr
{
    if (!_imageArr)
    {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

@end
