//
//  FitScreen.m
//  RedPacket
//
//  Created by Zhangxu Yang on 2017/1/4.
//  Copyright © 2017年 NONE. All rights reserved.
//

#import "FitScreen.h"

#define VERSION [UIDevice currentDevice].systemVersion
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.width == 320.0f)
#define IS_IPHONE_PLUS ([[UIScreen mainScreen] bounds].size.height == 736.0f)

#define MainWidth [UIScreen mainScreen].bounds.size.width
#define MainHeight [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue&0xFF0000)>>16))/255.0 green:((float)((rgbValue&0xFF00)>>8))/255.0 blue:((float)(rgbValue&0xff))/255.0 alpha:1.0]
#define UIColorFromRGBAlpha(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue&0xFF0000)>>16))/255.0 green:((float)((rgbValue&0xFF00)>>8))/255.0 blue:((float)(rgbValue&0xff))/255.0 alpha:alphaValue]
#define ScaleWidth MainWidth/375
#define ScaleHeight MainHeight/667
#define ScaleHeightUpdate (ScaleWidth==1?1:ScaleHeight)

@implementation FitScreen

+(void)FitScreenWithPortrait:(NSArray *)constrains
{
    CGFloat value = 0.0;
    //    NSLog(@"%f,%f",MainWidth,MainHeight);
    for (NSLayoutConstraint *constraint in constrains) {
        if ([constraint.identifier isEqualToString:@"headHeight"]) {
            if (KIsiPhoneX) {
                value=constraint.constant-88;
            }else{
                value=constraint.constant-64;
            }
        }else{
            value=constraint.constant;
        }
        
        if (constraint.firstAttribute==NSLayoutAttributeLeft||constraint.firstAttribute==NSLayoutAttributeTrailing||constraint.firstAttribute==NSLayoutAttributeWidth||constraint.firstAttribute==NSLayoutAttributeRight||constraint.firstAttribute==NSLayoutAttributeLeading||constraint.firstAttribute==NSLayoutAttributeTrailingMargin||constraint.firstAttribute==NSLayoutAttributeLeadingMargin) {
            constraint.constant=value*ScaleWidth;
        }else if (constraint.firstAttribute==NSLayoutAttributeTop||constraint.firstAttribute==NSLayoutAttributeBottom||constraint.firstAttribute==NSLayoutAttributeHeight||constraint.firstAttribute==NSLayoutAttributeTopMargin||constraint.firstAttribute==NSLayoutAttributeBottomMargin){
            if ([constraint.identifier isEqualToString:@"headHeight"]) {
                if (KIsiPhoneX) {
                    constraint.constant=value*ScaleHeightUpdate+88;
                }else{
                    constraint.constant=value*ScaleHeightUpdate+64;
                }
            }else{
//                if ([constraint.identifier isEqualToString:@"NoChange"]) {
//                    constraint.constant=value;
//                }else if([constraint.identifier isEqualToString:@"HeightNoChange"]){
//                    if (KIsiPhoneX||IS_IPHONE_6_PLUS) {
//                        constraint.constant=value;
//                    }else{
//                        constraint.constant=value*scaleheight;
//                    }
//                }else{
//                    constraint.constant=value*scaleheight;
//                }
                if (ScaleWidth==1) {
                    if ([constraint.identifier containsString:@"ScaleHeight"]){
                        constraint.constant=value*ScaleHeight;
                    }else{
                        constraint.constant=value;
                    }
                }else{
                    constraint.constant=value*ScaleHeightUpdate;
                }
            }
            
        }
        
    }
}
+(void)FitScreenWithPortraitToWidth:(NSArray *)constrains
{
    CGFloat value;
    for (NSLayoutConstraint *constraint in constrains) {
        value=constraint.constant;
        if (constraint.firstAttribute==NSLayoutAttributeLeft||constraint.firstAttribute==NSLayoutAttributeTrailing||constraint.firstAttribute==NSLayoutAttributeWidth||constraint.firstAttribute==NSLayoutAttributeRight||constraint.firstAttribute==NSLayoutAttributeLeading||constraint.firstAttribute==NSLayoutAttributeTrailingMargin||constraint.firstAttribute==NSLayoutAttributeLeadingMargin) {
            constraint.constant=value*ScaleWidth;
        }
    }
}
+(void)FitScreenWithRing:(NSArray *)constrains
{
    CGFloat value;
//    NSLog(@"%f,%f",scalewidth,scaleheight);
    for (NSLayoutConstraint *constraint in constrains) {
        value=constraint.constant;
        if (constraint.firstAttribute==NSLayoutAttributeLeft||constraint.firstAttribute==NSLayoutAttributeTrailing||constraint.firstAttribute==NSLayoutAttributeRight||constraint.firstAttribute==NSLayoutAttributeLeading||constraint.firstAttribute==NSLayoutAttributeTrailingMargin||constraint.firstAttribute==NSLayoutAttributeLeadingMargin) {
            constraint.constant=value*ScaleWidth;
        }else if (constraint.firstAttribute==NSLayoutAttributeTop||constraint.firstAttribute==NSLayoutAttributeBottom||constraint.firstAttribute==NSLayoutAttributeTopMargin||constraint.firstAttribute==NSLayoutAttributeBottomMargin){
            constraint.constant=value*ScaleHeightUpdate;
        }
        if (constraint.firstAttribute==NSLayoutAttributeWidth||constraint.firstAttribute==NSLayoutAttributeHeight) {
            constraint.constant=value*ScaleWidth;
        }
    }
}
+(void)FitScreenWithRingHere:(NSArray *)constrains
{
    CGFloat value;
//    scaleheight=MainHeight/667;
//    scalewidth=MainWidth/375;
//    NSLog(@"%f,%f",scalewidth,scaleheight);
    for (NSLayoutConstraint *constraint in constrains) {
        value=constraint.constant;
        if (constraint.firstAttribute==NSLayoutAttributeLeft||constraint.firstAttribute==NSLayoutAttributeTrailing||constraint.firstAttribute==NSLayoutAttributeRight||constraint.firstAttribute==NSLayoutAttributeLeading||constraint.firstAttribute==NSLayoutAttributeTrailingMargin||constraint.firstAttribute==NSLayoutAttributeLeadingMargin) {
            constraint.constant=value*ScaleWidth;
        }else if (constraint.firstAttribute==NSLayoutAttributeTop||constraint.firstAttribute==NSLayoutAttributeBottom||constraint.firstAttribute==NSLayoutAttributeTopMargin||constraint.firstAttribute==NSLayoutAttributeBottomMargin){
            constraint.constant=value*ScaleHeightUpdate;
        }
    }
}
+(void)forFitSubViews:(UIView *)view
{
//    [view layoutIfNeeded];
    NSArray *subviews=view.subviews;
    for (int i=0; i<subviews.count; i++) {
        if ([[subviews[i] restorationIdentifier] containsString:@"ring"]) {
            [FitScreen FitScreenWithRing:[subviews[i] constraints]];
        }else{
            if (![[subviews[i] restorationIdentifier] containsString:@"head"]) {
                if ([subviews[i] class]==[UIView class]||[subviews[i] class]==[UIScrollView class]) {
                    [FitScreen forFitSubViews:subviews[i]];
                }else{
                    [FitScreen FitScreenWithPortrait:[subviews[i] constraints]];
                }
            }
        }
    }
    [FitScreen FitScreenWithPortrait:[view constraints]];
}
@end

