//
//  talkTableViewCell.m
//  talk2
//
//  Created by 刘森 on 16/5/24.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "talkTableViewCell.h"
#define WITH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define CELLWITH 200
@implementation talkTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //统一宽度为 CELLWITH
        _leftView               = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELLWITH, self.bounds.size.height)];
        _rightView              = [[UIImageView alloc] initWithFrame:CGRectMake(WITH-CELLWITH, 0, CELLWITH, self.bounds.size.height)];
        UIImage* leftImagetmp   = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
        UIImage* rightImagetmp  = [UIImage imageNamed:@"SenderTextNodeBkg"];

        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(leftImagetmp.size.height/2, leftImagetmp.size.width/2, leftImagetmp.size.height/2, leftImagetmp.size.width/2);
        UIImage* leftImage      = [leftImagetmp resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
        UIImage* rightImage     = [rightImagetmp resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeTile];
        _leftView.image         = leftImage;
        _rightView.image        = rightImage;
        
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CELLWITH, self.bounds.size.height)];
        _leftLabel.text = @"left";
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, CELLWITH, self.bounds.size.height)];
        _rightLabel.text = @"right";
        
        [_leftView addSubview:_leftLabel];
        [_rightView addSubview:_rightLabel];
        
        [self addSubview:_leftView];
        [self addSubview:_rightView];
        
        //namelabel
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:_nameLabel];
        //midlabel
        _midLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:_midLabel];
        
        
        _leftView.userInteractionEnabled = YES;
        _rightView.userInteractionEnabled = YES;
        //添加 tap 手势
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.leftView addGestureRecognizer:tap];
        [self.rightView addGestureRecognizer:tap1];
    }
    return self;
}

-(IBAction)tap:(UITapGestureRecognizer*)tap{
    _block();
}

- (CGFloat)getLeftStr:(NSString*)left andRightStr:(NSString*)right andTime:(NSString*)time andName:(NSString*)name{
    _leftLabel.lineBreakMode  = NSLineBreakByWordWrapping;
    _leftLabel.text           = left;
    _leftLabel.numberOfLines = 0;
    _leftLabel.font = [UIFont systemFontOfSize:15];
    [_leftLabel sizeToFit];
    
    _rightLabel.lineBreakMode  = NSLineBreakByWordWrapping;
    _rightLabel.text           = right;
    _rightLabel.numberOfLines = 0;
    _rightLabel.font = [UIFont systemFontOfSize:15];
    [_rightLabel sizeToFit];
    
    CGRect leftRect           = [left boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];

    CGRect rightRect          = [right boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    CGRect nameRect           = [name boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];

    //重新布局
    _leftView.frame           = CGRectMake(0, nameRect.size.height, leftRect.size.width+30, leftRect.size.height+20);
    _rightView.frame          = CGRectMake(WITH-rightRect.size.width-30, nameRect.size.height, rightRect.size.width+30, rightRect.size.height+20);

    _leftLabel.frame          = CGRectMake(20, 0, leftRect.size.width, leftRect.size.height);
    _rightLabel.frame         = CGRectMake(10, 0, rightRect.size.width, rightRect.size.height);
    

    if (_leftView.frame.size.width>_rightView.frame.size.width) {
        _midLabel.frame = CGRectMake(_leftView.frame.size.width, nameRect.size.height, 60, _leftView.frame.size.height);
    }else{
        _midLabel.frame = CGRectMake(_rightView.frame.origin.x-25, nameRect.size.height, 20, _rightView.frame.size.height);
    }
    
    if (_leftView.hidden == YES) {
        //放在右边
        _nameLabel.frame = CGRectMake(WITH-nameRect.size.width, 0, nameRect.size.width, nameRect.size.height);
        _nameLabel.text = name;
        _nameLabel.font = [UIFont systemFontOfSize:12];
    }else{
        //放在左边
        _nameLabel.frame = CGRectMake(0, 0, nameRect.size.width, nameRect.size.height);
        _nameLabel.text = name;
        _nameLabel.font = [UIFont systemFontOfSize:12];
    }
//    [self addSubview:_nameLabel];
    
    _midLabel.text = time;
//    [self addSubview:_midLabel];
    
    UIImage* leftImagetmp   = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
    UIImage* rightImagetmp  = [UIImage imageNamed:@"SenderTextNodeBkg"];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(leftImagetmp.size.height/2, leftImagetmp.size.width/2, leftImagetmp.size.height/2, leftImagetmp.size.width/2);
    UIImage* leftImage      = [leftImagetmp resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    UIImage* rightImage     = [rightImagetmp resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeTile];
    _leftView.image         = leftImage;
    _rightView.image        = rightImage;
    
    
    return (_leftView.frame.size.height > _rightView.frame.size.height ? _leftView.frame.size.height+nameRect.size.height:_rightView.frame.size.height+nameRect.size.height);
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
