//
//  LYMessageModelCell.m
//  GuanruAppDemo
//
//  Created by 刘园 on 2018/1/11.
//  Copyright © 2018年 guanrukeji. All rights reserved.
//

#import "LYMessageModelCell.h"
// Controllers

// Models
#import "LYMessageModel.h"
// Views

// Vendors

// Categories

// Others

@interface LYMessageModelCell ()
//标题
@property(nonatomic, strong) UILabel *titleLabel;
//图片
@property(nonatomic, strong) UIImageView *imageNameView;

//底部分割线
@property(nonatomic, strong) UIView *cellLine;

@end
@implementation LYMessageModelCell

#pragma mark - inital
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = PFR14Font;
    [self addSubview:_titleLabel];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.font = PFR13Font;
    [self addSubview:_messageLabel];
    
    _imageNameView = [[UIImageView alloc] init];
    [self addSubview:_imageNameView];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = PFR16Font;
    [self addSubview:_dateLabel];
    
    _cellLine = [[UIView alloc] init];
    _cellLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [self addSubview:_cellLine];
    
    _imageNameView.image = [UIImage imageNamed:@"公告"];
    _titleLabel.text = @"重要公告";
}

#pragma mark - 布局

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_imageNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(DCMargin);
        make.centerY.equalTo(self.centerY);
        make.size.equalTo(CGSizeMake(44, 44));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageNameView.right).offset(15);
        make.top.equalTo(DCMargin);
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.bottom).offset(5);
        make.left.equalTo(_titleLabel.left);
        make.right.equalTo(-4*DCMargin);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.right.equalTo(-4*DCMargin);
    }];
    
    [_cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.left);
        make.right.equalTo(0);
        make.height.equalTo(1);
        make.bottom.equalTo(0);
    }];
}

#pragma mark - Setter Getter Methods

-(void)setMessageItem:(LYMessageModel *)messageItem
{
    _messageItem = messageItem;
    _imageNameView.image = [UIImage imageNamed:@"公告"];
    _titleLabel.text = @"重要公告";
    _messageLabel.text = messageItem.message;
    
}
@end
