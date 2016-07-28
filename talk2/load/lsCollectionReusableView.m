//
//  lsCollectionReusableView.m
//  5.1作业 Demo
//
//  Created by 刘森 on 16/5/1.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "lsCollectionReusableView.h"

@implementation lsCollectionReusableView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _lab.center = CGPointMake(self.center.x, 30);
        [self addSubview:_lab];
    }
    return self;
}
@end
