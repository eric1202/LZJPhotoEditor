//
//  IEStack.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEStack.h"

@implementation IEStack
- (void)push:(id)obj{
    
    [self.stackArray addObject:obj];
}

- (id)popObj{
    
    if ([self isEmpty]){
        return nil;
    }else{
        id obj = self.stackArray.lastObject;
        [self.stackArray removeLastObject];
        return obj;
    }
}

- (BOOL)isEmpty{
    
    return !self.stackArray.count;
}

- (NSInteger)stackLength{
    
    return self.stackArray.count;
}

- (void)enumerateObjectFromTop:(StackBlock)block{
    
    [self.stackArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        block ? block(obj) : nil;
    }];
}

-(void)enumerateObjectsFromBottom:(StackBlock)block {
    
    [self.stackArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        block ? block(obj) : nil;
    }];
}

- (void)enumerateObjectsPopStack:(StackBlock)block{
    
    NSUInteger count = self.stackArray.count;
    
    for (NSUInteger i = count; i > 0; i--) {
        if(block){
            block(self.stackArray.lastObject);
            [self popObj];
        }
    }
}

- (void)removeAllObjects{
    
    [self.stackArray removeAllObjects];
}

- (id)topObj{
    
    if([self isEmpty]){
        return nil;
    }else{
        return self.stackArray.lastObject;
    }
}

- (NSMutableArray *)stackArray{
    
    if(!_stackArray){
        _stackArray = [[NSMutableArray alloc] init];
    }
    return _stackArray;
}
@end
