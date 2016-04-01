//
//  HSYBaseTableCell.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/28.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYBaseTableCell.h"
#import "UIView+FY.h"
#import "Masonry.h"

@interface HSYBaseTableCell ()

@end

@implementation HSYBaseTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIView *separatorBg = [[UIView alloc] init];
    separatorBg.backgroundColor = FYColorLightGary;
    [self.contentView addSubview:separatorBg];
    [separatorBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView.mas_width);
        make.height.mas_equalTo(HSYBaseTableCellSeparatorPadding);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    UIView *separatorLineTop = [[UIView alloc] init];
    separatorLineTop.backgroundColor = FYColorGary;
    [separatorBg addSubview:separatorLineTop];
    [separatorLineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(separatorBg.mas_width);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(separatorBg.mas_top);
    }];
}

@end
