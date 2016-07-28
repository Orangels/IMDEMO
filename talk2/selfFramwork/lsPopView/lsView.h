//
//  lsView.h
//  pop_test
//
//  Created by 刘森 on 16/5/25.
//  Copyright © 2016年 tuhui－03. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,lsArrowDirection){
    
    //箭头位置
    
    lsArrowDirectionLeft1=1,//左上
    lsArrowDirectionLeft2,//左中
    lsArrowDirectionLeft3,//左下
    lsArrowDirectionRight1,//右上
    lsArrowDirectionRight2,//右中
    lsArrowDirectionRight3,//右下
    lsArrowDirectionUp1,//上左
    lsArrowDirectionUp2,//上中
    lsArrowDirectionUp3,//上右
    lsArrowDirectionDown1,//下左
    lsArrowDirectionDown2,//下中
    lsArrowDirectionDown3,//下右
    
};


@interface lsView : UIView
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat starX;
@property (nonatomic, assign) CGFloat startY;
-(instancetype)initWithOrigin:(CGPoint)origin Width:(CGFloat)width Height:(float)height Direction:(lsArrowDirection)direction;//初始化

-(void)popView;//弹出视图
-(void)dismiss;//隐藏视图
@end
