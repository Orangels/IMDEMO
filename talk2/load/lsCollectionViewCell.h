//
//  lsCollectionViewCell.h
//  UICollectionView
//
//  Created by 刘森 on 16/4/21.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^myblock)(NSString*);
@interface lsCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView* iv;
@property(copy,nonatomic)NSString* image;
@property(copy,nonatomic)myblock block;
-(void)setmyImage:(NSString*)image;
@end
