//
//  groupMemberCollectionViewCell.m
//  talk2
//
//  Created by 刘森 on 16/6/4.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "groupMemberCollectionViewCell.h"

@interface groupMemberCollectionViewCell ()
@property (nonatomic,strong) UIImageView * iv;
@property (nonatomic,strong) UILabel     * nameLabel;

@end


@implementation groupMemberCollectionViewCell


//50,70
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _iv                      = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _iv.image                = [UIImage imageNamed:@"chatListCellHead"];
        _iv.layer.cornerRadius   = 10;
        _iv.clipsToBounds        = YES;
        [self.contentView addSubview:_iv];

        _nameLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 50, 20)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;

        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)showTheCellWithName:(NSString*)name{
    _nameLabel.text = name;
}
@end
