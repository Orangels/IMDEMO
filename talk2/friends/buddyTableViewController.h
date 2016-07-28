//
//  buddyTableViewController.h
//  talk2
//
//  Created by 刘森 on 16/5/23.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface buddyTableViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray * buddyArr;
@property (nonatomic,strong) NSMutableArray * requestBuddyArr;
@property (nonatomic,strong) NSMutableArray * listArray;
/**
 *  初始化数据,退出时调用
 */
- (void)dataRefresh;
- (void)getList;
@end
