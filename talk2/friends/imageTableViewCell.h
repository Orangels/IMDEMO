//
//  imageTableViewCell.h
//  talk2
//
//  Created by 刘森 on 16/5/31.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "videoProgressView.h"
typedef void (^imageblock)(UIImage* image);
@interface imageTableViewCell : UITableViewCell

@property (nonatomic,strong) videoProgressView * progress;
@property (nonatomic,copy  ) imageblock block;

- (void)showlitImage:(NSString*)litImage andBigImage:(NSString*)bigImage andFrom:(BOOL)isLeft andName:(NSString*)name;
- (void)showVideoImage:(NSString*)videoImage andFrom:(BOOL)isLeft andName:(NSString*)name andVideoPath:(NSString*)videoPath;
@end
