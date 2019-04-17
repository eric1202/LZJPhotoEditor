//
//  IEActionSheetView.h
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IEActionSheetView;
@interface IEConfig : NSObject

@property (nonatomic, copy) NSArray *datas;


/**
 圆角
 */
@property(nonatomic,assign)CGFloat circular;


/**
 开始的Y值
 */
@property(nonatomic,assign)CGFloat offsetY;


/**
 落地时候的 Y值
 */
@property(nonatomic,assign)CGFloat fallY;

/*
 标题
 */
@property(nonatomic,strong)NSString *title;

/**
 每行元素
 */
@property (nonatomic, assign) NSInteger itemInlineCount;
@end

@protocol IEActionSheetViewDelegate <NSObject>

- (void)didSelectAtIndex:(NSInteger)index ActionView:(IEActionSheetView *)view Image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_BEGIN

@interface IEActionSheetView : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, weak) id<IEActionSheetViewDelegate> delegate;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, copy) NSArray *selectedDatas;
@property (nonatomic, copy) NSArray *datas;

- (IEActionSheetView *)initWithConfig:(IEConfig *)config;

/**
 打开
 */
-(void)show;

/**
 关闭
 */
-(void)dismiss;

@end




NS_ASSUME_NONNULL_END
