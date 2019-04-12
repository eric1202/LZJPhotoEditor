//
//  IEManager.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/12.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEManager.h"

@implementation IEManager
-(instancetype)init{
    self = [super init];
    if (self) {
        self.options = @[@{@"image":@"img",@"title":@"贴图"},
                         @{@"image":@"clip",@"title":@"裁剪"},
                         @{@"image":@"ma",@"title":@"马赛克"},
                         @{@"image":@"text",@"title":@"文字"},
                         ];
    }
    
    return self;
}
@end
