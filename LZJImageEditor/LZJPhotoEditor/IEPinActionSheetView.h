//
//  IEPinView.h
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEActionSheetView.h"

NS_ASSUME_NONNULL_BEGIN

@interface IEPinActionSheetView : IEActionSheetView
@property (nonatomic, strong) NSMutableArray *mapImageArr; // 贴图数据

- (void)show;

@end

NS_ASSUME_NONNULL_END
