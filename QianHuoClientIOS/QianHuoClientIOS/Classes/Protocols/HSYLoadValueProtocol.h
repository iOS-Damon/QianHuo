//
//  HSYTableControllerViewmodelProtocol.h
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/29.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HSYLoadValueProtocol <NSObject>

- (void)loadOldValue;
- (void)loadNewValue;
- (void)loadMoreValue;

@end
