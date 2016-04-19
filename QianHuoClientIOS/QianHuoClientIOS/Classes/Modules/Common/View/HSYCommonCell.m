//
//  HSYLearningTimeCell.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYCommonCell.h"
#import "Masonry.h"
#import "FYLabel.h"
#import "UIView+FY.h"
#import "UIScreen+FY.h"

static CGFloat const HSYCommonCellPaddingScale = 0.015;
static CGFloat const HSYCommonCellAvatarHeightScale = 0.25;
static CGFloat const HSYCommonCellIsLikeBtnHeightScale = 0.15;

@interface HSYCommonCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) FYLabel *titleLabel;
@property (nonatomic, strong) UILabel *descLable;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, strong) UIButton *isLikeBtn;

@end

@implementation HSYCommonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setupViews {
    [super setupViews];
    
    FYWeakSelf(weakSelf);
    
    self.padding = [UIScreen screenLongSide] * HSYCommonCellPaddingScale;
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.image = self.avatarImage;
    [self.contentView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.contentView.mas_height).multipliedBy(HSYCommonCellAvatarHeightScale);
        make.width.equalTo(self.avatarImageView.mas_height);
        make.left.equalTo(self.contentView.mas_left).offset(weakSelf.padding * 2);
        make.top.equalTo(self.contentView.mas_top).offset(weakSelf.padding);
    }];
    
    self.titleLabel = [[FYLabel alloc] initWithString:self.title size:FYLabSize3 color:FYColorBlack];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(self.padding);
        make.centerY.equalTo(self.avatarImageView.mas_centerY);
    }];
    
    self.isLikeBtn = [[UIButton alloc] init];
    self.isLikeBtn.backgroundColor = [UIColor clearColor];
    [self.isLikeBtn setBackgroundImage:[UIImage imageNamed:@"ButtonLikeDis.png"] forState:UIControlStateNormal];
    [self.isLikeBtn setBackgroundImage:[UIImage imageNamed:@"ButtonLikeAct.png"] forState:UIControlStateSelected];
    [self.isLikeBtn addTarget:self action:@selector(isLikeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.isLikeBtn];
    [self.isLikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.contentView.mas_height).multipliedBy(HSYCommonCellIsLikeBtnHeightScale);
        make.width.equalTo(self.isLikeBtn.mas_height);
        make.right.equalTo(self.contentView.mas_right).offset(- self.padding * 2);
        make.centerY.equalTo(self.avatarImageView.mas_centerY);
    }];
    
    UIView *boardView = [[UIView alloc] init];
    boardView.layer.borderWidth = 0.5;
    boardView.layer.borderColor = FYColorGary.CGColor;
    boardView.layer.cornerRadius = 3;
    [self.contentView addSubview:boardView];
    [boardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(weakSelf.padding);
        make.left.equalTo(self.contentView.mas_left).offset(weakSelf.padding);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(- (weakSelf.padding + HSYBaseTableCellSeparatorPadding));
        make.right.equalTo(self.contentView.mas_right).offset(- weakSelf.padding);
    }];
    
    self.descLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.descLable.text = self.title;
    self.descLable.textColor = FYColorBlack;
    self.descLable.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:FYLabSize2];
    self.descLable.numberOfLines = 0;
    self.descLable.textAlignment = NSTextAlignmentLeft;
    self.descLable.backgroundColor = [UIColor clearColor];
    [boardView addSubview:self.descLable];
    [self.descLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(boardView.mas_centerY);
        make.left.equalTo(boardView.mas_left).offset(weakSelf.padding);
        make.right.equalTo(boardView.mas_right).offset(- weakSelf.padding);
    }];
}

- (void)setDesc:(NSString *)desc {
    _desc = desc;
    self.descLable.text = desc;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setStringAndLeft:title];
}

- (void)setAvatarImage:(UIImage *)avatarImage {
    _avatarImage = avatarImage;
    self.avatarImageView.image = avatarImage;
}

- (void)setHasRead:(BOOL)hasRead {
    _hasRead = hasRead;
    if (hasRead) {
        self.descLable.textColor = FYColorGary;
    } else {
        self.descLable.textColor = FYColorBlack;
    }
}

- (void)setIsLike:(BOOL)isLike {
    _isLike = isLike;
    self.isLikeBtn.selected = isLike;
}

- (void)isLikeBtnAction:(id)sender {
    self.isLikeBtn.selected = !self.isLikeBtn.selected;
}

@end
