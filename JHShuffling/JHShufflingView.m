//
//  JHShufflingView.m
//  JHShuffling
//
//  Created by 江湖 on 2020/7/16.
//  Copyright © 2020 江湖. All rights reserved.
//

#import "JHShufflingView.h"

#define IMG_PATH @"shuffling"


@interface JHShufflingView()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;//滚动视图

@property(nonatomic,strong)UIPageControl *page;//翻页page

@property(nonatomic,strong)NSTimer *timers;//定时器

@property(nonatomic,assign)CGFloat Vwidth;//scrollview宽
@property(nonatomic,assign)CGFloat Vheight;//scrollview高

@property(nonatomic,assign)NSInteger count;//页码记录
@end
@implementation JHShufflingView

//int main(int argc,const char *argv[]){
//    @autoreleasepool {
//        NSLog(@"%@",[NSObject class]);
//        NSLog(@"%@",[JHShufflingView class]);
//        BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
//        BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
//        BOOL res3 = [(id)[JHShufflingView class] isKindOfClass:[JHShufflingView class]];
//        BOOL res4 = [(id)[JHShufflingView class] isMemberOfClass:[JHShufflingView class]];
//        NSLog(@"%d-%d-%d-%d",res1,res2,res3,res4);
//    }
//}
-(instancetype)init{
    if (self = [super init]) {
        [self createUI];

    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.Vwidth = frame.size.width;
        self.Vheight = frame.size.height;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    //    滚动视图
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollView.pagingEnabled = YES;//翻页
    self.scrollView.bounces = YES;//弹性
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];

    
    CGFloat mogi = 15;

    NSLog(@"%f",CGRectGetMaxY(self.scrollView.frame));
//    翻页page
    self.page = [[UIPageControl alloc] initWithFrame:CGRectMake((self.frame.size.width-60)/2, CGRectGetHeight(self.scrollView.frame)  - 30-mogi, 60, 20)];


    self.page.numberOfPages = 3;
    self.page.currentPage = 0;
    self.page.tag = 101;
    self.page.pageIndicatorTintColor = [UIColor redColor];
    self.page.currentPageIndicatorTintColor = [UIColor purpleColor];
    [self.page addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.page];
    //设置定时器时间间隔
    self.timeInterval = 3;
}

- (void)setingPageImage:(NSString *)pageImage andCurrentPageImage:(NSString *)currentPageImage{
    [self.page setValue:[UIImage imageNamed:currentPageImage] forKeyPath:@"_currentPageImage"];

    [self.page setValue:[UIImage imageNamed:pageImage] forKeyPath:@"_pageImage"];
}

#pragma mark -- 创建图片item
- (void)setingShufflinhDatas:(NSMutableArray *)datas IsNetworking:(BOOL)isNet{
    self.page.numberOfPages = datas.count-2;
    for (int i = 0 ; i< datas.count; i++) {
        CGRect imgFrame = CGRectMake(0, self.Vheight*i, self.Vwidth, self.Vheight);
        if (self.scrollDirType == JHShufflingScrollDir_Right|| self.scrollDirType == JHShufflingScrollDir_Left) {
            imgFrame = CGRectMake(self.Vwidth*i, 0, self.Vwidth, self.Vheight);
        }
        UIImageView *img = [[UIImageView alloc] initWithFrame:imgFrame];
        img.contentMode = self.contentMode;
        img.userInteractionEnabled = YES;
        img.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        [img addGestureRecognizer:tap];
        
        [self.scrollView addSubview:img];
        JHShufflingModel *model = datas[i];
        
        UILabel *title1 = [[UILabel alloc]initWithFrame:self.title1Frame];
        if (model.title1) {
            title1.text = model.title1;
        }
        if (model.title1Color) {
            title1.textColor = model.title1Color;
        }
        if (model.title1Font) {
            title1.font = model.title1Font;
        }
        [img addSubview:title1];
        

        UILabel *title2 = [[UILabel alloc]initWithFrame:self.title2Frame];
        if (model.title2) {
            title2.text = model.title2;
        }
        if (model.title2Color) {
            title2.textColor = model.title2Color;
        }
        if (model.title2Font) {
            title2.font = model.title2Font;
        }
        [img addSubview:title2];

//        如果是网络图片
        NSRange range = [model.imageUrl rangeOfString:@"http"];
        if (range.location != NSNotFound) {
            [UIImageView beginDownLoadImageUrl:model.imageUrl downLoadFinish:^(NSString *filePath) {
//                img.image = [UIImage imageWithContentsOfFile:filePath];
                [img setGifImage:[NSURL fileURLWithPath:filePath]];

            } loadFailure:^(NSError *error) {
                
            }];
        }else{
//            本地图片
            img.image = [UIImage imageNamed:model.imageUrl];
        }

    }

    if (self.scrollDirType == JHShufflingScrollDir_Right||self.scrollDirType == JHShufflingScrollDir_Left) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);//初始页面
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*datas.count,self.scrollView.frame.size.height);//设置内容大小
        self.count = 1;
    }else{
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.frame.size.height);//初始页面
        self.scrollView.contentSize = CGSizeMake(self.Vwidth,self.Vheight*datas.count);//设置内容大小
        self.count = 1;
    }

}

-(void)pageClick:(UIPageControl *)page{
    
}
//定时器任务
- (void)runTime{
    if (self.scrollDirType == JHShufflingScrollDir_Right||self.scrollDirType == JHShufflingScrollDir_Bottom) {
        self.count++;
    }else if(self.scrollDirType == JHShufflingScrollDir_Left||self.scrollDirType == JHShufflingScrollDir_Top){
        self.count--;
    }
    if (self.scrollDirType == JHShufflingScrollDir_Right||self.scrollDirType == JHShufflingScrollDir_Left) {
        if (self.count == self.urlImageArray.count-1 ) {
                   self.count = 1;
                   self.page.currentPage = 0;
                   self.scrollView.contentOffset = CGPointMake(0, 0);

                   [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:YES];

               }else if (self.count == 0) {
                   self.count = self.urlImageArray.count-2;
                   self.page.currentPage = self.urlImageArray.count-2 ;
                   [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*(self.urlImageArray.count-2), 0) animated:YES];
               }else{
                   self.page.currentPage = self.count-1;
                   [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*(self.count), 0) animated:YES];

               }
               if ([self.delegate respondsToSelector:@selector(ScrollThePageNumber:)]) {
                   [self.delegate ScrollThePageNumber:self.count];
               }

    }else if(self.scrollDirType == JHShufflingScrollDir_Bottom||self.scrollDirType == JHShufflingScrollDir_Top){
        if (self.count == self.urlImageArray.count-1 ) {
            self.count = 1;
            self.page.currentPage = 0;
            self.scrollView.contentOffset = CGPointMake(0, 0);

            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.frame.size.height) animated:YES];

        }else if (self.count == 0) {
            self.count = self.urlImageArray.count-2;
            self.page.currentPage = self.urlImageArray.count-2 ;
            self.scrollView.contentOffset = CGPointMake(0, self.Vheight*(self.urlImageArray.count-1));
            [self.scrollView setContentOffset:CGPointMake(0, self.Vheight*(self.urlImageArray.count-2)) animated:YES];
        }else{
            self.page.currentPage = self.count-1;
            [self.scrollView setContentOffset:CGPointMake(0,self.scrollView.frame.size.height*(self.count)) animated:YES];

        }
        if ([self.delegate respondsToSelector:@selector(ScrollThePageNumber:)]) {
            [self.delegate ScrollThePageNumber:self.count];
        }

    }

}

- (void)beginTime{
    [self.timers setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timeInterval]];
}
- (void)pauseTime{
    [self.timers setFireDate:[NSDate distantFuture]];
}
- (void)removeTime{
    [self pauseTime];
    [self.timers invalidate];
    self.timers = nil;
}
- (void)dealloc{
    [self removeTime];
}
#pragma mark --scrollView代理事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat offsetX = scrollView.contentOffset.x;
//    NSLog(@"%f",offsetX);
}
//在拖动开始时调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
//    NSLog(@"开始：%f",offsetX);
    [self pauseTime];
}
//当滚动视图停止时调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    int num = scrollView.contentOffset.y/(scrollView.frame.size.height);

    if (self.scrollDirType == JHShufflingScrollDir_Right|| self.scrollDirType == JHShufflingScrollDir_Left) {
        num = scrollView.contentOffset.x/(scrollView.frame.size.width);
    }

    self.count = num;
    
    self.page.currentPage = self.count-1;

    if (self.count == self.urlImageArray.count-1 ) {
//        左滑滚到最后一个时，移动到第一个
        self.count = 1;
        self.page.currentPage = 0;
        if (self.scrollDirType == JHShufflingScrollDir_Right|| self.scrollDirType == JHShufflingScrollDir_Left) {
            [self.scrollView setContentOffset:CGPointMake(self.Vwidth, 0) animated:NO];
        }else{
            [self.scrollView setContentOffset:CGPointMake(0, self.Vheight) animated:NO];

        }
    }else if (self.count == 0) {
//        右滑滚到第0个时，移动到self.urlImageArray.count-2个
        self.count = self.urlImageArray.count-2;
        self.page.currentPage = self.urlImageArray.count-2 ;
        if (self.scrollDirType == JHShufflingScrollDir_Right|| self.scrollDirType == JHShufflingScrollDir_Left) {
            [self.scrollView setContentOffset:CGPointMake(self.Vwidth*(self.urlImageArray.count-2), 0) animated:NO];
        }else{
            [self.scrollView setContentOffset:CGPointMake(0, self.Vheight*(self.urlImageArray.count-2)) animated:NO];
        }
    }
//    滚动回调
    if ([self.delegate respondsToSelector:@selector(ScrollThePageNumber:)]) {
        [self.delegate ScrollThePageNumber:self.count];
    }
//    重新开始计时
    [self  beginTime];
}

#pragma mark --图片点击
- (void)imageClick:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(ScrollThePageClickNumber:)]) {
        [self.delegate ScrollThePageClickNumber:tap.view.tag];
    }
}
#pragma mark -set
//设置定时器时间间隔
- (void)setTimeInterval:(CGFloat)timeInterval{
    _timeInterval = timeInterval;
    //图片轮播
    [self removeTime];
    self.timers = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(runTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timers forMode:NSRunLoopCommonModes];
}
//设置图片地址
-(void)setUrlImageArray:(NSMutableArray *)urlImageArray{
    


//    [urlImageArray insertObject:urlImageArray[0] atIndex:urlImageArray.count-1];
    _urlImageArray = urlImageArray;
    if (urlImageArray.count<=1) {
        [self removeTime];
        [self setingShufflinhDatas:_urlImageArray IsNetworking:YES];
        return;
    }
    [_urlImageArray addObject:_urlImageArray[0]];
    [_urlImageArray insertObject:_urlImageArray[_urlImageArray.count-2] atIndex:0];
//    __weak typeof(self) weakSelf = self;

    [self setingShufflinhDatas:_urlImageArray IsNetworking:YES];
}

- (void)setPageFrame:(CGRect)pageFrame{
    _pageFrame = pageFrame;
    self.page.frame = pageFrame;
}
- (void)setPageColor:(UIColor *)pageColor{
    _pageColor = pageColor;
    self.page.pageIndicatorTintColor = pageColor;
    
}
- (void)setCurrentPageColor:(UIColor *)currentPageColor{
    _currentPageColor = currentPageColor;
    self.page.currentPageIndicatorTintColor = currentPageColor;
}
-(void)setPageHidden:(BOOL)pageHidden{
    _pageHidden = pageHidden;
    self.page.hidden = pageHidden;
}
- (void)setSelIndex:(NSInteger)selIndex{
    _selIndex = selIndex;
    self.count = selIndex;
    if (self.scrollDirType == JHShufflingScrollDir_Right||self.scrollDirType == JHShufflingScrollDir_Left) {
        self.scrollView.contentOffset = CGPointMake(self.Vwidth*(selIndex), 0);//初始页面
    }else{
        self.scrollView.contentOffset = CGPointMake(0, self.Vheight*(selIndex));//初始页面
    }
    self.page.currentPage = self.count-1;
    if ([self.delegate respondsToSelector:@selector(ScrollThePageNumber:)]) {
        [self.delegate ScrollThePageNumber:self.count];
    }
}

-(void)setScrollDirType:(JHShufflingScrollDirType)scrollDirType{
    _scrollDirType = scrollDirType;
    if (_scrollDirType == JHShufflingScrollDir_Right) {
        
    }else if(_scrollDirType == JHShufflingScrollDir_Left){
        
    }else if(_scrollDirType == JHShufflingScrollDir_Top){
        
    }else if(_scrollDirType == JHShufflingScrollDir_Bottom){
        
    }
    
}
@end


@implementation JHShufflingModel


@end

@implementation UIImageView(JHImageView)

#pragma mark -- 下载管理
+ (void)beginDownLoadImageUrl:(NSString *)pathUrl downLoadFinish:(void (^)(NSString *filePath))loadFinish loadFailure:(void  (^)(NSError *error))loadFailure{
    
    NSString *imageName = @"123";
       NSArray *arr = [pathUrl componentsSeparatedByString:@"/"];
    for (NSString *objs in arr) {
        NSRange range = [objs rangeOfString:@".gif"];
        NSRange range1 = [objs rangeOfString:@".png"];
        NSRange range2 = [objs rangeOfString:@".jpeg"];
        NSRange range3 = [objs rangeOfString:@".PNG"];
        NSRange range4 = [objs rangeOfString:@".JPEG"];
        NSRange range5 = [objs rangeOfString:@".GIF"];

        if (range.location != NSNotFound||range1.location != NSNotFound||range2.location != NSNotFound||range3.location != NSNotFound||range4.location != NSNotFound||range5.location != NSNotFound) {
            imageName = objs;
        }

    }
       if ([self searchFileDirectory:IMG_PATH filePath:pathUrl]) {
           NSString *lujing = [[self CreateDirectory:IMG_PATH] stringByAppendingPathComponent:imageName];
           loadFinish(lujing);
       }else{
          dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
          dispatch_async(queue, ^{
              // 下载图片
              NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pathUrl]];
              //
              if (imgData) {
                  dispatch_queue_t mainQueue = dispatch_get_main_queue();
                  dispatch_async(mainQueue, ^{
       //                       UIImage *img = [UIImage imageWithData:imgData];
                      NSString *path = [self CreateFileTypeFileData:imgData directory:IMG_PATH fileName:imageName];
                      loadFinish(path);
                  });
              } else {
                  dispatch_queue_t mainQueue = dispatch_get_main_queue();
                  dispatch_async(mainQueue, ^{
                      NSLog(@"图片下载失败");
                  });
              }
          });
       }
}
//查看文件是否已存在
+ (BOOL)searchFileDirectory:(NSString *)dirName filePath:(NSString *)url{
    NSString *fileName ;
    if (url == nil) {
        return NO;
    }
    NSArray *arr = [url componentsSeparatedByString:@"/"];
    if (arr.count>0) {
      fileName = arr.lastObject;
    }
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;

       if (dirName) {
           [self CreateDirectory:dirName];
       }
       
       NSString *filePath;
       if (dirName) {
           filePath = [[path stringByAppendingPathComponent:dirName] stringByAppendingPathComponent:fileName];
       }else{
          filePath = [path stringByAppendingPathComponent:fileName];
       }
       
       //创建目录
       BOOL ret = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
       if (ret) {
           return YES;
       }else{
           return NO;
       }
}
/**
 创建目录
 */
+ (NSString *)CreateDirectory:(NSString *)dirName
{
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;

    NSString *filePath = [path stringByAppendingPathComponent:dirName];
    //创建目录
    BOOL ret = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (ret) {
//        BUGLOG?:NSLog(@"目录已经存在");
    }else{
        ret =  [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
//        BUGLOG?:NSLog(@"目录%@",ret?@"创建成功":@"创建失败");
    }
    return filePath;
}


/**
 创建文件
 
 @param data 数据
 @param dirName 文件的名称
 */
+ (NSString *)CreateFileTypeFileData:(NSData *)data directory:(NSString *)dirName fileName:(NSString *)fileName
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;;

    if (dirName) {
        [self CreateDirectory:dirName];
    }
    
    NSString *filePath;
    if (dirName) {
        filePath = [[path stringByAppendingPathComponent:dirName] stringByAppendingPathComponent:fileName];
        
//        当缓存数据大于20
        NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[path stringByAppendingPathComponent:dirName] error:nil];
        if (array.count>20) {
            BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:[[path stringByAppendingPathComponent:dirName] stringByAppendingPathComponent:array[1]] error:nil];
            NSLog(@"文件%@",ret?@"删除成功":@"删除失败");
//            删除所有
//            for (NSString *obj in array) {
//                if ([NSStringFromClass(obj.class) isEqualToString:@"__NSCFString"]) {
//                    BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:[[path stringByAppendingPathComponent:dirName] stringByAppendingPathComponent:obj] error:nil];
//                    BUGLOG?:NSLog(@"文件%@",ret?@"删除成功":@"删除失败");
//                }
//                BUGLOG?:NSLog(@"%@",NSStringFromClass(obj.class));
//            }
        }
    }else{
       filePath = [path stringByAppendingPathComponent:fileName];
    }

    //创建目录
    BOOL ret = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (ret) {
        NSLog(@"文件已经存在，更新数据");
        [data writeToFile:filePath atomically:YES];
    }else{
        ret =  [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
        NSLog(@"文件%@：%@",fileName,ret?@"创建成功":@"创建失败");
    }
    return filePath;
}


#pragma mark -- 加载网络图片
- (void)sd_imageWithURL_PathUrl:(NSString *)pathUrl pleaseHold:(NSString *)pleaseHold{
    __weak typeof(self) weakSelf = self;
    NSMutableString *imageName = [NSMutableString stringWithString:@"123.png"];
    NSArray *arr = [pathUrl componentsSeparatedByString:@"/"];
   if (arr.count>0) {
     imageName = [NSMutableString stringWithString:arr.lastObject];
   }
     NSRange range = [imageName rangeOfString:@".gif"];
    if (range.location != NSNotFound) {
        [imageName deleteCharactersInRange:range];
    }
    
    if ([UIImageView searchFileDirectory:IMG_PATH filePath:pathUrl]) {
        NSString *lujing = [[UIImageView CreateDirectory:IMG_PATH] stringByAppendingPathComponent:imageName];
        if (range.location != NSNotFound) {
//            [self setGifImage:[NSURL fileURLWithPath:lujing]];
        }else{
            weakSelf.image = [UIImage imageWithContentsOfFile:lujing];
        }
        

    }else{
       dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
       dispatch_async(queue, ^{
           // 下载图片
           NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pathUrl]];
           //
           if (imgData) {
               dispatch_queue_t mainQueue = dispatch_get_main_queue();
               dispatch_async(mainQueue, ^{
    //                       UIImage *img = [UIImage imageWithData:imgData];
                   NSString *path = [UIImageView CreateFileTypeFileData:imgData directory:IMG_PATH fileName:imageName];
                   if (range.location != NSNotFound) {
//                        [weakSelf setGifImage:[NSURL fileURLWithPath:path]];

                   }else{
                       weakSelf.image = [UIImage imageWithContentsOfFile:path];

                   }
                   
               });
           } else {
               dispatch_queue_t mainQueue = dispatch_get_main_queue();
               dispatch_async(mainQueue, ^{
                   weakSelf.image = [UIImage imageNamed:pleaseHold];
                   NSLog(@"图片下载失败");
               });
           }
       });
    }
}
//解析gif文件数据的方法 block中会将解析的数据传递出来
-(void)getGifImageWithUrk:(NSURL *)url returnData:(void(^)(NSArray<UIImage *> * imageArray, NSArray<NSNumber *>*timeArray,CGFloat totalTime, NSArray<NSNumber *>* widths,NSArray<NSNumber *>* heights))dataBlock{
    //通过文件的url来将gif文件读取为图片数据引用
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    //获取gif文件里图片的个数
    size_t count = CGImageSourceGetCount(source);
    //定义一个变量记录gif播放一轮的时间
    float allTime=0;
    //存放全部图片
    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    //存放每一帧播放的时间
    NSMutableArray * timeArray = [[NSMutableArray alloc]init];
    //存放每张图片的宽度 （一般在一个gif文件里，全部图片尺寸都会一样）
    NSMutableArray * widthArray = [[NSMutableArray alloc]init];
    //存放每张图片的高度
    NSMutableArray * heightArray = [[NSMutableArray alloc]init];
    //遍历
    for (size_t i=0; i<count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        [imageArray addObject:(__bridge UIImage *)(image)];
        CGImageRelease(image);
        //获取图片信息
        NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
        CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
        [widthArray addObject:[NSNumber numberWithFloat:width]];
        [heightArray addObject:[NSNumber numberWithFloat:height]];
        NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
        allTime+=time;
        [timeArray addObject:[NSNumber numberWithFloat:time]];
    }
    dataBlock(imageArray,timeArray,allTime,widthArray,heightArray);
}

//为UIImageView加入一个设置gif图内容的方法：
-(void)setGifImage:(NSURL *)imageUrl{
    __weak id __self = self;
    [self getGifImageWithUrk:imageUrl returnData:^(NSArray<UIImage *> *imageArray, NSArray<NSNumber *> *timeArray, CGFloat totalTime, NSArray<NSNumber *> *widths, NSArray<NSNumber *> *heights) {
        //加入帧动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        NSMutableArray * times = [[NSMutableArray alloc]init];
        float currentTime = 0;
        //设置每一帧的时间占比
        for (int i=0; i<imageArray.count; i++) {
            [times addObject:[NSNumber numberWithFloat:currentTime/totalTime]];
            currentTime+=[timeArray[i] floatValue];
        }
        [animation setKeyTimes:times];
        [animation setValues:imageArray];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        //设置循环
        animation.repeatCount= MAXFLOAT;
        //设置播放总时长
        animation.duration = totalTime;
        //Layer层加入
        [[(UIImageView *)__self layer]addAnimation:animation forKey:@"gifAnimation"];
    }];
}
@end
