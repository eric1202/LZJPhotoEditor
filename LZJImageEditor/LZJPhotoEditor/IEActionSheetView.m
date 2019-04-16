//
//  IEActionSheetView.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEActionSheetView.h"
#import "IEHelper.h"
#import <Masonry.h>
#import "IEBaseCollectionViewCell.h"

@implementation IEConfig

@end


@interface IEActionSheetView ()<UICollectionViewDelegate, UICollectionViewDataSource>
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
        UIView *v = [IEHelper findViewController].view;
        self.frame = CGRectMake(0, CGRectGetHeight(v.frame)*0.61, CGRectGetWidth(v.frame),CGRectGetHeight(v.frame));
        config.circular = 8;
        self.config = config;
        //设置圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(config.circular, config.circular)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.titleLabel.layer.mask = maskLayer;
        [self addSubview:self.titleLabel];
        
        [self addSubview:self.collectionView];
        self.datas = self.config.datas;
        self.titleLabel.text = self.config.title;
        
        //拖拽手势
//        _panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAct:)];
//        _panGR.delegate = self;
//        [self.collectionView addGestureRecognizer:_panGR];
        
        //layout
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0);
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
        CGFloat wd = CGRectGetWidth(self.frame)/4-3;
        
        layout.minimumInteritemSpacing = 1;
        
        layout.itemSize = CGSizeMake(wd, wd);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerClass:[IEBaseCollectionViewCell class] forCellWithReuseIdentifier:@"IEBaseCCollectionViewCell"];
    }
    
    return _collectionView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"操作";
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.backgroundColor = UIColor.whiteColor;
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
    IEBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IEBaseCCollectionViewCell" forIndexPath:indexPath];
    [cell.lbl setText:[NSString stringWithFormat:@"%@",indexPath]];
    cell.iv.image = [UIImage imageNamed:_datas[indexPath.item]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datas.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate) {
        [_delegate didSelectAtIndex:indexPath.item ActionView:self Image:[UIImage imageNamed:_datas[indexPath.item]]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

@end
