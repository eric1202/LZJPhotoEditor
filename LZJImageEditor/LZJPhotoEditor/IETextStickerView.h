//
//  IETextStickerView.h
//  LZJImageEditor
//
//  Created by weima on 2019/4/16.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEStickerBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface IETextStickerView : IEStickerBaseView


@property (nonatomic, strong) UILabel *contentLabel;

- (instancetype)initWithLabelHeight:(CGSize)labelSize;


@end

NS_ASSUME_NONNULL_END
