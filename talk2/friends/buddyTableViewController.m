//
//  buddyTableViewController.m
//  talk2
//
//  Created by 刘森 on 16/5/23.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "buddyTableViewController.h"
#import <EaseMob.h>
#import "addBuddyViewController.h"
#import "alowBuddyViewController.h"
#import "testTableViewController.h"
#import "lsView.h"
#import "groupTableViewController.h"
#define WITH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface buddyTableViewController ()<EMChatManagerDelegate,EMChatManagerBuddyDelegate,IChatManagerDelegate>
@property (nonatomic,strong) lsView* lsPopView;
@end

@implementation buddyTableViewController


#if 1
#pragma mark -- 好友管理

- (void)dataRefresh{
    _requestBuddyArr = [NSMutableArray array];
}
#pragma mark -- view 消失时候进行初始化
- (void)viewWillDisappear:(BOOL)animated{
    //初始化,防止换号登录时保留上一个号的设置,改为登录 new 所有的界面以后,这个实际上只是起到改变 editing 的作用
    self.tableView.editing = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:246/255.0 green:247/255.0 blue:239/255.0 alpha:1];

    self.navigationItem.title                           = @"好友";
    self.tableView.separatorStyle                       = UITableViewCellSeparatorStyleNone;
    self.navigationItem.rightBarButtonItem              = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showView:)];
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;

    [self creatLsPopView];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
}
    
- (void)creatLsPopView{
    CGPoint point    = CGPointMake(WITH-30, 54);
    NSInteger width  = 100;
    NSInteger height = 30;
    //2个 button
    _lsPopView = [[lsView alloc] initWithOrigin:point Width:width Height:(height+10)*4+10 Direction:lsArrowDirectionUp3];
    NSArray* titleArr = @[@"多选好友",@"添加好友",@"删除好友",@"群组"];
    
    for (int i = 0; i<4; i++) {
        UIButton* btn          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame              = CGRectMake(10, 10+i*(height+10), width-10*2, height);
        btn.layer.cornerRadius = 10;
        btn.tag                = 100+i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addBuddy:) forControlEvents:UIControlEventTouchUpInside];
        [_lsPopView.backView addSubview:btn];
    }
        
}
    


- (void)getList{
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            [_buddyArr removeAllObjects];
//            NSLog(@"获取成功 -- %@",buddyList);
            _buddyArr = [NSMutableArray arrayWithArray:buddyList];
            [self.tableView reloadData];

        }else{
            NSLog(@"%@",error);
        }
    } onQueue:nil];
}

- (void)showView:(UIBarButtonItem*)btn{
    [_lsPopView popView];
    
}

//右上方点击 button
#warning 添加好友
-(IBAction)addBuddy:(UIBarButtonItem*)btn{
    [_lsPopView dismiss];
    switch (btn.tag) {
        case 100:{
            //多选好友,改变cell 的箭头,提示可不可以点击跳转
            if (self.tableView.editing == YES) {
                [self.tableView setEditing:NO animated:YES];
                for (UITableViewCell* cell in self.tableView.visibleCells) {
                    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
                }
            }else{
                [self.tableView setEditing:YES animated:YES];
                for (UITableViewCell* cell in self.tableView.visibleCells) {
                    cell.accessoryType  = UITableViewCellAccessoryNone;
                }
            }
            break;
        }
        case 101:{
            //添加好友
            addBuddyViewController* addBVC = [addBuddyViewController new];
            [self.navigationController pushViewController:addBVC animated:YES];
            break;
        }
        case 102:{
            //删除好友
            
            dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
            dispatch_group_t group = dispatch_group_create();
            
            NSArray* indexPathArr = self.tableView.indexPathsForSelectedRows;
#warning 这里因为用的是异步删除 _buddyArr[0],所以如果不是全部删除的时候删除好友会有问题,删除的永远是第一个好友,而不是选中的好友,暂时的解决办法是把异步方法写成同步方法,然后删除数组元素对应的 indexPath ,这里暂时未做修改,还有 BUG
            for (NSIndexPath* indexPath in indexPathArr) {
                if (indexPath.section == 1) {
                    dispatch_group_async(group, queue, ^{
                        EMError *error = nil;
                        // 删除好友
                        //这里用0 是因为异步执行
                        //这里应该改成同步方法,然后删除 EMBuddy* buddy = _buddyArr[indexPath.row]
                        EMBuddy* buddy = _buddyArr[0];
                        BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:buddy.username removeFromRemote:YES error:&error];
                        //删除与这个 buddy 的会话记录
                        [[EaseMob sharedInstance].chatManager removeConversationByChatter:buddy.username deleteMessages:YES append2Chat:YES];
                        if (isSuccess && !error) {
                            NSLog(@"删除成功");
                        }
                        NSLog(@"%ld",_buddyArr.count);
                        [_buddyArr removeObjectAtIndex:0];
                    });
                }
            }
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                NSLog(@"全部删除完毕");
            });
            break;
        }
        case 103:{
            //群组
            groupTableViewController* groupTVC = [groupTableViewController new];
            [self.navigationController pushViewController:groupTVC animated:YES];
            NSLog(@"进入群组");
            break;
        }
        default:
            break;
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"好友申请";
    }
    return @"好友列表";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //好友申请
    if (section == 0) {
        return _requestBuddyArr.count;

    }
    //好友列表
        return _buddyArr.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        EMBuddy* buddy      = _buddyArr[indexPath.row];
        cell.textLabel.text = buddy.username;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        //个人图片
        cell.imageView.image = [UIImage imageNamed:@"chatListCellHead"];
        return cell;
    }else{
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"recell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"recell"];
        }
        //个人图片
        cell.imageView.image = [UIImage imageNamed:@"chatListCellHead"];
        cell.textLabel.text       = _requestBuddyArr[indexPath.row][@"username"];
        cell.detailTextLabel.text = _requestBuddyArr[indexPath.row][@"message"];
        cell.selectionStyle       = UITableViewCellSelectionStyleNone;
        
        if (self.tableView.editing==NO) {
            cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType        = UITableViewCellAccessoryNone;
        }
        return cell;
    }
}
//选择 cell 方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing == NO) {
        if (indexPath.section == 0) {
            alowBuddyViewController* alowVC = [alowBuddyViewController new];
            
            alowVC.dic = _requestBuddyArr[indexPath.row];
            NSLog(@"%@",alowVC.dic);
            alowVC.block = ^(NSDictionary* dic){
                [_requestBuddyArr removeObject:dic];
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:alowVC animated:YES];
        }
        else{
            testTableViewController* ttvc = [testTableViewController new];
            EMBuddy* buddy                = _buddyArr[indexPath.row];
            ttvc.buddyName                = buddy.username;
            ttvc.isBuddy                  = YES;
            ttvc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:ttvc animated:YES];
        }
    }else{
        
    }
}


#endif


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1 ? YES:NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            
            EMError *error = nil;
            // 删除好友
            
            EMBuddy* buddy = _buddyArr[indexPath.row];
            BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:buddy.username removeFromRemote:YES error:&error];
            if (isSuccess && !error) {
                NSLog(@"删除成功");
            }
            //删除与这个 buddy 的会话
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:buddy.username deleteMessages:YES append2Chat:YES];
            [_buddyArr removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
