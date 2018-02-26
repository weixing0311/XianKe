//
//  TimeModel.m
//  zjj
//
//  Created by iOSdeveloper on 2017/6/27.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "TimeModel.h"
static TimeModel * model;
@implementation TimeModel


+(TimeModel *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[TimeModel alloc]init];
    });
    return model;
}

- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result==NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}

- (int)ageWithDateOfBirth:(NSString *)dateStr;
{
    NSTimeZone *timeZone=[NSTimeZone timeZoneWithAbbreviation:@"GMT"];

    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    fmt.timeZone = timeZone;

    NSDate *srcDate=[fmt dateFromString:dateStr];
    //获得当前系统时间
    NSDate *currentDate = [NSDate date];
    //获得当前系统时间与出生日期之间的时间间隔
    NSTimeInterval time = [currentDate timeIntervalSinceDate:srcDate];
    //时间间隔以秒作为单位,求年的话除以60*60*24*356
    int age = ((int)time)/(3600*24*365);
    return age;
//    NSCalendar *calendar = [NSCalendar currentCalendar];//定义一个NSCalendar对象
//
//    NSDate *nowDate = [NSDate date];
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    //生日
//    NSDate *birthDay = [dateFormatter dateFromString:dateStr];
//
//    //用来得到详细的时差
//    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0];
//
//    if([date year] >0){
//        NSLog(@"%@",[NSString stringWithFormat:(@"%ld岁%ld月%ld天"),(long)[date year],(long)[date month],(long)[date day]]) ;
//    }else if([date month] >0){
//        NSLog(@"%@",[NSString stringWithFormat:(@"%ld月%ld天"),(long)[date month],(long)[date day]]);
//    }else if([date day]>0){
//        NSLog(@"%@",[NSString stringWithFormat:(@"%ld天"),(long)[date day]]);
//    }else {
//        NSLog(@"0天");
//    }
//    return [date year];
}


@end
