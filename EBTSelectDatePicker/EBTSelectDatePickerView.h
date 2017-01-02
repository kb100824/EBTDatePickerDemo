//
//  EBTSelectDatePickerView.m
//  EBT
//
//  Created by MJ on 15/4/27.
//  Copyright (c) 2015年 TJ. All rights reserved.
//

//主屏宽
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//主屏高
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#import <UIKit/UIKit.h>
/**
 *  日期选择器回调
 *
 *  @param selectDate 获取选择的日期
 */
typedef void(^SelectDatePickerCompleteHandler)(NSString *selectDate);
/**
 *  日期选择器DatePickerView
 */
@interface EBTSelectDatePickerView : UIView
{
    SelectDatePickerCompleteHandler  selectDateCompleteHander;

}
/**
 *  使用单例来调用显示日期选择器DatePickerView
 *
 *  @return 单例对象
 */
+ (EBTSelectDatePickerView *)shareInstance;

/**
 *  底部加载显示日期选择器DatePickerView
 *
 *  @param baseView            父视图
 *  @param dateCompleteHandler 获取日期回调
 */
- (void)showInView:(UIView *)baseView andSelectDateCompleteHander:(SelectDatePickerCompleteHandler)dateCompleteHandler;
/**
 *  通过类方法来显示日期选择器DatePickerView
 *
 *  @param baseView 父视图
 *  @param dateCompleteHandler 获取日期回调
 *
 */
+ (void)showInView:(UIView *)baseView andSelectDateCompleteHander:(SelectDatePickerCompleteHandler)dateCompleteHandler;
@end
