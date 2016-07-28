//
//  groupHeaderView.m
//  talk2
//
//  Created by 刘森 on 16/6/4.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "groupHeaderView.h"
#import "groupMemberCollectionViewCell.h"
@interface groupHeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView* cv;
@end

@implementation groupHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatCollectionView]; 
    }
    return self;
}

- (void)creatCollectionView{
    UICollectionViewFlowLayout* flow = [UICollectionViewFlowLayout new];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumInteritemSpacing = 30;
    flow.minimumLineSpacing = 30;
    flow.itemSize = CGSizeMake(50, 70);
    _cv = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 10, self.frame.size.width, self.frame.size.height) collectionViewLayout:flow];
    _cv.delegate = self;
    _cv.dataSource = self;
    _cv.backgroundColor = [UIColor whiteColor];
    [_cv registerClass:[groupMemberCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_cv];
    NSLog(@"%@",_memberArr);
}
#pragma mark -- collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%d",_memberArr.count);
    return _memberArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    groupMemberCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell showTheCellWithName:_memberArr[indexPath.row]];
    return cell;
}
@end
