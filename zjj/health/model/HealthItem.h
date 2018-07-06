//
//  HealthItem.h
//  zjj
//
//  Created by iOSdeveloper on 2017/6/16.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    IS_ENUM_WEIGHT,
    IS_ENUM_FATWEIGHT,
    IS_ENUM_visceral,
    


}enumsType;

@interface HealthItem : NSObject
//// 细胞总水
@property (nonatomic,assign) double              waterWeight ;
//// 体重
@property (nonatomic,assign) double              weight ;
//// 肌肉重量
@property (nonatomic,assign) double              muscleWeight ;

//// 体质指数
@property (nonatomic,assign) double              bmi ;
////上次体重
@property (nonatomic,assign) double              lastWeight ;
////脂肪重
@property (nonatomic,assign) double              fatWeight ;
//// 基础代谢率
@property (nonatomic,assign) double              bmr ;
//// 身体年龄
@property (nonatomic,assign) double              bodyAge ;
////内脏脂肪指数
@property (nonatomic,assign) double              visceralFatPercentage ;
//// 蛋白质重量
@property (nonatomic,assign) double              proteinWeight ;
////正常
@property (nonatomic,assign) int                normal ;
////警告
@property (nonatomic,assign) int                warn ;
////严重
@property (nonatomic,assign) int                serious ;
////评测数据id
@property (nonatomic,assign) int                DataId ;
////bmi程度
@property (nonatomic,assign) int                bmiLevel ;
////内脂判定标准
@property (nonatomic,assign) int                visceralFatPercentageLevel ;
////脂肪重判定标准
@property (nonatomic,assign) int                fatWeightLevel ;
////蛋白质判定标准
@property (nonatomic,assign) int                proteinLevel ;
////水分判定标准
@property (nonatomic,assign) int                waterLevel ;
////肌肉判定标准
@property (nonatomic,assign) int                muscleLevel ;
@property (nonatomic,assign) int                userId ;//
@property (nonatomic,assign) int                subUserId ;//
////体重判定标准
@property (nonatomic,assign) int                weightLevel ;
@property (nonatomic,copy  ) NSString     *     createTime ;
@property (nonatomic,assign) double              fatPercentage ; //体脂百分比
@property (nonatomic,assign) double              fatPercentageMax ; //体脂指数正常范围上限
@property (nonatomic,assign) double              fatPercentageMin ; //体脂指数正常范围下限

@property (nonatomic,assign)enumsType           type;
////标准体重
@property (nonatomic,assign) double              standardWeight;
////体重控制量
@property (nonatomic,assign) double              weightControl;
////去脂体重
@property (nonatomic,assign) double              lbm;
////脂肪控制量
@property (nonatomic,assign) double              fatControl;

@property (nonatomic,assign) double              height;
@property (nonatomic,assign) int                age;

@property (nonatomic,assign) int                userDays;//注册时长
@property (nonatomic,assign) double              subtractWeight;//已减脂重量
@property (nonatomic,assign) double              targetWeight;//目标体重

@property (nonatomic,assign) double              score;


-(double)getFatWeightPoorWithItem:(HealthItem*)item;
-(void)setobjectWithDic:(NSDictionary *)dict ;//

/*
@property (nonatomic,assign) int                DataId ;//评测数据id
@property (nonatomic,assign) int                userId ;//
@property (nonatomic,assign) int                subUserId ;//
@property (nonatomic,assign) double              score ; //健康得分
@property (nonatomic,assign) double              weight ;// 体重
@property (nonatomic,assign) double              bmr ;// 基础代谢率
@property (nonatomic,assign) double              bodyAge ;// 身体年龄
@property (nonatomic,assign) double              bmi ;// 体质指数
@property (nonatomic,assign) int                warn ;//
@property (nonatomic,assign) int                normal ;//
@property (nonatomic,assign) int                serious ;//

@property (nonatomic,assign) int                bmiLevel ;//bmi程度

@property (nonatomic,assign) int                visceralFatPercentageLevel ;//内脂判定标准
@property (nonatomic,assign) NSDecimal          mVisceralFat ;// 内脏脂肪
@property (nonatomic,assign) double              visceralFatPercentage ;//内脏脂肪指数

@property (nonatomic,assign) NSDecimal          mFat ;// 体脂
@property (nonatomic,assign) int                fatWeightLevel ;//脂肪重判定标准
@property (nonatomic,assign) double              fatWeight ;//脂肪重
@property (nonatomic,assign) double              fatWeightMax ;// 脂肪重正常范围上限
@property (nonatomic,assign) double              fatWeightMin ;// 脂肪重正常范围下限

@property (nonatomic,assign) double              fatPercentage ; 体脂百分比
@property (nonatomic,assign) double              fatPercentageMax ; 体脂指数正常范围上限
@property (nonatomic,assign) double              fatPercentageMin ; 体脂指数正常范围下限


@property (nonatomic,assign) int                weightLevel ;//体重判定标准
@property (nonatomic,assign) int                bodyLevel ;//体型判定标准
@property (nonatomic,assign) int                fatPercentageLevel ;//体脂百分比判定标准

@property (nonatomic,assign) NSDecimal          mMuscle ;// 肌肉
@property (nonatomic,assign) double              muscleWeight ;// 肌肉重量
@property (nonatomic,assign) int                muscleLevel ;//肌肉判定标准
@property (nonatomic,assign) double              muscleWeightMax ;// 肌肉最大重量
@property (nonatomic,assign) double              muscleWeightMin ;// 肌肉最小重量

@property (nonatomic,assign) NSDecimal          mBone ;// 骨骼肌
@property (nonatomic,assign) double              boneMuscleWeight ;// 骨骼肌
@property (nonatomic,assign) int                boneMuscleLevel ;//骨骼肌判定标准
@property (nonatomic,assign) double              boneMuscleWeightMax ;// 骨骼肌正常范围上限
@property (nonatomic,assign) double              boneMuscleWeightMin ;// 骨骼肌正常范围下限

@property (nonatomic,assign) double              waterWeight ;// 细胞总水
@property (nonatomic,assign) double              waterWeightMax ;// 细胞总水正常范围上限
@property (nonatomic,assign) double              waterWeightMin ;// 细胞总水正常范围下限
@property (nonatomic,assign) NSDecimal          mWater ;// 水分
@property (nonatomic,assign) double              waterPercentage ;// 水分率
@property (nonatomic,assign) int                waterLevel ;//水分判定标准

@property (nonatomic,assign) double              proteinWeight ;// 蛋白质重量
@property (nonatomic,assign) double              proteinWeightMax ;// 蛋白质最大重量
@property (nonatomic,assign) double              proteinWeightMin ;// 蛋白质最小重量
@property (nonatomic,assign) int                proteinLevel ;//蛋白质判定标准

@property (nonatomic,assign) double              boneWeight ;// 骨质重
@property (nonatomic,assign) int                boneLevel ;//骨重判定标准
@property (nonatomic,assign) double              boneWeightMax ;// 骨质重正常范围上限
@property (nonatomic,assign) double              boneWeightMin ;// 骨质重正常范围下限



@property (nonatomic,copy  ) NSString     *     createTime ;//检测时间
@property (nonatomic,assign) NSDecimal          mCalorie ;// 脂肪量
*/
@end

/*
 weightLevel  1偏瘦2正常3偏胖4偏胖5超重6超重      1低 2正常  3456 高
 fatPercentage level  1正常2低3高
 fatweightlevel  1正常2低3高

 bmi  1低  2正常3高4高
 内脂  1正常2超标3高
 蛋白质(P)/骨骼肌(boneMuscle)/骨量(boneWeight)/水分(waterWieghtLevel)/肌肉(Muscle)  1正常 else低
 */


