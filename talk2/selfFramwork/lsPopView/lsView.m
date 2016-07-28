//
//  lsView.m
//  pop_test
//
//  Created by 刘森 on 16/5/25.
//  Copyright © 2016年 tuhui－03. All rights reserved.
//

#import "lsView.h"
#define DURATION 0.2
@interface lsView ()

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) lsArrowDirection direction;
@end


@implementation lsView
-(instancetype)initWithOrigin:(CGPoint)origin Width:(CGFloat)width Height:(float)height Direction:(lsArrowDirection)direction{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        //透明色
        self.backgroundColor = [UIColor clearColor];
        
        //定义显示视图的参数
        self.origin    = origin;
        self.height    = height;
        self.width     = width;
        self.direction = direction;
        self.starX     = origin.x;
        self.startY    = origin.y;
        
        self.backView=[[UIView alloc]initWithFrame:CGRectMake(_starX, _startY, width, height)];
        self.backView.backgroundColor=[UIColor colorWithWhite:0.2 alpha:1];
        self.backView.layer.cornerRadius = 10;
        [self addSubview:self.backView];
        
    }
    return self;
}


#if 1
- (void)popView{
    //重新加载
    
    [self setNeedsDisplay];
    
    NSArray* arr = self.backView.subviews;
    for (UIView* subView in arr) {
        subView.hidden = YES;
    }
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.alpha = 0;
    
    switch (_direction) {
        case lsArrowDirectionLeft1: {
            self.backView.frame = CGRectMake(_starX, _startY, 0, 0);
            [UIView animateWithDuration:DURATION animations:^{
                self.alpha = 1;
                self.backView.frame = CGRectMake(_starX+5, _startY-20, _width, _height);
            } completion:^(BOOL finished) {
                for (UIView* subView in arr) {
                    subView.hidden = NO;
                }
            }];
            break;
        }
        case lsArrowDirectionLeft2: {
            self.backView.frame = CGRectMake(_starX, _startY, 0, 0);
            [UIView animateWithDuration:DURATION animations:^{
                self.alpha = 1;
                self.backView.frame = CGRectMake(_starX+5, _startY-_height/2, _width, _height);
            } completion:^(BOOL finished) {
                for (UIView* subView in arr) {
                    subView.hidden = NO;
                }
            }];
            break;
        }
        case lsArrowDirectionLeft3: {
            self.backView.frame = CGRectMake(_starX, _startY, 0, 0);
            [UIView animateWithDuration:DURATION animations:^{
                self.alpha = 1;
                self.backView.frame = CGRectMake(_starX+5, _startY-20-_height, _width, _height);
            } completion:^(BOOL finished) {
                for (UIView* subView in arr) {
                    subView.hidden = NO;
                }
            }];
            break;
        }
        case lsArrowDirectionRight1: {
            self.backView.frame = CGRectMake(_starX, _startY, 0, 0);
            [UIView animateWithDuration:DURATION animations:^{
                self.alpha = 1;
                self.backView.frame = CGRectMake(_starX-5, _startY-20, _width, _height);
            } completion:^(BOOL finished) {
                for (UIView* subView in arr) {
                    subView.hidden = NO;
                }
            }];
            break;
        }
        case lsArrowDirectionRight2: {
            self.backView.frame = CGRectMake(_starX, _startY, 0, 0);
            [UIView animateWithDuration:DURATION animations:^{
                self.alpha = 1;
                self.backView.frame = CGRectMake(_starX-5, _startY-_height/2, _width, _height);
            } completion:^(BOOL finished) {
                for (UIView* subView in arr) {
                    subView.hidden = NO;
                }
            }];
            break;
        }
        case lsArrowDirectionRight3: {
            self.backView.frame = CGRectMake(_starX, _startY, 0, 0);
            [UIView animateWithDuration:DURATION animations:^{
                self.alpha = 1;
                self.backView.frame = CGRectMake(_starX-5, _startY+20-_width, _width, _height);
            } completion:^(BOOL finished) {
                for (UIView* subView in arr) {
                    subView.hidden = NO;
                }
            }];
            break;
        }
        case lsArrowDirectionUp1: {
            self.backView.frame = CGRectMake(_starX, _startY, 0, 0);
            [UIView animateWithDuration:DURATION animations:^{
                self.alpha = 1;
                self.backView.frame = CGRectMake(_starX-20, _startY+5, _width, _height);
            } completion:^(BOOL finished) {
                for (UIView* subView in arr) {
                    subView.hidden = NO;
                }
            }];
            break;
        }
        case lsArrowDirectionUp2: {
            self.backView.frame = CGRectMake(_starX, _startY, 0, 0);
            [UIView animateWithDuration:DURATION animations:^{
                self.alpha = 1;
                self.backView.frame = CGRectMake(_starX-_width/2, _startY+5, _width, _height);
            } completion:^(BOOL finished) {
                for (UIView* subView in arr) {
                    subView.hidden = NO;
                }
            }];
            break;
        }
        case lsArrowDirectionUp3: {
            self.backView.frame = CGRectMake(_starX, _startY, 0, 0);
            [UIView animateWithDuration:DURATION animations:^{
                self.alpha = 1;
                self.backView.frame = CGRectMake(_starX+20-_width, _startY+5, _width, _height);
            } completion:^(BOOL finished) {
                for (UIView* subView in arr) {
                    subView.hidden = NO;
                }
            }];
            break;
        }
        case lsArrowDirectionDown1: {
            self.backView.frame = CGRectMake(_starX, _startY, 0, 0);
            [UIView animateWithDuration:DURATION animations:^{
                self.alpha = 1;
                self.backView.frame = CGRectMake(_starX-20, _startY-5-_height, _width, _height);
            } completion:^(BOOL finished) {
                for (UIView* subView in arr) {
                    subView.hidden = NO;
                }
            }];
            break;
        }
        case lsArrowDirectionDown2: {
            self.backView.frame = CGRectMake(_starX, _startY, 0, 0);
            [UIView animateWithDuration:DURATION animations:^{
                self.alpha = 1;
                self.backView.frame = CGRectMake(_starX-_width/2, _startY-5-_height, _width, _height);
            } completion:^(BOOL finished) {
                for (UIView* subView in arr) {
                    subView.hidden = NO;
                }
            }];
            break;
        }
        case lsArrowDirectionDown3: {
            self.backView.frame = CGRectMake(_starX, _startY, 0, 0);
            [UIView animateWithDuration:DURATION animations:^{
                self.alpha = 1;
                self.backView.frame = CGRectMake(_starX+20-_width, _startY-5-_height, _width, _height);
            } completion:^(BOOL finished) {
                for (UIView* subView in arr) {
                    subView.hidden = NO;
                }
            }];
            break;
        }
    }
}
#endif
- (void)dismiss{
    //这里 self.backView的子视图不移除,创建 self.backVier 的子视图的时候 要在 creatUI 里创建,不要重复创建
    
    NSArray* arr = self.backView.subviews;
    for (UIView* subView in arr) {
        subView.hidden = YES;
    }
    
    //动画效果淡出
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        // 这里用 是为了效果看起来像在触发点生成的一样 _starX,_startY
        self.backView.frame = CGRectMake(_starX, _startY, 0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            
        }
    }];
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //获取上下文(画布)
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置画笔的粗细
    CGContextSetLineWidth(context, 2);
    //设置起点
    CGContextMoveToPoint(context, _starX, _startY);
    
    switch (_direction) {

        case lsArrowDirectionLeft1: {
            CGContextAddLineToPoint(context, _starX+5, _startY-5);
            CGContextAddLineToPoint(context, _starX+5, _startY+5);
            break;
        }
        case lsArrowDirectionLeft2: {
            CGContextAddLineToPoint(context, _starX+5, _startY-5);
            CGContextAddLineToPoint(context, _starX+5, _startY+5);
            
            break;
        }
        case lsArrowDirectionLeft3: {
            CGContextAddLineToPoint(context, _starX+5, _startY-5);
            CGContextAddLineToPoint(context, _starX+5, _startY+5);
            
            break;
        }
        case lsArrowDirectionRight1: {
            CGContextAddLineToPoint(context, _starX-5, _startY-5);
            CGContextAddLineToPoint(context, _starX-5, _startY+5);
            
            break;
        }
        case lsArrowDirectionRight2: {
            CGContextAddLineToPoint(context, _starX-5, _startY-5);
            CGContextAddLineToPoint(context, _starX-5, _startY+5);
            
            break;
        }
        case lsArrowDirectionRight3: {
            CGContextAddLineToPoint(context, _starX-5, _startY-5);
            CGContextAddLineToPoint(context, _starX-5, _startY+5);
            
            break;
        }
        case lsArrowDirectionUp1: {
            CGContextAddLineToPoint(context, _starX-5, _startY+5);
            CGContextAddLineToPoint(context, _starX+5, _startY+5);
            
            break;
        }
        case lsArrowDirectionUp2: {
            CGContextAddLineToPoint(context, _starX-5, _startY+5);
            CGContextAddLineToPoint(context, _starX+5, _startY+5);
            
            break;
        }
        case lsArrowDirectionUp3: {
            CGContextAddLineToPoint(context, _starX-5, _startY+5);
            CGContextAddLineToPoint(context, _starX+5, _startY+5);
            
            break;
        }
        case lsArrowDirectionDown1: {
            CGContextAddLineToPoint(context, _starX-5, _startY-5);
            CGContextAddLineToPoint(context, _starX+5, _startY-5);
            
            break;
        }
        case lsArrowDirectionDown2: {
            CGContextAddLineToPoint(context, _starX-5, _startY-5);
            CGContextAddLineToPoint(context, _starX+5, _startY-5);
            
            break;
        }
        case lsArrowDirectionDown3: {
            CGContextAddLineToPoint(context, _starX-5, _startY-5);
            CGContextAddLineToPoint(context, _starX+5, _startY-5);
            
            break;
        }
    }

    CGContextClosePath(context);
    [self.backView.backgroundColor setFill];//填充颜色
    [self.backgroundColor setStroke];//画笔颜色
    CGContextDrawPath(context, kCGPathFillStroke);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    if (touch.view != self.backView) {
        [self dismiss];
    }
}

@end
































