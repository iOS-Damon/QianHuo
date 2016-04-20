//
//  HSYIsLikeBottonDelegate.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/19.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HSYLikeButtonDelegate <NSObject>

- (void)likeButtonDidSeleted:(BOOL)seleted indexPath:(NSIndexPath*)indexPath;

@end
