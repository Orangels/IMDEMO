//
//  talkTableViewCell.h
//  talk2
//
//  Created by 刘森 on 16/5/24.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^myblock)();
@interface talkTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *rightView;
@property (nonatomic,strong) UIImageView *leftView;
@property (nonatomic,strong) UILabel     * leftLabel;
@property (nonatomic,strong) UILabel     * rightLabel;
@property (nonatomic,strong) UILabel     * midLabel;
@property (nonatomic,strong) UILabel     * nameLabel;
@property (nonatomic,copy) myblock block;

- (CGFloat)getLeftStr:(NSString*)left andRightStr:(NSString*)right andTime:(NSString*)time andName:(NSString*)name;

@end
