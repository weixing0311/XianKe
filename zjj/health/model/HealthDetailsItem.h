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

@property (nonatomic,assign) float              score;//分数

@property (nonatomic,assign) float              lastWeight;
@property (nonatomic,assign) float              weight;// 体重
@property (nonatomic,assign) int                weightLevel;//体重判定标准



@property (nonatomic,assign) float              bmi;// 体质指数
@property (nonatomic,assign) int                bmiLevel;//bmi程度

@property (nonatomic,assign) int                mVisceralFat;//内脏脂肪
@property (nonatomic,assign) float              visceralFatPercentage;//内脏脂肪指数
@property (nonatomic,assign) int                visceralFatPercentageLevel;//内脂判定标准


@property (nonatomic,assign) float              bmr;// 基础代谢率
@property (nonatomic,assign) float              bmrMax;
@property (nonatomic,assign) float              bmrMin;
@property (nonatomic,assign) int                bmrLevel;

@property (nonatomic,assign) int              bodyAge;// 身体年龄
@property (nonatomic,assign) int                bodyLevel; //身体指数

@property (nonatomic,assign) float              mFat;//体脂
@property (nonatomic,assign) float              fatWeight;//脂肪重
@property (nonatomic,assign) float              fatWeightMax;
@property (nonatomic,assign) float              fatWeightMin;
@property (nonatomic,assign) int                fatWeightLevel;//脂肪重判定标准

@property (nonatomic,assign) float              mWater;//水分
@property (nonatomic,assign) float              waterWeight;// 细胞总水
@property (nonatomic,assign) float              waterWeightMax;
@property (nonatomic,assign) float              waterWeightMin;
@property (nonatomic,assign) int                waterLevel;//水分判定标准


@property (nonatomic,assign) float              proteinWeight;// 蛋白质重量
@property (nonatomic,assign) float              proteinWeightMax;
@property (nonatomic,assign) float              proteinWeightMin;
@property (nonatomic,assign) int                proteinLevel;//蛋白质判定标准


@property (nonatomic,assign) float              mBone;//骨骼肌
@property (nonatomic,assign) float              boneWeight;//骨头重量
@property (nonatomic,assign) float              boneWeightMax;
@property (nonatomic,assign) float              boneWeightMin;
@property (nonatomic,assign) int                boneLevel;

@property (nonatomic,assign) float              mMuscle;//肌肉
@property (nonatomic,assign) float              muscleWeight;// 肌肉重量
@property (nonatomic,assign) float              muscleWeightMax;
@property (nonatomic,assign) float              muscleWeightMin;
@property (nonatomic,assign) int                muscleLevel;//肌肉判定标准

@property (nonatomic,assign) float                mCalorie;//脂肪量
@property (nonatomic,assign) float              fatPercentage; //脂肪比例
@property (nonatomic,assign) float              fatPercentageMax;
@property (nonatomic,assign) float              fatPercentageMin;
@property (nonatomic,assign) int                fatPercentageLevel;


@property (nonatomic,assign) int                boneMuscleLevel;//骨骼肌
@property (nonatomic,assign) float              boneMuscleWeight;
@property (nonatomic,assign) float              boneMuscleWeightMin;
@property (nonatomic,assign) float              boneMuscleWeightMax;

@property (nonatomic,assign) float              standardWeight;//标准体重
@property (nonatomic,assign) float              weightControl;//体重控制量
@property (nonatomic,assign) float              lbm;//去脂体重
@property (nonatomic,assign) float              fatControl;//脂肪控制量


@property (nonatomic,assign) int                normal;//正常
@property (nonatomic,assign) int                warn;//警告
@property (nonatomic,assign) int                serious;//严重

@property (nonatomic,assign) int                age;//严重
@property (nonatomic,assign) int                height;//严重


@property (nonatomic,assign) int                ranking;//排名
@property (nonatomic,assign) float              percent;//占比
@property (nonatomic,assign) float              myScore;//分数

-(NSString *)getHealthDetailShuoMingWithStatus:(NSInteger)myType item:(HealthDetailsItem*)item;//获取等级说明
-(NSString *)getinstructionsWithType:(NSInteger)index;
-(void)getInfoWithDict:(NSDictionary *)dict;
-(NSMutableDictionary *)setSliderInfoWithRow:(NSInteger)row btnTag:(NSInteger)btnTag;

/**获取距离最佳体脂率的差值*/
-(double)getFatPercentagePoorWithItem:(HealthDetailsItem*)item;
/**获取距离最佳体脂的差值*/
-(double)getFatWeightPoorWithItem:(HealthDetailsItem*)item;

@end
