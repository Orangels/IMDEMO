//
//  loadViewController.m
//  talk2
//
//  Created by 刘森 on 16/5/23.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "loadViewController.h"
#import <EaseMobSDKFull/EaseMob.h>
#import "ViewController.h"
#import "buddyTableViewController.h"
#import "lsCollectionReusableView.h"
#import "lsCollectionViewCell.h"


@interface loadViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic) UIButton         * pageBtn;
@property (strong,nonatomic) UILabel          * pageLabel;
@property (strong,nonatomic) UILabel          * name;
@property (strong,nonatomic) UILabel          * nickLabel;
@property (strong,nonatomic) UITextField      * nickname;
@property (strong,nonatomic) UIButton         * editBtn;
@property (strong,nonatomic) UIButton         * changePageBtn;
@property (strong,nonatomic) UIButton         * exitBtn;
@property (strong,nonatomic) UICollectionView * collectionView;
@property (strong,nonatomic) NSMutableArray   * boyarr;
@property (strong,nonatomic) NSMutableArray   * girlarr;
@property (strong,nonatomic) NSString         * tmpImage;

@end

@implementation loadViewController

#pragma mark -- UI界面搭建
- (void)creatUI{
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:246/255.0 green:247/255.0 blue:239/255.0 alpha:1];
    _pageBtn                                = [[UIButton alloc] initWithFrame:CGRectMake(20, 80, 100, 100)];
    _pageBtn.layer.cornerRadius             = 50;
    _pageBtn.clipsToBounds                  = YES;
    [_pageBtn setImage:[UIImage imageNamed:_person.iconName] forState:UIControlStateNormal];
    _pageBtn.userInteractionEnabled         = NO;
    [self.view addSubview:_pageBtn];
    //初始化_ tmpImage
    _tmpImage                               = _person.iconName;

    _pageLabel                              = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    _pageLabel.center                       = CGPointMake(_pageBtn.center.x, _pageBtn.center.y+70);
    _pageLabel.textAlignment                = NSTextAlignmentCenter;
    _pageLabel.text                         = @"头像";
    [self.view addSubview:_pageLabel];

    _name                                   = [[UILabel alloc] initWithFrame:CGRectMake(130, _pageBtn.center.y-30, 150, 20)];

    _name.text                              = [NSString stringWithFormat:@"用户名:%@",_person.name];
    [self.view addSubview:_name];

    _nickname                               = [[UITextField alloc] initWithFrame:CGRectMake(130, _pageBtn.center.y+30, 170, 20)];
    UILabel* leftlabel                      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    leftlabel.text                          = @"昵    称:";
    [leftlabel sizeToFit];
    _nickname.leftView                      = leftlabel;
    _nickname.leftViewMode                  = UITextFieldViewModeAlways;
    _nickname.text                          = _person.nickname;
    _nickname.text                          = _person.nickname;
    //    NSLog(@"%@",_person);
    _nickname.enabled                       = NO;
    [self.view addSubview:_nickname];

    _editBtn                                = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame                          = CGRectMake(self.view.frame.size.width-100, _nickname.frame.origin.y, 60, 20);
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitle:@"确定" forState:UIControlStateSelected];
    _editBtn.backgroundColor                = [UIColor greenColor];
    _editBtn.layer.cornerRadius             = 10;
    [_editBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editBtn];

    //退出
    _exitBtn                                = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    _exitBtn.center                         = self.view.center;
    _exitBtn.backgroundColor                = [UIColor redColor];
    _exitBtn.layer.cornerRadius             = 10;
    _exitBtn.clipsToBounds                  = YES;
    _exitBtn.titleLabel.textAlignment       = NSTextAlignmentCenter;
    [_exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    [_exitBtn addTarget:self action:@selector(exitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_exitBtn];

    _changePageBtn                          = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    _changePageBtn.center                   = CGPointMake(_exitBtn.center.x, _exitBtn.center.y-40);
    _changePageBtn.backgroundColor          = [UIColor blueColor];
    _changePageBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _changePageBtn.layer.cornerRadius       = 10;
    _changePageBtn.clipsToBounds            = YES;
    [_changePageBtn setTitle:@"修改头像" forState:UIControlStateNormal];
    [_changePageBtn setTitle:@"确定" forState:UIControlStateSelected];
    [_changePageBtn addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changePageBtn];
    
    [self creatCollectionView];
    
}
-(void)creatCollectionView{
    [self readData];
    UICollectionViewFlowLayout* flow = [UICollectionViewFlowLayout new];
    flow.minimumLineSpacing          = 10;
    flow.minimumInteritemSpacing     = 2;
    flow.itemSize                    = CGSizeMake(80, 100);
    flow.scrollDirection             = UICollectionViewScrollDirectionVertical;
    //header 40  footer 20
    _collectionView                  = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260) collectionViewLayout:flow];
    _collectionView.delegate         = self;
    _collectionView.dataSource       = self;
    _collectionView.bounces          = NO;

    [_collectionView registerClass:[lsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[lsCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self.view addSubview:_collectionView];
}
- (void)readData{
    _boyarr = [NSMutableArray array];
    _girlarr = [NSMutableArray array];
    _boyarr = [NSMutableArray arrayWithContentsOfFile:BOY];
    _girlarr = [NSMutableArray arrayWithContentsOfFile:GIRL];
    
}
#pragma mark -- flowdelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 40);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 20);
}

#pragma mark dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section) {
        return _boyarr.count;
    }
    return _girlarr.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //header
    lsCollectionReusableView* header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    //footer
    UICollectionReusableView* footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            header.backgroundColor = [UIColor greenColor];
            header.lab.text = @"girl";
            [header.lab sizeToFit];
            return header;
        }else{
            footer.backgroundColor = [UIColor greenColor];
            return footer;
        }
    }
    else{
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            header.backgroundColor = [UIColor orangeColor];
            header.lab.text = @"boy";
            [header.lab sizeToFit];
            return header;
        }else{
            footer.backgroundColor = [UIColor orangeColor];
            return footer;
        }
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    lsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell setmyImage:_girlarr[indexPath.row][@"imageName"]];
    }else{
        [cell setmyImage:_boyarr[indexPath.row][@"imageName"]];
    }
    cell.block = ^(NSString* str){
        [_pageBtn setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
        _tmpImage = str;
    };
    return cell;
}
#pragma mark -- 退出登录
-(IBAction)exitBtn:(UIButton*)btn{
    //退出登录
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            NSLog(@"退出成功");
            NSLog(@"%@",info);
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ViewController* vc = [story instantiateViewControllerWithIdentifier:@"ViewController"];
            
            //            UINavigationController* nav = self.navigationController.tabBarController.viewControllers[2];
            //            buddyTableViewController* btvc = nav.viewControllers[0];
            //            [btvc dataRefresh];
            
            self.view.window.rootViewController = vc;
        }
    } onQueue:nil];
    
}

#pragma mark -- 修改头像 并保存本地
-(IBAction)changePage:(UIButton*)sender{
    //_tmpImage 在创建头像的时候 初始化
    //收起键盘
    [self.view endEditing:YES];
    
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [UIView animateWithDuration:1.5 animations:^{
            _collectionView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
            NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithContentsOfFile:USERPAH];
            
            NSLog(@"%@",USERPAH);
            
            self.tabBarController.tabBar.hidden = NO;
            _person.iconName = _tmpImage;
            NSDictionary* dicper = [_person toDictionary];
            [dic setObject:dicper forKey:_person.name];
            [dic writeToFile:USERPAH atomically:YES];
        }];
    }else{//collection 上升
        [UIView animateWithDuration:1.5 animations:^{
            _collectionView.contentOffset = CGPointMake(0, 0);
            _collectionView.frame = CGRectMake(0, self.view.frame.size.height-260, self.view.frame.size.width, 260);
            self.tabBarController.tabBar.hidden = YES;
        }];
    }
}
//touch 方法,相当于取消
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //collection 返回下面
    [UIView animateWithDuration:1.5 animations:^{
        _collectionView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
    }];
    _nickname.text = _person.nickname;
    [_pageBtn setImage:[UIImage imageNamed:_person.iconName] forState:UIControlStateNormal];
    if (_editBtn.selected) {
        _editBtn.selected = NO;
        _nickname.enabled = NO;
        _nickname.borderStyle = UITextBorderStyleNone;
        [_nickname resignFirstResponder];
    }
    if (_changePageBtn.selected) {
        _changePageBtn.selected = NO;
        self.tabBarController.tabBar.hidden = NO;
    }
}
//修改 昵称 保存本地
-(IBAction)edit:(UIButton*)sender{
    sender.selected = !sender.selected;
    _nickname.enabled = !_nickname.enabled;
    if (sender.selected) {
        _nickname.borderStyle = UITextBorderStyleRoundedRect;
        [_nickname becomeFirstResponder];
    }
    if (!sender.selected){
        _nickname.borderStyle = UITextBorderStyleNone;
        _person.nickname = _nickname.text;
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithContentsOfFile:USERPAH];
        NSDictionary* dicper = [_person toDictionary];
        [dic setObject:dicper forKey:_person.name];
        [dic writeToFile:USERPAH atomically:YES];
    }
}





#pragma mark -- viewdidLoad
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //为了得到 person 以后再建立 UI, 这里外漏 creatUI 方法,有外部控制 creatUI
    if (_person) {
        [self creatUI];
    }
//    [self creatLogoffButton];
    NSLog(@"%@",USERPAH);
}

//- (void)creatLogoffButton{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(click:)];
//    
//}

-(IBAction)click:(UIBarButtonItem*)btn{
    //退出登录
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            NSLog(@"退出成功");
            NSLog(@"%@",info);
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ViewController* vc = [story instantiateViewControllerWithIdentifier:@"ViewController"];
            
//            UINavigationController* nav = self.navigationController.tabBarController.viewControllers[2];
//            buddyTableViewController* btvc = nav.viewControllers[0];
//            [btvc dataRefresh];
    
            self.view.window.rootViewController = vc;
        }
    } onQueue:nil];
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
