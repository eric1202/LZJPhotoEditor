//
//  IEMasaicView.h
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEActionSheetView.h"
#import "IEImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface IEMasaicView : IEActionSheetView
@property (nonatomic, weak) IEImageView *originImageView;
@end

NS_ASSUME_NONNULL_END
