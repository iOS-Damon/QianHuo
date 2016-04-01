//
//  HSYRestViewmodel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/4/1.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYRestViewmodel.h"

@implementation HSYRestViewmodel

- (NSInteger)sectionsCount {
    return 0;
}

- (NSString*)headerTitleInSection:(NSInteger)section {
    return @"";
}

- (NSInteger)rowsCountInSection:(NSInteger)section {
    return 0;
}

- (UIImage*)rowAvatarAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSString*)rowDescAtIndexPath:(NSIndexPath *)indexPath {
    return @"";
}

- (NSString*)rowUrlAtIndexPath:(NSIndexPath *)indexPath {
    return @"";
}

- (void)loadFirstValue {

}

- (void)loadNewValue {

}

- (void)loadMoreValue {

}

@end
