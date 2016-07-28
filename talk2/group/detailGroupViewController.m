//
//  detailGroupViewController.m
//  talk2
//
//  Created by 刘森 on 16/6/4.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "detailGroupViewController.h"
#import "groupMemberCollectionViewCell.h"

@interface detailGroupViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UICollectionView * cv;
@property (nonatomic,strong) UITextField      * textField;
@end

@implementation detailGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    switch (_num) {
        case 1:
            [self creatCollectionView];
            break;
        case 2:
            [self showGroupSetting];
            break;
        case 3:
            [self changeGroupName];
            break;
        default:
            break;
    }
}

- (void)creatCollectionView{
    UICollectionViewFlowLayout* flow = [UICollectionViewFlowLayout new];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumInteritemSpacing = 30;
    flow.minimumLineSpacing = 30;
    flow.itemSize = CGSizeMake(50, 70);
    _cv = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flow];
    _cv.delegate = self;
    _cv.dataSource = self;
    _cv.backgroundColor = [UIColor whiteColor];
    [_cv registerClass:[groupMemberCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_cv];
    NSLog(@"%@",_memberArr);
}
- (void)showGroupSetting{
    //更改群设置界面
    UISwitch* mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 51, 31)];
    mySwitch.center = CGPointMake([UIScreen mainScreen].bounds.size.width-150, 100);
    
    mySwitch.on = _myGroup.isBlocked;
    
    [mySwitch addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mySwitch];
    
    //label
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 31)];
    label.center = CGPointMake(mySwitch.center.x-150, mySwitch.center.y);
    label.text = @"屏蔽群消息";
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    [self.view addSubview:label];
}

#warning 屏蔽消息的设置改变之后 要在聊天界面重新获得 conversation  不然又写设置不会生效,环信很多的设置改变后,都要重新获得相应的数据才会使设置生效

//屏蔽群消息
-(IBAction)changeValue:(UISwitch*)mySwitch{
    //加载动画
    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityView.hidesWhenStopped         = YES;
    [self.view addSubview:activityView];
    activityView.center = self.view.center;
    [activityView startAnimating];
    if (!mySwitch.on) {
        //取消屏蔽群消息
        [[EaseMob sharedInstance].chatManager asyncUnblockGroup:_buddyName completion:^(EMGroup *group, EMError *error) {
            //停止动画
            [activityView stopAnimating];
            //错误
            if (error != nil) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        } onQueue:nil];
    }else{
        //屏蔽群消息
        
        [[EaseMob sharedInstance].chatManager asyncBlockGroup:_buddyName completion:^(EMGroup *group, EMError *error) {
            //停止动画
            [activityView stopAnimating];
            //错误
            if (error != nil) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        } onQueue:nil];
        
    }
}

- (void)changeGroupName{
    //创建 textField
    _textField                               = [[UITextField alloc] initWithFrame:CGRectMake(50, 50+64, self.view.frame.size.width-100, 50)];
    _textField.delegate                      = self;
    _textField.placeholder                   = @"群名称";
    _textField.borderStyle                   = UITextBorderStyleRoundedRect;
    _textField.enablesReturnKeyAutomatically = YES;
    [self.view addSubview:_textField];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveGroupName:)];
}

- (IBAction)saveGroupName:(UIBarButtonItem*)btn{
    //加载动画
    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityView.hidesWhenStopped         = YES;
    [self.view addSubview:activityView];
    activityView.center = self.view.center;
    [activityView startAnimating];
    if ([_textField.text isEqualToString:@""]) {
        [activityView stopAnimating];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        EMError *error = nil;
        // 修改群名称
        [[EaseMob sharedInstance].chatManager asyncChangeGroupSubject:_textField.text forGroup:self.buddyName completion:^(EMGroup *group, EMError *error) {
            if (!error) {
                //停止动画
                [activityView stopAnimating];
                [self.navigationController popViewControllerAnimated:YES];
                NSLog(@"修改成功");
            }else{
                //停止动画
                [activityView stopAnimating];
                NSLog(@"%@",error);
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
#warning 这里总是提示没有权限,当前用户创建完群组后可以改名,退出再登陆后操作会提示没有权限,
                
            }
        } onQueue:nil];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text != 0) {
        _textField.enablesReturnKeyAutomatically = NO;
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_textField.text.length != 0) {
        [self.view endEditing:YES];
        return YES;
    }
    return NO;
}

#pragma mark -- collection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _memberArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    groupMemberCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell showTheCellWithName:_memberArr[indexPath.row]];
    return cell;
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
