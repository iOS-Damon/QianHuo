//
//  HSYLearningTimeCell.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYLearningCell.h"
#import "Masonry.h"
#import "FYLabel.h"

static CGFloat const HSYLearningTimeCellPadding = 15;
static CGFloat const HSYLearningTimeCellImageHeightScale = 0.3;

@interface HSYLearningCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) FYLabel *titleLabel;

@end

@implementation HSYLearningCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setupViews {
    [super setupViews];
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.image = self.avatarImage;
    [self.contentView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.contentView.mas_height).multipliedBy(HSYLearningTimeCellImageHeightScale);
        make.width.equalTo(self.avatarImageView.mas_height);
        make.left.equalTo(self.contentView.mas_left).offset(HSYLearningTimeCellPadding);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    self.titleLabel = [[FYLabel alloc] initWithString:self.title size:FYLabSize3 color:FYColorBlack];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.avatarImageView.mas_right).offset(HSYLearningTimeCellPadding);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setStringAndLeft:title];
}

- (void)setAvatarImage:(UIImage *)avatarImage {
    _avatarImage = avatarImage;
    self.avatarImageView.image = avatarImage;
}

@end
