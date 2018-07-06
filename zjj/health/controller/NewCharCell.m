//
//  NewCharCell.m
//  zjj
//
//  Created by iOSdeveloper on 2018/4/16.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewCharCell.h"

@implementation NewCharCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configTheChartView:AAChartTypeLine];

}
-(void)setInfoWithArray:(NSMutableArray *)array
{
    NSMutableArray * infoArray = [NSMutableArray array];
    NSMutableArray * timeArray = [NSMutableArray array];

    for (NSInteger i =(array.count-1); i>=0; i--) {
        HealthDetailsItem * item = [array objectAtIndex:i];
        NSString   *   time = item.createTime;

//        NSDate   *   time = item.createTime;
//        float   mfat = [[NSString stringWithFormat:@"%.1f",item.fatPercentage*100]floatValue];
//        float   mwater =[[NSString stringWithFormat:@"%.1f",item.waterWeight]floatValue] ;
//        float   mCalorie = [[NSString stringWithFormat:@"%.1f",item.fatWeight]floatValue];
//        float   bmi =[[NSString stringWithFormat:@"%.1f",item.bmi]floatValue];
//        float   mbone =[[NSString stringWithFormat:@"%.1f",item.boneMuscleWeight]floatValue];
//        float weight = []
        [timeArray addObject:[time mmdd]];
        switch (self.tag) {
            case 0:
                [infoArray addObject:@(item.weight)];
                break;
            case 1:
                [infoArray addObject:@(item.bmi)];
                break;
            case 2:
                [infoArray addObject:@(item.waterWeight)];
                break;
            case 3:
                [infoArray addObject:@(item.visceralFatPercentage)];
                break;
            case 4:
                [infoArray addObject:@(item.boneWeight)];
                break;
            case 5:
                [infoArray addObject:@(item.fatPercentage)];
                break;

            default:
                break;
        }
    }
    
    NSString * title ;
    switch (self.tag) {
        case 0:
            title = @"体重";
            break;
        case 1:
            title = @"BMI";
            break;
        case 2:
            title = @"水分";
            break;
        case 3:
            title = @"内脂";
            break;
        case 4:
            title = @"骨量";
            break;
        case 5:
            title = @"脂肪量";
            break;

        default:
            break;
    }
    
    [self ChartViewsetDateArray:timeArray infoArray:infoArray title:title];

}
-(void)configTheChartView:(NSString *)chartType{
    self.chartView = [[AAChartView alloc]init];
    self.chartView.frame =CGRectMake(0, 0, JFA_SCREEN_WIDTH-20, 200);
    self.chartView.contentWidth = JFA_SCREEN_WIDTH-20;
    self.chartView.contentHeight = 200;
    [self.charBgView addSubview:self.chartView];
    self.chartModel= AAObject(AAChartModel).chartTypeSet(chartType)
    .titleSet(@"")
    .subtitleSet(@"")
    .pointHollowSet(true)
    .categoriesSet(nil)//array
    .yAxisTitleSet(@"")
    .crosshairsSet(NO)
    .yAxisGridLineWidthSet(@(0))
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"")
                 .dataSet(nil),//array
                 ]
               ) ;
    [self.chartView aa_drawChartWithChartModel:_chartModel];
}
-(void)ChartViewsetDateArray:(NSMutableArray *)dateArray infoArray:(NSMutableArray *)infoarray title:(NSString *)title
{
    // AAChartTypeLine
    self.chartModel= AAObject(AAChartModel).chartTypeSet(AAChartTypeLine)
    .titleSet(title)
    .subtitleSet(@"")
    .pointHollowSet(true)
    .crosshairsSet(NO)
    .yAxisGridLineWidthSet(@(0))
    
    .categoriesSet(dateArray)
    .yAxisTitleSet(@"")
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(title)
                 .dataSet(infoarray),
                 ]
               ) ;
    [self.chartView aa_drawChartWithChartModel:_chartModel];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
