//
//  alowBuddyViewController.h
//  talk2
//
//  Created by 刘森 on 16/5/24.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^myblock)(NSDictionary* dic);

@interface alowBuddyViewController : UIViewController
@property (nonatomic,copy) NSDictionary* dic;
@property (nonatomic,copy) myblock block;

@end
