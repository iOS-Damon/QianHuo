//
//  HSYLearningTimeHeader.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYCommonHeader.h"
#import "UIView+FY.h"
#import "NSString+FY.h"
#import "Masonry.h"

@implementation HSYCommonHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = FYColorLightGary;
    
    UIView *separatorLineBottom = [[UIView alloc] init];
    separatorLineBottom.backgroundColor = FYColorGary;
    [self.contentView addSubview:separatorLineBottom];
    [separatorLineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView.mas_width);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = FYClearNil(title);
    self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:_title attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:FYLabSize3] ,NSForegroundColorAttributeName:FYColorSub}];
    [self setNeedsLayout];
}

#pragma mark - override
- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.center = CGPointMake(self.frameWidth / 2, self.frameHeight / 2);
}

@end
