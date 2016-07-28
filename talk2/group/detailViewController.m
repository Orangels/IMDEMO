//
//  detailViewController.m
//  talk2
//
//  Created by 刘森 on 16/6/3.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "detailViewController.h"
#import "EaseMob.h"
#import "detailGroupViewController.h"
#import "groupHeaderView.h"
#import "AppDelegate.h"
@interface detailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray     * titleArr;
@property (nonatomic,strong) EMGroup     * group;

@end

@implementation detailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];

    self.navigationItem.title = _group.groupSubject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    if (_isBuddy) {
        [self creatBuddyUI];
    }else{
        [self creatGroupUI];
    }
}

- (void)loadData{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleArr = @[@"群组 ID",@"群组人数",@"群设置",@"修改群名称"];
#warning 这里获取单个群信息,服务器会判定没有进入群,会没有各种权限对群进行操作,所以获得 db 中的群列表,才可以对群进行操作(用的是获取本地数据库的方法)
    NSArray *groupList = [[EaseMob sharedInstance].chatManager loadAllMyGroupsFromDatabaseWithAppend2Chat:YES];
    _group    = [[EaseMob sharedInstance].chatManager fetchGroupInfo:_buddyName error:nil];
    
    
}

- (void)creatBuddyUI{
    NSLog(@"单人界面");
}

- (void)creatGroupUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 280+120) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //解散/退出 button
    UIButton* btn          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame              = CGRectMake(20, _tableView.frame.origin.y+_tableView.frame.size.height+30, [UIScreen mainScreen].bounds.size.width-40, 30);
    btn.backgroundColor    = [UIColor orangeColor];
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"解散/退出 群组" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(quitGroup:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (IBAction)quitGroup:(UIButton*)btn{
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    
    if ([app.username isEqualToString:_group.owner]) {
        //当前用户是创建者
        UIAlertController* alert    = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定解散该群?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction* doneAction   = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //加载动画
            UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            activityView.hidesWhenStopped         = YES;
            [self.view addSubview:activityView];
            activityView.center = self.view.center;
            [self.view addSubview:activityView];
            [activityView startAnimating];
            
            //解散群组
            [[EaseMob sharedInstance].chatManager asyncDestroyGroup:_buddyName completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
                [activityView stopAnimating];
                if (!error) {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"您已成功解散群组" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            } onQueue:nil];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:doneAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        //退出该群
        UIAlertController* alert    = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定退出该群?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction* doneAction   = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //加载动画
            UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            activityView.hidesWhenStopped         = YES;
            [self.view addSubview:activityView];
            activityView.center = self.view.center;
            [self.view addSubview:activityView];
            [activityView startAnimating];
            
            //退群方法
            [[EaseMob sharedInstance].chatManager asyncLeaveGroup:_buddyName completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
                //停止加载动画
                [activityView stopAnimating];
                if (!error) {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"您已成功退出该群" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            } onQueue:nil];
        }];
        [alert addAction:cancelAction];
        [alert addAction:doneAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _titleArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = _group.groupId;
        cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 1) {
        EMGroupStyleSetting *groupSetting = _group.groupSetting;
        NSInteger groupMaxUsersCount = groupSetting.groupMaxUsersCount;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld / %ld",_group.groupOccupantsCount,groupMaxUsersCount];
    }
    else{
        cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//点击效果
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>1) {
        detailGroupViewController* vc = [detailGroupViewController new];
        vc.memberArr                  = _group.occupants;
        vc.num                        = indexPath.row;
        vc.buddyName                  = self.buddyName;
        vc.myGroup                    = _group;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    groupHeaderView* headerView = [[groupHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    headerView.memberArr = _group.occupants;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
