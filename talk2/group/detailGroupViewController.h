//
//  detailGroupViewController.h
//  talk2
//
//  Created by 刘森 on 16/6/4.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMob.h"
@interface detailGroupViewController : UIViewController
@property (nonatomic,strong) NSArray   * memberArr;
@property (nonatomic,assign) NSInteger num;
@property (nonatomic,copy  ) NSString  * buddyName;
@property (nonatomic,strong) EMGroup   * myGroup;

- (void)creatCollectionView;
@end
