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
//@property (nonatomic, strong) NSMutableDictionary *progresses;

@end

@implementation HSYRestFuliCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.progresses = [[NSMutableDictionary alloc] initWithCapacity:5];
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
    self.progressView.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    [self.contentView addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setUrl:(NSString *)url {
    _url = url;
    
    HSYRestFuliCell __weak *weakSelf = self;
    
    self.fuliImgView.image = [UIImage imageNamed:@""];
    
//    NSNumber *progress = self.progresses[url];
//    if (progress) {
//        self.progressView.progress = [progress floatValue];
//    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        CGFloat scale = (float)receivedSize / (float)expectedSize;
        NSLog(@"scale------%f", scale - 0.01);
        
//        [self.progresses setObject:[NSNumber numberWithFloat:scale - 0.01] forKey:url];
        
        weakSelf.progressView.progress = scale - 0.01;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        weakSelf.fuliImgView.image = [FYUtils cutImageToSquare:image];
        weakSelf.progressView.progress = 1.0;
//        [self.progresses removeObjectForKey:url];
    }];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.fuliImgView.image = image;
}

@end
