//
//  NBHintLayer.h
//  Sample
//
//  Created by Sean on 15/6/23.
//  Copyright (c) 2015年 gRPC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Complete)();

@interface FYHintLayer : UIView

- (id)initWithMessege:(NSString*)messege duration:(int)duration complete:(Complete)complete;

- (void)show;

@end
