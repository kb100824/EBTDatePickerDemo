//
//  EBTSelectDatePickerView.m
//  EBT
//
//  Created by MJ on 15/4/27.
//  Copyright (c) 2015年 TJ. All rights reserved.
//

#import "EBTSelectDatePickerView.h"
#define kDatePickerHeight   300.f
#define kDateViewHeight     300.f
@interface EBTSelectDatePickerView ()
{
    UIDatePicker *_datePicker;      //日期选择器
    UIButton     *_btnLeftCancel;   //左边取消按钮
    UIButton     *_btnRightConform; //右边确定按钮
    BOOL         _isSelectDate;     //是否选择日期
    UIToolbar    *containToolBar;
}
@end

@implementation EBTSelectDatePickerView

+ (EBTSelectDatePickerView *)shareInstance
{
    static EBTSelectDatePickerView *dateInstance ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dateInstance = [[EBTSelectDatePickerView alloc]init];
    });
    return dateInstance;
}
- (instancetype)init
{
    if (self = [super init])
    {
        CGRect frect = CGRectZero;
        frect.size.height = kDateViewHeight;
        frect.origin.y   = SCREEN_HEIGHT;
        frect.size.width = SCREEN_WIDTH;
        self.frame = frect;
        self.backgroundColor = [UIColor whiteColor];
        [self setUp];

    }
    return self;
}
/**
 *  创建按钮和日期选择器
 */
- (void)setUp
{ 
    
    /**toolbar工具条*/
    containToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 24)];
    containToolBar.backgroundColor = UIColorFromRGB(0x333333);
    [self addSubview:containToolBar];
    /**取消按钮*/
    _btnLeftCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnLeftCancel.frame = CGRectMake(0, 0, 120, 24);
    [_btnLeftCancel setTitle:@"选择出发日期" forState:UIControlStateNormal];
    [_btnLeftCancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnLeftCancel addTarget:self action:@selector(cancelDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [containToolBar addSubview:_btnLeftCancel];
    
    
    
    /**确定按钮*/
    _btnRightConform = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRightConform.frame = CGRectMake(SCREEN_WIDTH-60, 0, 60, 24);
    [_btnRightConform setTitle:@"确定" forState:UIControlStateNormal];
     [_btnRightConform setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btnRightConform addTarget:self action:@selector(ConformDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [containToolBar addSubview:_btnRightConform];
    
    
    /**datepicker*/
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.frame = CGRectMake(0, 50, SCREEN_WIDTH, 0);
    /**设置格式显示年月日*/
    _datePicker.datePickerMode = UIDatePickerModeDate;
     /**本地化为中文公历*/
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    [_datePicker addTarget:self action:@selector(pickerviewChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_datePicker];

    
    
}
/**
 *   取消按钮添加事件
 *
 *  @param sender
 */
- (void)cancelDatePicker:(UIButton *)sender
{
    [self dismissDatePiker];
}
/**
 *  确定按钮添加事件
 *
 *  @param sender
 */
- (void)ConformDatePicker:(UIButton *)sender
{
    if (sender.isTouchInside)
    {
        [self dismissDatePiker];
        /**
         *  如果没有选择日期，则当天日期作为参数传递
         */
        if (!_isSelectDate)
        {
            if (selectDateCompleteHander)
            {
                selectDateCompleteHander([self dealselectDate:[NSDate date]]);
            }
            
        }
        _isSelectDate = NO;
        
    }
    
}
/**
 *  获取当前选择的日期
 *
 *  @param picker
 */
- (void)pickerviewChanged:(UIDatePicker *)picker
{
    _isSelectDate = YES;
    
    if (selectDateCompleteHander)
    {
        selectDateCompleteHander([self dealselectDate:picker.date]);
        
    }
}
/**
 *  格式化处理获取的日期
 *
 *  @param date 当前日期或者是选择的日期
 *
 *  @return 返回一个已经格式化日期字符串
 */
- (NSString*)dealselectDate:(NSDate *)date
{
    NSArray * arrOfWeek=@[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth |NSCalendarUnitDay |NSCalendarUnitWeekday |NSCalendarUnitHour |
     NSCalendarUnitMinute |NSCalendarUnitSecond;
    
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    /**对月份进行处理月份的位数一位数时需要在月份前面添加“0”*/
    NSString *monthFormatter = [NSString stringWithFormat:@"%ld",month];
    if (monthFormatter.length == 1) {
        monthFormatter = [NSString stringWithFormat:@"0%@",monthFormatter];
    }
    else
    {
        monthFormatter = monthFormatter;
    }
    /**特殊时间格式4/27(周一)*/
    NSString *formatterDate = [NSString stringWithFormat:@"%@/%ld(%@)",monthFormatter,day,[arrOfWeek objectAtIndex:week-1]];
    NSString *appendDate = [NSString stringWithFormat:@"%ld-%@-%ld %@",year,monthFormatter,day,formatterDate];
    return appendDate;
}
/**
 *  显示日期选择器
 *
 *  @param baseView            显示在父视图
 *  @param dateCompleteHandler 把获取的日期作为参数传递
 */
- (void)showInView:(UIView *)baseView andSelectDateCompleteHander:(SelectDatePickerCompleteHandler)dateCompleteHandler
{
    
    selectDateCompleteHander = dateCompleteHandler;
    [baseView addSubview:self];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGRect selfRect = self.frame;
        selfRect.origin.y = SCREEN_HEIGHT-kDateViewHeight;
        self.frame = selfRect;
        
        CGRect dateRect = _datePicker.frame;
        dateRect.size.height = kDatePickerHeight;
        _datePicker.frame = dateRect;
        
        
    } completion:^(BOOL finished) {
        
    }];

}
/**
 *  显示日期选择器
 *
 *  @param baseView             显示在父视图
 *  @param dateCompleteHandler 把获取的日期作为参数传递
 */
+ (void)showInView:(UIView *)baseView andSelectDateCompleteHander:(SelectDatePickerCompleteHandler)dateCompleteHandler
{
    [[EBTSelectDatePickerView shareInstance] showInView:baseView andSelectDateCompleteHander:dateCompleteHandler];
}


/**
 *  移除日期选择器
 */
- (void)dismissDatePiker
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        /**
         *  重新设置self(view)的y坐标
         */
        CGRect selfRect = self.frame;
        selfRect.origin.y = SCREEN_HEIGHT;
        self.frame = selfRect;
        
        /**
         *  重新设置日期选择器的高度
         */
        CGRect dateRect = _datePicker.frame;
        dateRect.size.height =0;
        _datePicker.frame = dateRect;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
    
}

@end
