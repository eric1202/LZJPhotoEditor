//
//  IEActionSheetView.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEActionSheetView.h"
#import <Masonry.h>
#import "IEBaseCCollectionViewCell.h"
@interface IEActionSheetView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIPanGestureRecognizer *panGR;
@property (nonatomic,assign) CGFloat oldY;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) IEConfig *config;
@end

@implementation IEActionSheetView

#pragma mark - private

- (instancetype)initWithConfig:(IEConfig *)config{
    self = [super init];
    if(self){
        //设置圆角
        self.config = config;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(config.circular, config.circular)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        [self addSubview:self.collectionView];
        [self addSubview:self.titleLabel];
        
        //拖拽手势
        _panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAct:)];
        _panGR.delegate = self;
        [self.collectionView addGestureRecognizer:_panGR];
        
        //layout
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(15);
        }];
    }
    return self;
}

-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[IEBaseCCollectionViewCell class] forCellWithReuseIdentifier:@"IEBaseCCollectionViewCell"];
    }
    
    return _collectionView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"操作";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font =[UIFont systemFontOfSize:14];
    }
    
    return _titleLabel;
}



-(void)panGRAct:(UIPanGestureRecognizer *)pan{
    
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    CGRect cellFrameInSuperview = [self.collectionView convertRect:attributes.frame toView:[self.collectionView superview]];

    CGFloat scrollY = cellFrameInSuperview.origin.y;
    
    if (self.collectionView.contentOffset.y <= scrollY){
        self.collectionView.scrollEnabled = NO;
        CGPoint translationPoint = [_panGR translationInView:self.collectionView];
        CGRect rect = self.frame;
        rect.origin.y +=translationPoint.y;
        
        if (rect.origin.y <= self.config.offsetY) {
            rect.origin.y = self.config.offsetY;
        }
        self.frame=rect;
        [pan setTranslation:CGPointZero inView:self.collectionView];
        
    }
    
    if (pan.state==UIGestureRecognizerStateEnded) {
        CGFloat endY = self.frame.origin.y;
        if (endY>=(self.config.offsetY + self.config.fallY)) {
            [self dismiss];
            
        }else{
            [self show];
        }
    }
}



#pragma mark - public

- (void)show{
    
}

- (void)dismiss{
    
}

#pragma mark - delegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    IEBaseCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IEBaseCCollectionViewCell" forIndexPath:indexPath];
    [cell.lbl setText:[NSString stringWithFormat:@"%@",indexPath]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datas.count;
}


@end
