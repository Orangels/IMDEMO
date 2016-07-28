//
//  videoProgressView.h
//  talk2
//
//  Created by 刘森 on 16/6/2.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IEMChatProgressDelegate.h"
@interface videoProgressView : UIProgressView<IEMChatProgressDelegate>
- (void)setProgress:(float)progress forMessage:(EMMessage *)message forMessageBody:(id<IEMMessageBody>)messageBody;
@end
