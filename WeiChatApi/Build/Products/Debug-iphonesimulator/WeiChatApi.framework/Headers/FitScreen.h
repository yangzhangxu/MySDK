//
//  FitScreen.h
//  RedPacket
//
//  Created by 杨张旭 on 2017/1/4.
//  Copyright © 2017年 NONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FitScreen : NSObject

//圆形
+(void)FitScreenWithRing:(NSArray *)constrains;
//竖屏
+(void)FitScreenWithPortrait:(NSArray *)constrains;
//只改宽度和X坐标
+(void)FitScreenWithPortraitToWidth:(NSArray *)constrains;

+(void)FitScreenWithRingHere:(NSArray *)constrains;

+(void)forFitSubViews:(UIView *)view;
@end

