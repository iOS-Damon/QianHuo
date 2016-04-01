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
    self.fuliImgView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.fuliImgView];
    [self.fuliImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets insets = UIEdgeInsetsMake(HSYRestFuliCellImgViewPadding, HSYRestFuliCellImgViewPadding, HSYRestFuliCellImgViewPadding + HSYBaseTableCellSeparatorPadding, HSYRestFuliCellImgViewPadding);
        make.edges.equalTo(self.contentView).insets(insets);
    }];
}

- (void)setUrl:(NSString *)url {
    _url = url;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        NSLog(@"receivedSize---%ld---expectedSize---%ld", receivedSize, expectedSize);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.fuliImgView.image = [FYUtils cutImageToSquare:image];
    }];
}

@end
