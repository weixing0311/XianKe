//
//  HealthDetailsItem.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/17.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthDetailsItem : NSObject
+(HealthDetailsItem *)instance;

@property (nonatomic,assign) int                DataId;//评测数据id
@property (nonatomic,assign) int                userId;
@property (nonatomic,assign) int                subUserId;
@property (nonatomic,copy  ) NSString     *     createTime;//检测时间

@property (nonatomic,assign) double              score;//分数

@property (nonatomic,assign) double              lastWeight;
@property (nonatomic,assign) double              weight;// 体重
@property (nonatomic,assign) int                weightLevel;//体重判定标准



@property (nonatomic,assign) double              bmi;// 体质指数
@property (nonatomic,assign) int                bmiLevel;//bmi程度

@property (nonatomic,assign) int                mVisceralFat;//内脏脂肪
@property (nonatomic,assign) double              visceralFatPercentage;//内脏脂肪指数
@property (nonatomic,assign) int                visceralFatPercentageLevel;//内脂判定标准


@property (nonatomic,assign) double              bmr;// 基础代谢率
@property (nonatomic,assign) double              bmrMax;
@property (nonatomic,assign) double              bmrMin;
@property (nonatomic,assign) int                bmrLevel;

@property (nonatomic,assign) int              bodyAge;// 身体年龄
@property (nonatomic,assign) int                bodyLevel; //身体指数

@property (nonatomic,assign) double              mFat;//体脂
@property (nonatomic,assign) double              fatWeight;//脂肪重
@property (nonatomic,assign) double              fatWeightMax;
@property (nonatomic,assign) double              fatWeightMin;
@property (nonatomic,assign) int                fatWeightLevel;//脂肪重判定标准

@property (nonatomic,assign) double              mWater;//水分
@property (nonatomic,assign) double              waterWeight;// 细胞总水
@property (nonatomic,assign) double              waterWeightMax;
@property (nonatomic,assign) double              waterWeightMin;
@property (nonatomic,assign) double              waterWeightMaxP;
@property (nonatomic,assign) double              waterWeightMinP;

@property (nonatomic,assign) int                waterLevel;//水分判定标准


@property (nonatomic,assign) double              proteinWeight;// 蛋白质重量
@property (nonatomic,assign) double              proteinWeightMax;
@property (nonatomic,assign) double              proteinWeightMin;
@property (nonatomic,assign) double              proteinWeightMaxP;
@property (nonatomic,assign) double              proteinWeightMinP;

@property (nonatomic,assign) int                proteinLevel;//蛋白质判定标准


@property (nonatomic,assign) double              mBone;//骨骼肌
@property (nonatomic,assign) double              boneWeight;//骨头重量
@property (nonatomic,assign) double              boneWeightMax;
@property (nonatomic,assign) double              boneWeightMin;
@property (nonatomic,assign) int                boneLevel;

@property (nonatomic,assign) double              mMuscle;//肌肉
@property (nonatomic,assign) double              muscleWeight;// 肌肉重量
@property (nonatomic,assign) double              muscleWeightMax;
@property (nonatomic,assign) double              muscleWeightMin;
@property (nonatomic,assign) double              muscleWeightMaxP;
@property (nonatomic,assign) double              muscleWeightMinP;

@property (nonatomic,assign) int                muscleLevel;//肌肉判定标准

@property (nonatomic,assign) double                mCalorie;//脂肪量
@property (nonatomic,assign) double              fatPercentage; //脂肪比例
@property (nonatomic,assign) double              fatPercentageMax;
@property (nonatomic,assign) double              fatPercentageMin;
@property (nonatomic,assign) int                fatPercentageLevel;


@property (nonatomic,assign) int                boneMuscleLevel;//骨骼肌
@property (nonatomic,assign) double              boneMuscleWeight;
@property (nonatomic,assign) double              boneMuscleWeightMin;
@property (nonatomic,assign) double              boneMuscleWeightMax;
@property (nonatomic,assign) double              boneMuscleWeightMinP;
@property (nonatomic,assign) double              boneMuscleWeightMaxp;



@property (nonatomic,assign) double              standardWeight;//标准体重
@property (nonatomic,assign) double              weightControl;//体重控制量
@property (nonatomic,assign) double              lbm;//去脂体重
@property (nonatomic,assign) double              fatControl;//脂肪控制量


@property (nonatomic,assign) int                normal;//正常
@property (nonatomic,assign) int                warn;//警告
@property (nonatomic,assign) int                serious;//严重

@property (nonatomic,assign) int                age;//严重
@property (nonatomic,assign) int                height;//严重


@property (nonatomic,assign) int                ranking;//排名
@property (nonatomic,assign) double              percent;//占比
@property (nonatomic,assign) double              myScore;//分数


///蛋白质指数
@property (nonatomic,assign) double              proteinPercentage;
///肌肉指数
@property (nonatomic,assign) double              musclePercentage ;
///骨骼肌指数
@property (nonatomic,assign) double              boneMusclePercentage ;
///水分指数
@property (nonatomic,assign) double              waterPercentage;





-(NSString *)getHealthDetailShuoMingWithStatus:(NSInteger)myType item:(HealthDetailsItem*)item;//获取等级说明
-(NSString *)getinstructionsWithType:(NSInteger)index;
-(void)getInfoWithDict:(NSDictionary *)dict;
-(NSMutableDictionary *)setSliderInfoWithRow:(NSInteger)row btnTag:(NSInteger)btnTag;

/**获取距离最佳体脂的差值*/
-(double)getFatWeightPoorWithItem:(HealthDetailsItem*)item;

@end
