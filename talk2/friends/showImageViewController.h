//
//  showImageViewController.h
//  talk2
//
//  Created by 刘森 on 16/6/1.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface showImageViewController : UIViewController

@property (nonatomic,assign) CGFloat  scale;
@property (nonatomic,strong) UIImage  * bigImage;
@property (nonatomic,copy  ) NSString * imagePath;
@end
