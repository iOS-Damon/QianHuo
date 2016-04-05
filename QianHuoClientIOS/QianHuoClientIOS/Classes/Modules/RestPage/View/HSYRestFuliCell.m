//
//  HSYRestFuliCell.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRestFuliCell.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FYUtils.h"
#import "UCZProgressView.h"

static CGFloat const HSYRestFuliCellImgViewPadding = 5;

@interface HSYRestFuliCell ()

@property (nonatomic, strong) UIImageView *fuliImgView;
@property (nonatomic, strong) UCZProgressView *progressView;

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
    self.fuliImgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.fuliImgView];
    [self.fuliImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets insets = UIEdgeInsetsMake(HSYRestFuliCellImgViewPadding, HSYRestFuliCellImgViewPadding, HSYRestFuliCellImgViewPadding + HSYBaseTableCellSeparatorPadding, HSYRestFuliCellImgViewPadding);
        make.edges.equalTo(self.contentView).insets(insets);
    }];
    
    self.progressView = [[UCZProgressView alloc] init];
    self.progressView.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets insets = UIEdgeInsetsMake(HSYRestFuliCellImgViewPadding, HSYRestFuliCellImgViewPadding, HSYRestFuliCellImgViewPadding + HSYBaseTableCellSeparatorPadding, HSYRestFuliCellImgViewPadding);
        make.edges.equalTo(self.contentView).insets(insets);
    }];
}

- (void)setUrl:(NSString *)url {
    _url = url;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.progress = receivedSize / expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.progressView.progress = 1.0;
        self.fuliImgView.image = [FYUtils cutImageToSquare:image];
    }];
}

@end
