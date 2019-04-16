//
//  IEBaseCCollectionViewCell.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEBaseCCollectionViewCell.h"
#import <Masonry.h>


@implementation IEBaseCCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self.contentView addSubview:self.lbl];
    [self.contentView addSubview:self.iv];
    
    [self.lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(self.contentView);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.iv.mas_bottom).offset(2);
    }];
    
    [self.iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(self.contentView);
        make.centerY.mas_offset(self.contentView).offset(-8);
    }];
    
    return self;
}

- (UILabel *)lbl{
    if(_lbl){
        _lbl = [[UILabel alloc]init];
        
    }
    return _lbl;
}

- (UIImageView *)iv{
    if (!_iv) {
        _iv = [[UIImageView alloc]init];
        _iv.image = [UIImage imageNamed:@"ma"];
    }
    return _iv;
}
@end
