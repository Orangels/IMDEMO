//
//  imageTableViewCell.m
//  talk2
//
//  Created by 刘森 on 16/5/31.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "imageTableViewCell.h"
#define WITH [UIScreen mainScreen].bounds.size.width
@interface imageTableViewCell ()
@property (nonatomic,strong) UIImageView    * chatImageView;
@property (nonatomic,strong) UILabel        * nameLabel;
@property (nonatomic,strong) UIImage        * litImage;
@property (nonatomic,strong) UIImage        * bigImage;

@property (nonatomic,strong) UIImageView    * playView;
@end

@implementation imageTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
    }
    return self;
}


//视频
- (void)showVideoImage:(NSString*)videoImage andFrom:(BOOL)isLeft andName:(NSString*)name andVideoPath:(NSString*)videoPath{
    
    if (!videoImage) {
        _litImage = [UIImage imageNamed:@"play_64px_1194511_easyicon.net"];
    }else{
        _litImage = [UIImage imageWithContentsOfFile:videoImage];
    }
    //多加一条判断 判断 image 是否加载成功
    if (!_litImage) {
        _litImage = [UIImage imageNamed:@"play_64px_1194511_easyicon.net"];
        videoImage = nil;
    }
    CGRect nameRect           = [name boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    if (isLeft) {
        //放在左边
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, nameRect.size.width, nameRect.size.height)];
        _nameLabel.text = name;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _chatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, nameRect.size.height, 80, 80)];
        _chatImageView.image = _litImage;
        
        //下载进度条
        _progress = [[videoProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progress.frame = CGRectMake(10, nameRect.size.height+80+4, 80, 2);
        [self.contentView addSubview:_progress];
        
    }else{
        //放在右边
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(WITH-nameRect.size.width, 0, nameRect.size.width, nameRect.size.height)];
        _nameLabel.text = name;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _chatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WITH-80-10, nameRect.size.height, 80, 80)];
        _chatImageView.image = _litImage;
        
        //下载进度条
        _progress = [[videoProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progress.frame = CGRectMake(WITH-80-10, nameRect.size.height+80+4, 80, 2);
        [self.contentView addSubview:_progress];
    }
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_chatImageView];
    
    //判断视频是否存在 显示 progress
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:videoPath]) {
        _progress.progress = 0.0;
    }else{
        _progress.progress = 0.5;
        [_progress setProgress:1 animated:YES];
    }
    
    //播放图标
    if (videoImage) {
        _playView        = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _playView.image  = [UIImage imageNamed:@"play_64px_1194511_easyicon.net"];
        _playView.center = CGPointMake(40, 40);
        [_chatImageView addSubview:_playView];
    }
    
    
    _chatImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    //添加手势
    [_chatImageView addGestureRecognizer:tap];
    
}

//图片
- (void)showlitImage:(NSString*)litImage andBigImage:(NSString*)bigImage andFrom:(BOOL)isLeft andName:(NSString*)name{
    
    //初始化 image
    _bigImage = [UIImage imageWithContentsOfFile:bigImage];
    _litImage = [UIImage imageWithContentsOfFile:litImage];
    
    
    CGRect nameRect           = [name boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    if (isLeft) {
        //放在左边
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, nameRect.size.width, nameRect.size.height)];
        _nameLabel.text = name;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _chatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, nameRect.size.height, 80, 80)];
        _chatImageView.image = _litImage;
        
        
    }else{
        //放在右边
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(WITH-nameRect.size.width, 0, nameRect.size.width, nameRect.size.height)];
        _nameLabel.text = name;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _chatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WITH-80-10, nameRect.size.height, 80, 80)];
        _chatImageView.image = _litImage;
    }
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_chatImageView];
    
    _chatImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    //添加手势
    [_chatImageView addGestureRecognizer:tap];
    
}

-(IBAction)tap:(UITapGestureRecognizer*)tap{
    _block(_bigImage);
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
