//
//  IEBaseCollectionViewCell.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEBaseCollectionViewCell.h"
#import <Masonry.h>


@implementation IEBaseCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self.contentView addSubview:self.lbl];
    [self.contentView addSubview:self.iv];
    
    [self.lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.iv.mas_bottom).offset(2);
    }];
    
    [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView).offset(-8);
    }];
    
    return self;
}

- (UILabel *)lbl{
    if(!_lbl){
        _lbl = [[UILabel alloc]init];
        _lbl.textColor = UIColor.lightGrayColor;
        _lbl.textAlignment = NSTextAlignmentCenter;
    }
    return _lbl;
}

- (UIImageView *)iv{
    if (!_iv) {
        _iv = [[UIImageView alloc]init];
        _iv.image = [UIImage imageNamed:@"ma"];
        _iv.backgroundColor = UIColor.lightGrayColor;
    }
    return _iv;
}
@end
