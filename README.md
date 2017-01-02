#使用方法有两种：其中回调能获取选择日期并移除pickerview

   # 1：类方法调用

    [EBTSelectDatePickerView showInView:self.view andSelectDateCompleteHander:^(NSString *selectDate) {
        NSLog(@"类方法调用selectDate = %@",selectDate);
        
    }];

   #2:单列方法调用 

    [[EBTSelectDatePickerView shareInstance] showInView:self.view andSelectDateCompleteHander:^(NSString *selectDate) {
        
        NSLog(@"单列对象调用selectDate = %@",selectDate);
    }];
#演示图
![Image](https://github.com/KBvsMJ/EBTDatePickerDemo/blob/master/demogif/1.gif)
