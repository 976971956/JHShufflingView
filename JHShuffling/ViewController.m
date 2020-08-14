//
//  ViewController.m
//  JHShuffling
//
//  Created by 江湖 on 2020/7/16.
//  Copyright © 2020 江湖. All rights reserved.
//

#import "ViewController.h"
#import "JHShufflingView.h"

@interface ViewController ()<JHShufflingViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSLog(@"%@",path);
    NSMutableArray *imageUrls = [NSMutableArray array];
    JHShufflingModel *model1 = [[JHShufflingModel alloc]init];
    model1.title1 = @"妹子1";
    model1.title1Color = [UIColor redColor];
    model1.title2 = @"妹子1的副标题";
    model1.title2Color = [UIColor greenColor];

    
    JHShufflingModel *model2 = [[JHShufflingModel alloc]init];
    model2.title1 = @"妹子2";
    model2.title1Color = [UIColor redColor];
    model2.title2 = @"妹子2的副标题";
    model2.title2Color = [UIColor greenColor];

    
    JHShufflingModel *model3 = [[JHShufflingModel alloc]init];
    model3.title1 = @"妹子3";
    model3.title1Color = [UIColor redColor];
    model3.title2 = @"妹子3的副标题";
    model3.title2Color = [UIColor greenColor];

    JHShufflingModel *model4 = [[JHShufflingModel alloc]init];
    model4.title1 = @"妹子4";
    model4.title1Color = [UIColor redColor];
    model4.title2 = @"妹子4的副标题";
    model4.title2Color = [UIColor greenColor];

    JHShufflingModel *model5 = [[JHShufflingModel alloc]init];
    model5.title1 = @"妹子5";
    model5.title1Color = [UIColor redColor];
    model5.title2 = @"妹子5的副标题";
    model5.title2Color = [UIColor greenColor];
//    网络图片地址
    https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1595326302959&di=849856fde4e129cff3cbe2ac71eb4a35&imgtype=0&src=http%3A%2F%2F00.minipic.eastday.com%2F20170420%2F20170420105628_ea6da92abc46098d8e03ad2ee55abeb7_9.jpeg
//    http://s.aigei.com/src/img/gif/17/1777ed41381c4b6195f17d92b1b7bc96.gif?imageMogr2/auto-orient/thumbnail/!169x165r/gravity/Center/crop/169x165/quality/85/&e=1735488000&token=P7S2Xpzfz11vAkASLTkfHN7Fw-oOZBecqeJaxypL:Si7QMkzq5RqltQiD6sJpQRIdkP8=
    model1.imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1595326302954&di=abda97b9ee84ff941f79b40532bfe993&imgtype=0&src=http%3A%2F%2F00.minipic.eastday.com%2F20170511%2F20170511132314_6cab43df10415723a8f3bdd9dc5364ed_8.jpeg";
    model2.imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1595326302958&di=7444c33dbed806d4bd160573ffb1b67a&imgtype=0&src=http%3A%2F%2F00.minipic.eastday.com%2F20170511%2F20170511174026_ce78ab94ee63acbcb6990ae044b62b32_12.jpeg";
    model3.imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1595326302953&di=d916159f6a5bd205b5d7f408a87de5af&imgtype=0&src=http%3A%2F%2F00.minipic.eastday.com%2F20170303%2F20170303094555_7851ce3d965701f3201d4df2dde56592_8.jpeg";
    model4.imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1595326302956&di=4fe54e181ee8ed4d390ab3957639e34d&imgtype=0&src=http%3A%2F%2F00.minipic.eastday.com%2F20170221%2F20170221212912_cbff414ccd6113e1d49401b874e438c6_9.jpeg";
    model5.imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1595326302954&di=abda97b9ee84ff941f79b40532bfe993&imgtype=0&src=http%3A%2F%2F00.minipic.eastday.com%2F20170511%2F20170511132314_6cab43df10415723a8f3bdd9dc5364ed_8.jpeg";
    
//    本地图片地址
    model1.imageUrl = @"5809200-a99419bb94924e6d.jpg";
    model2.imageUrl = @"5809200-48dd99da471ffa3f.jpg";
    model3.imageUrl = @"5809200-caf66b935fd00e18.jpg";
    model4.imageUrl = @"5809200-a99419bb94924e6d.jpg";
    model5.imageUrl = @"5809200-736bc3917fe92142.jpg";

//    Gif图片
//    model1.imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1595501155594&di=7e83ad59f20f8feba446f2552c87c482&imgtype=0&src=http%3A%2F%2Fs9.rr.itc.cn%2Fr%2FwapChange%2F20157_28_19%2Fa6ap9m1619282732381.gif";
//    model2.imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1595502521634&di=21e93382d778be018ff81a9edcf23295&imgtype=0&src=http%3A%2F%2Fimgup02.sj88.com%2F2018-10%2F25%2F10%2F15404358656999_3.gif";
//    model3.imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1595502567004&di=95eeb0887276a509d87d22ee142a272b&imgtype=0&src=http%3A%2F%2Fimg01.cztv.com%2F201906%2F26%2F75a7e2026a0780ea606c1f34d4cdd50a.gif";
//    model4.imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1595509078312&di=bef9806ffab6e63b450bd96797abd711&imgtype=0&src=http%3A%2F%2Fuploads.xuexila.com%2Fallimg%2F1606%2F09104H510-4.gif";
//    model5.imageUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1595502661753&di=6119b62342f4cc77cff527d2aa624952&imgtype=0&src=http%3A%2F%2Fs9.rr.itc.cn%2Fr%2FwapChange%2F201612_13_18%2Fa35gff1118759205325.gif";
    [imageUrls addObject:model1];
    [imageUrls addObject:model2];
    [imageUrls addObject:model3];
    [imageUrls addObject:model4];
    [imageUrls addObject:model5];

    CGFloat bili = 1024.0/1536.0;
    int width = 200*bili;//转整数,宽度不能有小数点位,
//    添加自动轮播器
    JHShufflingView *shufflingView = [[JHShufflingView alloc]initWithFrame:CGRectMake(15, 120, width, 200)];
    shufflingView.delegate = self;
    [self.view addSubview:shufflingView];
    shufflingView.contentMode = UIViewContentModeScaleAspectFit;//设置图片显示模式
//    shufflingView.title1Frame = CGRectMake(0, 0, shufflingView.frame.size.width, 20);//设置标题1的frame
//    shufflingView.title2Frame = CGRectMake(0, 30, shufflingView.frame.size.width, 20);//设置标题2的frame
//    shufflingView.pageHidden = YES;//隐藏page
//    shufflingView.pageColor = [UIColor redColor];//设置未选中page圆点颜色
//    shufflingView.currentPageColor = [UIColor yellowColor];//设置选中page圆点颜色
//    [shufflingView setingPageImage:@"shuanglingxing" andCurrentPageImage:@"shuanglingxingSel"];//设置page选中与未选中图片

    shufflingView.timeInterval = 4;//设置定时器时间间隔,不设置默认3秒
    shufflingView.scrollDirType = JHShufflingScrollDir_Left;
    shufflingView.urlImageArray = imageUrls;//设置图片数组
    //    [shufflingView removeTime];
    shufflingView.selIndex = 3;
}

- (void)ScrollThePageNumber:(NSInteger)num{
    
}
- (void)ScrollThePageClickNumber:(NSInteger)num{
    
}
@end
