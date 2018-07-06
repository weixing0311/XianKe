//
//  NewCharCell.h
//  zjj
//
//  Created by iOSdeveloper on 2018/4/16.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAGlobalMacro.h"
#import "AAChartKit.h"
#import "NSDate+CustomDate.h"
#import "ShareHealthItem.h"
#import "NSString+dateWithString.h"

@interface NewCharCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *charBgView;
@property (weak, nonatomic) IBOutlet UIButton *dayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weakBtn;
@property (weak, nonatomic) IBOutlet UIButton *mouthBtn;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *subTitlelb;
@property(nonatomic,strong) AAChartModel   *    chartModel;
@property(nonatomic,strong) AAChartView    *    chartView;
-(void)setInfoWithArray:(NSMutableArray *)array;
@end
