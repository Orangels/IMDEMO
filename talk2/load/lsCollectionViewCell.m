//
//  lsCollectionViewCell.m
//  UICollectionView
//
//  Created by 刘森 on 16/4/21.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "lsCollectionViewCell.h"

@implementation lsCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _iv = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_iv];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
//编辑视图中 变换头像 的点击方法
-(IBAction)tap:(UITapGestureRecognizer*)tap{
    _block(_image);
}
-(void)setmyImage:(NSString*)image{
    self.iv.image = [UIImage imageNamed:image];
    self.image = image;
}
@end
