//
//  creatGroupViewController.m
//  talk2
//
//  Created by 刘森 on 16/5/26.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "creatGroupViewController.h"
#import "EaseMob.h"
#import "PinYin4Objc.h"
#import "groupTableViewController.h"

@interface creatGroupViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UISearchController      * searchController;
@property (nonatomic,strong) UITableView             * tableView;

@property (nonatomic,strong) NSMutableArray          * searchBuddyArr;
@property (nonatomic,strong) NSArray                 * letterArr;//首字母数组
@property (nonatomic,strong) NSMutableArray          * titleArr;//标题数组
@property (nonatomic,strong) NSMutableDictionary     * buddyDic;//拼音转换的因为字典
@property (nonatomic,strong) NSMutableArray          * selectArr;//选中的 buddy 名字数组
@property (nonatomic,strong) UIPickerView            * pickView;//选择群组类型
@property (nonatomic,strong) NSArray                 * groupTypeArr;//群组类型数组
@property (nonatomic,assign) NSInteger               pickNum;

@property (nonatomic,strong) UIActivityIndicatorView * activityView;

@end

@implementation creatGroupViewController

#pragma mark  - searchControllerDelegate 和 UISearchResultsUpdating
//改变输入之后 会回调的方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [_searchBuddyArr removeAllObjects];
    for (EMBuddy* buddy in _allBuddyArr) {
        if ([buddy.username rangeOfString:_searchController.searchBar.text].location != NSNotFound) {
            [_searchBuddyArr addObject:buddy];
        }
    }
    //刷新界面
    [_tableView reloadData];
}



- (void)readData{
    
    _pickNum        = 0;

    //初始化数组
    _searchBuddyArr = [NSMutableArray array];
    _selectArr      = [NSMutableArray array];//用来比对 cell 确定选没选中
    _groupTypeArr   = @[@"私有群组,群主邀请",@"私有群组,成员邀请",@"公共群组,群组验证",@"公共群组,任意加入"];
    //allBuddyArr 已由外部传入
    [self chineseToPinYin];
}

- (void)chineseToPinYin{
    _buddyDic = [NSMutableDictionary dictionary];
    for (char i = 'a'; i<='z'; i++) {
        NSString* str = [NSString stringWithFormat:@"%c",i];
        NSMutableArray* arr = [NSMutableArray array];
        [_buddyDic setObject:arr forKey:str];
    }
    for (EMBuddy* buddy in _allBuddyArr) {
        NSString* ChineseName = buddy.username;
        HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
        [outputFormat setToneType:ToneTypeWithoutTone];
        [outputFormat setVCharType:VCharTypeWithV];
        [outputFormat setCaseType:CaseTypeLowercase];
        NSString *EnglishName = [PinyinHelper toHanyuPinyinStringWithNSString:ChineseName withHanyuPinyinOutputFormat:outputFormat withNSString:@" "];
        
        //获取首字符
        NSString* ocChar = [EnglishName substringToIndex:1];
        [_buddyDic[ocChar] addObject:buddy];
    }
    //遍历字典,删除空数组
    [_buddyDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray* arr = (NSArray*)obj;
        if (arr.count == 0) {
            [_buddyDic removeObjectForKey:key];
        }
    }];
    NSArray* arr1 = [_buddyDic allKeys];
    //获得首字母数组
    _letterArr = [NSArray array];
    //排序
    _letterArr = [arr1 sortedArrayUsingSelector:@selector(compare:)];
    
}

#pragma mark --tableDelegate/DataSource
//侧边栏导航
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _letterArr;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_searchController.isActive) {
        return _searchBuddyArr.count;
    }else{
        if (_allBuddyArr.count!=0) {
            NSString* str = _letterArr[section];
            NSArray* arr = _buddyDic[str];
            return arr.count;
        }
    }
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_searchController.isActive) {
        return 1;
    }else{
        if (_buddyDic.count!=0) {
            return _buddyDic.count;
        }
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (_searchController.isActive) {
        EMBuddy* buddy = _searchBuddyArr[indexPath.row];
        cell.textLabel.text = buddy.username;
        if ([_selectArr containsObject:cell.textLabel.text]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else{
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }else{
        NSString* str = _letterArr[indexPath.section];
        EMBuddy* buddy = _buddyDic[str][indexPath.row];
        cell.textLabel.text = buddy.username;
        if ([_selectArr containsObject:cell.textLabel.text]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }else{
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    return cell;
}
//选中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchController.searchBar resignFirstResponder];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [_selectArr addObject:cell.textLabel.text];
    if (cell.selected) {
        NSLog(@"选中");
    }
}
////取消选中行
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [_selectArr removeObject:cell.textLabel.text];
    if (!cell.selected) {
        NSLog(@"取消选中");
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_searchController.isActive) {
        return @"查找结果";
    }else{
        NSString* str = _letterArr[section];
        return str;
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    //这里不用 _searchController.searchBar.active = NO; 是因为 退出活动状态的动画效果 会比 disapperar 慢,效果不理想
    _searchController.searchBar.hidden = YES;
    [_activityView stopAnimating];
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //出现的时候不在搜索状态
    _searchController.active = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readData];
    [self creatUI];
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.hidesWhenStopped         = YES;
    [self.view addSubview:_activityView];
    _activityView.center = self.view.center;
}

- (void)creatUI{
    
    self.title = @"创建群组";
    
    //右上方按键
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(click:)];
    
    //关闭自动布局
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView                                      = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.delegate                             = self;
    _tableView.dataSource                           = self;
    _tableView.separatorStyle                       = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight                            = 50;
    _tableView.allowsMultipleSelectionDuringEditing = YES;
    _tableView.editing                              = YES;
    //添加手势,收起键盘
//    UITapGestureRecognizer* tap                     = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
//    [_tableView addGestureRecognizer:tap];
    
    [self.view addSubview:_tableView];
    
    //创建searchController 关联 想要 结果呈现的VC
    //在当前的界面呈现
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    
    //在searchController上的searchBar的大小
    _searchController.searchBar.frame                      = CGRectMake(0, 0, self.view.frame.size.width-100, 40);
    _tableView.tableHeaderView                             = _searchController.searchBar;

    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.dimsBackgroundDuringPresentation     = NO;
    //代理 searchController的代理
    _searchController.searchResultsUpdater                 = self;
}

//#pragma mark -- tap 手势
//-(IBAction)tap:(UITapGestureRecognizer*)tap{
//    [self.view endEditing:YES];
//    
//    
//}

#pragma mark -- pickView delegate/dataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 4;//4个枚举值 type
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 270;
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSAttributedString* str = [[NSAttributedString alloc] initWithString:_groupTypeArr[row] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    //这里并没有改变 字体 可以换回返回 nsstring 的方法
    return str;
}

//选中触发方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _pickNum = row;
}

- (IBAction)click:(UIBarButtonItem*)btn{
    
    [_searchController.searchBar resignFirstResponder];
    
    //从选中的 indexPath 获得 buddy
    NSMutableArray* selectBuddyArr = [NSMutableArray array];
    NSArray* arr = [_tableView indexPathsForSelectedRows];
    EMBuddy* buddy = [EMBuddy new];
    for (NSIndexPath* indexPath in arr) {
        if (_searchController.isActive) {
            buddy = _searchBuddyArr[indexPath.row];
        }else{
            NSString* str = _letterArr[indexPath.section];
            buddy = _buddyDic[str][indexPath.row];
        }
        [selectBuddyArr addObject:buddy.username];
    }
    
    
    //pickView
    _pickView            = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 265, 4*40)];
    _pickView.delegate   = self;
    _pickView.dataSource = self;
    [self.view addSubview:_pickView];
    //滑动到第一项
    [_pickView selectRow:0 inComponent:0 animated:YES];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"创建群组\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction* doneAct   = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self creatGroupWithName:alert.textFields[0].text andDescription:alert.textFields[1].text andSelectBuddyArr:selectBuddyArr];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"群主题";
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"群描述";
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];

    [alert addAction:cancelAct];
    [alert addAction:doneAct];
    //添加_ pickerView
    [alert.view addSubview:_pickView];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}
//创建群组
- (void)creatGroupWithName:(NSString*)name andDescription:(NSString*)description andSelectBuddyArr:(NSArray*)selectBuddyArr{
    name        = (name.length == 0 ? @"群":name);
    description = (description.length == 0 ? @"一起玩耍":description);
    NSLog(@"%@,%@,%@,%ld",name,description,selectBuddyArr,_pickNum);
    
#if 1
    //显示加载动画
    [_activityView startAnimating];
    
    EMGroupStyleSetting *groupStyleSetting = [[EMGroupStyleSetting alloc] init];
    groupStyleSetting.groupMaxUsersCount   = 500;
    groupStyleSetting.groupStyle           = _pickNum;
    [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:name description:description invitees:selectBuddyArr initialWelcomeMessage:@"邀请您加入群" styleSetting:groupStyleSetting completion:^(EMGroup *group, EMError *error) {
        //停止加载动画
        [_activityView stopAnimating];
        if (!error) {
            groupTableViewController* groupTVC = [groupTableViewController new];
            groupTVC = self.navigationController.viewControllers[1];
            [groupTVC.groupArr addObject:group];
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"创建成功");
        }else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"创建失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } onQueue:nil];
#endif
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
