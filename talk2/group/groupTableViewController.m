//
//  groupTableViewController.m
//  talk2
//
//  Created by 刘森 on 16/5/25.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "groupTableViewController.h"
#import "lsView.h"
#import "EaseMob.h"
#import "testTableViewController.h"
#import "creatGroupViewController.h"
#import "buddyTableViewController.h"
#import "nearBuddyViewController.h"
#define WITH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface groupTableViewController ()<EMChatManagerGroupDelegate,EMChatManagerDelegate>
@property (nonatomic,strong) lsView         * lsPopView;

@end

@implementation groupTableViewController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //creatGroup 界面传入新的 groupArr, 重新加载 tableview
    //获取 与我相关的群组
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
        _groupArr = [NSMutableArray arrayWithArray:groups];
        [self.tableView reloadData];
    } onQueue:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _groupArr   = [NSMutableArray array];
//    //获取 与我相关的群组
//    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
//        _groupArr = [NSMutableArray arrayWithArray:groups];
//        [self.tableView reloadData];
//    } onQueue:nil];
    
    self.navigationItem.title                                          = @"群组";
    self.tableView.separatorStyle                       = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.navigationItem.rightBarButtonItem              = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showView:)];
    [self creatLsPopView];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];

}

- (void)showView:(UIBarButtonItem*)btn{
    [_lsPopView popView];
}

- (void)creatLsPopView{
    CGPoint point    = CGPointMake(WITH-30, 54);
    NSInteger width  = 100;
    NSInteger height = 30;
    //2个 button
    _lsPopView = [[lsView alloc] initWithOrigin:point Width:width Height:(height+10)*2+10 Direction:lsArrowDirectionUp3];
    NSArray* titleArr = @[@"创建群组",@"附近的人"];
    
    for (int i = 0; i<2; i++) {
        UIButton* btn          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame              = CGRectMake(10, 10+i*(height+10), width-10*2, height);
        btn.layer.cornerRadius = 10;
        btn.tag                = 1000+i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_lsPopView.backView addSubview:btn];
    }

}

- (IBAction)btnClick:(UIButton*)btn{
    [_lsPopView dismiss];
    switch (btn.tag) {
        case 1000:{
            //创建群组
            creatGroupViewController* cgTVC = [creatGroupViewController new];
            buddyTableViewController* buddyVC = self.navigationController.viewControllers[0];
            cgTVC.allBuddyArr = buddyVC.buddyArr;
            [self.navigationController pushViewController:cgTVC animated:YES];
            NSLog(@"创建群组");
            break;
        }
        case 1001:{
            //查找群组
            //这里暂时写附近的人功能
            
            nearBuddyViewController* vc = [nearBuddyViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            NSLog(@"查找群组");
            break;
        }
        default:
            break;
    }
    //view消失
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
    return _groupArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    EMGroup* group      = _groupArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",group.groupSubject,group.groupId];
    //群图片
    cell.imageView.image = [UIImage imageNamed:@"groupPublicHeader"];
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    testTableViewController* testTVC = [testTableViewController new];
    EMGroup* group                   = _groupArr[indexPath.row];
    testTVC.buddyName                = group.groupId;
    testTVC.isBuddy                  = NO;
    testTVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:testTVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
