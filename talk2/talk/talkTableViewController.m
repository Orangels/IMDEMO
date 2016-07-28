//
//  talkTableViewController.m
//  talk2
//
//  Created by 刘森 on 16/5/23.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "talkTableViewController.h"
#import "testTableViewController.h"
#import "EaseMob.h"

@interface talkTableViewController ()
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *conversationArr;
@end

@implementation talkTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadMyConversation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr                      = [[NSMutableArray alloc]init];
    _conversationArr              = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadMyConversation];
}

- (void)loadMyConversation{
    //清空数据源
    [_dataArr removeAllObjects];
    [_conversationArr removeAllObjects];
    //创建未读消息总数
    NSInteger sumUnRead = 0;
    //获取所有与我相关的对话
    NSArray * conversationsArr = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    //<EMConversation*>
    for (EMConversation *conversation in conversationsArr) {
        //获取当前会话聊天者、未读消息个数、最后一条消息等
        NSString *chatter = conversation.chatter;
        __block NSString* myGroupName = [NSString string];
        if (conversation.conversationType == eConversationTypeGroupChat) {
            //获取群信息,用 同步方法
            EMGroup* group = [[EaseMob sharedInstance].chatManager fetchGroupInfo:chatter error:nil];
            myGroupName = group.groupSubject;
        }
        NSInteger unRead = conversation.unreadMessagesCount;
        sumUnRead += unRead;//未读总数
        if (conversation.conversationType == eConversationTypeGroupChat) {
            [_dataArr addObject:[NSString stringWithFormat:@"%@(%lu) (id:%@)",myGroupName,unRead,chatter]];
        }else{
            [_dataArr addObject:[NSString stringWithFormat:@"%@(%lu)",chatter,unRead]];
        }
        [_conversationArr addObject:conversation];
    }
    //刷新TableView
    [self.tableView reloadData];
    //更新下方标签栏未读总数
    UITabBarItem *item = self.tabBarController.tabBar.items[1];
    if (sumUnRead != 0) {
        item.badgeValue = [NSString stringWithFormat:@"%lu",sumUnRead];
    }else{
        item.badgeValue = nil;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text          = _dataArr[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.accessoryType           = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([_dataArr[indexPath.row] rangeOfString:@"id"].location != NSNotFound) {
        //群图片
        cell.imageView.image = [UIImage imageNamed:@"groupPublicHeader"];
    }else{
        //个人图片
        cell.imageView.image = [UIImage imageNamed:@"chatListCellHead"];
    }
    return cell;
}
//点击cell 方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMConversation* conversation = _conversationArr[indexPath.row];
    NSString* chatter = conversation.chatter;
    testTableViewController* testVC = [testTableViewController new];
    testVC.buddyName = chatter;
    testVC.hidesBottomBarWhenPushed = YES;
    testVC.isBuddy = (conversation.conversationType == eConversationTypeChat ? YES:NO);
    
    [self.navigationController pushViewController:testVC animated:YES];
}
//滑动标题和点击方法
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        EMConversation* conversation = _conversationArr[indexPath.row];
        NSString* chatter = conversation.chatter;
        [_dataArr removeObjectAtIndex:indexPath.row];
        [_conversationArr removeObjectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatter deleteMessages:YES append2Chat:YES];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    UITableViewRowAction *loadRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"标记已读" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        EMConversation* conversation = _conversationArr[indexPath.row];
        [conversation markAllMessagesAsRead:YES];
        [self loadMyConversation];
        NSLog(@"标记已读");
    }];
    return @[deleteRowAction,loadRowAction];
}

//编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
#warning  删除对话
//删除对话
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation* conversation = _conversationArr[indexPath.row];
        NSString* chatter = conversation.chatter;
        [_dataArr removeObjectAtIndex:indexPath.row];
        [_conversationArr removeObjectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatter deleteMessages:YES append2Chat:YES];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
