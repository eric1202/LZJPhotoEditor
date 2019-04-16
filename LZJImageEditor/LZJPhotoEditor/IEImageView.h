//
//  IEImageView.h
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface IEDrawingModel : NSObject

@property (nonatomic, assign) CGFloat pathWidth;  // 宽度
@property (nonatomic, strong) UIColor *pathColor; // 颜色
@property (nonatomic, strong) UIBezierPath *path; // 路径

@property (nonatomic, strong) UIImage *drawingImage; // 绘画的图片
@property (nonatomic, assign) CGRect drawingRect;    // 绘画的坐标

@end
NS_ASSUME_NONNULL_BEGIN

@interface IEImageView : UIImageView
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) IEDrawingModel *drawModel;

@property (nonatomic, copy) void (^isDrawing)(void);    // 正在绘制
@property (nonatomic, copy) void (^isEndDrawing)(void); // 结束绘制

@property (nonatomic, copy) void (^drawBackListCountChange) (NSInteger count);
@property (nonatomic, copy) void (^drawForwardListCountChange) (NSInteger count);

@property (nonatomic, strong) UIImage *originImage;

//后退
- (void)backDraw;
//前进
- (void)forwardDraw;

//是否可以后退
- (BOOL)canBack;
//是否可以前进
- (BOOL)canForward;

- (UIImage *)outputImage;

@end

NS_ASSUME_NONNULL_END
