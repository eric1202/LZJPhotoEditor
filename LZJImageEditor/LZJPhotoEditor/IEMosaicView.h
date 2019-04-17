//
//  IEMasaicView.h
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEActionSheetView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IEMosaicViewDelegate;
@interface IEMosaicView : UIView

//底图为马赛克图
@property (nonatomic, strong) UIImage *mosaicImage;
//表图为正常图片
@property (nonatomic, strong) UIImage *originalImage;
//OperationCount
@property (nonatomic, assign, readonly) NSInteger operationCount;
//CurrentIndex
@property (nonatomic, assign, readonly) NSInteger currentIndex;
//Delegate
@property (nonatomic, weak) id<IEMosaicViewDelegate> deleagate;

@property (nonatomic, assign) BOOL isGuassianBlurMode;

//Resetmasaic
-(void)resetmasaicImage;

//Redo
-(void)redo;

//Undo
-(void)undo;

-(BOOL)canUndo;

-(BOOL)canRedo;

/** 生成马赛克元素图 **/
+(UIImage *)mosaicImage:(UIImage *)sourceImage mosaicLevel:(NSUInteger)level;

/** 生成模糊元素图 **/
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

//Render
-(UIImage*)render;
@end


@protocol IEMosaicViewDelegate<NSObject>

-(void)mosaicView:(IEMosaicView*)view TouchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
-(void)mosaicView:(IEMosaicView*)view TouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)mosaicView:(IEMosaicView*)view TouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
NS_ASSUME_NONNULL_END
