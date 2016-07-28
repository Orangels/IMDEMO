//
//  videoProgressView.m
//  talk2
//
//  Created by 刘森 on 16/6/2.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "videoProgressView.h"

@implementation videoProgressView


- (void)setProgress:(float)progress forMessage:(EMMessage *)message forMessageBody:(id<IEMMessageBody>)messageBody{
    NSLog(@"%f",progress);
    self.progress = progress;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
