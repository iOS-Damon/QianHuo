//
//  HSYRestFuliCell.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRestFuliCell.h"
#import "Masonry.h"

static CGFloat const HSYRestFuliCellImgViewPadding = 5;

@interface HSYRestFuliCell ()

@property (nonatomic, strong) UIImageView *fuliImgView;

@end

@implementation HSYRestFuliCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setupViews {
    [super setupViews];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.fuliImgView = [[UIImageView alloc] init];
    self.fuliImgView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:self.fuliImgView];
    [self.fuliImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets insets = UIEdgeInsetsMake(HSYRestFuliCellImgViewPadding, HSYRestFuliCellImgViewPadding, HSYRestFuliCellImgViewPadding + HSYBaseTableCellSeparatorPadding, HSYRestFuliCellImgViewPadding);
        make.edges.equalTo(self.contentView).insets(insets);
    }];
}

- (void)setUrl:(NSString *)url {
    _url = url;
    
}

@end
