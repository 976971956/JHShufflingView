//
//  JHShufflingView.h
//  JHShuffling
//
//  Created by 江湖 on 2020/7/16.
//  Copyright © 2020 江湖. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol JHShufflingViewDelegate <NSObject>
@optional
//滚动到第几页
- (void)ScrollThePageNumber:(NSInteger)num;
//点击第几页
- (void)ScrollThePageClickNumber:(NSInteger)num;


@end
@interface JHShufflingView : UIView

@property(nonatomic,weak)id<JHShufflingViewDelegate> delegate;

@property(nonatomic,strong) NSMutableArray  * urlImageArray;//图片地址，可以网络图片也可本地图片

@property(nonatomic,assign)CGFloat timeInterval;//定时滚动时间间隔，默认3秒，开启轮播


@property(nonatomic,assign)UIViewContentMode contentMode;//图片显示模式
@property(nonatomic,assign)NSInteger selIndex;//设置当前选中页码

- (void)removeTime;//如不使用定时器可移除即不使用
/**------------------------------------------------------------page配置-------------------------------------------------------------------------------------------------------------*/
@property(nonatomic,assign)BOOL pageHidden;//page是否显示，yes隐藏，No显示

@property(nonatomic,assign)CGRect pageFrame;//page位置

@property(nonatomic,strong)UIColor *pageColor;//默认圆点颜色
@property(nonatomic,strong)UIColor *currentPageColor;//选中圆点颜色

/// 设置page图片
/// @param pageImage 默认图
/// @param currentPageImage 选中图
- (void)setingPageImage:(NSString *)pageImage andCurrentPageImage:(NSString *)currentPageImage;

/**------------------------------------------------------------标题配置-------------------------------------------------------------------------------------------------------------*/
//标题1,在设置图片数组前设置,如不设置即不会显示
@property(nonatomic,assign)CGRect title1Frame;//page位置
//标题2,在设置图片数组前设置，如不设置即不会显示
@property(nonatomic,assign)CGRect title2Frame;//page位置

@end

@interface JHShufflingModel : NSObject
//标题1
@property (nonatomic,copy)NSString *title1;
@property (nonatomic,strong)UIColor *title1Color;
@property (nonatomic,strong)UIFont *title1Font;
//标题2
@property (nonatomic,copy)NSString *title2;
@property (nonatomic,strong)UIColor *title2Color;
@property (nonatomic,strong)UIFont *title2Font;
//图片
@property (nonatomic,copy)NSString *imageUrl;
@end

@interface UIImageView(JHImageView)
#pragma mark -- 下载管理
+ (void)beginDownLoadImageUrl:(NSString *)pathUrl downLoadFinish:(void (^)(NSString *filePath))loadFinish loadFailure:(void  (^)(NSError *error))loadFailure;
@end
