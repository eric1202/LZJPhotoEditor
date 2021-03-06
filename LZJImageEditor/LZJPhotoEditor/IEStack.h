//
//  IEStack.h
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^StackBlock)(id obj);

NS_ASSUME_NONNULL_BEGIN

@interface IEStack : NSObject

//存储栈数据
@property (nonatomic, strong) NSMutableArray *stackArray;


/**
 入栈
 
 @param obj 指定入栈对象
 */
- (void)push:(id)obj;


/**
 出栈
 
 @return 出栈对象
 */
- (id)popObj;


/**
 是否为空
 */
- (BOOL)isEmpty;


/**
 栈的长度
 */
- (NSInteger)stackLength;


/**
 从顶部开始遍历
 */
- (void)enumerateObjectFromTop:(StackBlock)block;


/**
 从底部开始遍历
 */
-(void)enumerateObjectsFromBottom:(StackBlock)block;


/**
 所有元素出栈，一边出栈一边返回元素
 */
- (void)enumerateObjectsPopStack:(StackBlock)block;


/**
 清空所有元素
 */
- (void)removeAllObjects;


/**
 返回栈顶元素
 */
- (id)topObj;

@end

NS_ASSUME_NONNULL_END
