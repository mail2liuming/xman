#import "YooPushRefreshHelper.h"


typedef enum {
    YooPushRefreshHelperStateTypeNormal=0,
    YooPushRefreshHelperStateTypeTriggered=1,
    YooPushRefreshHelperStateTypeLoading=2
} YooPushRefreshHelperStateType;



#define kImgArrow @"grayArrow"
#define kArrowDuration 0.15

@interface YooPushRefreshHelperObj:NSObject
{
    
}
@property(nonatomic,retain)YooPushRefreshHelper*attachHelper;
@property(nonatomic,strong)void(^contentOffsetChangeBlock)(CGPoint);

 
@end


@implementation YooPushRefreshHelperObj
{
 
}
@synthesize attachHelper;



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"]){
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    else if([keyPath isEqualToString:@"frame"]){
        
    }
}


- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if(self.contentOffsetChangeBlock){
        self.contentOffsetChangeBlock(contentOffset);
    }
}



@end



@interface YooPushRefreshHelper()



@property(nonatomic,retain)UIScrollView*attachSC;
@property(nonatomic,retain)UIView*currentBackV;
@property(nonatomic,retain)NSDate*preUpdateDate;

@property(nonatomic,retain)NSString*localUpdateDatePath;//可空
@property(assign)bool markInitPageEnable;

@end

@implementation YooPushRefreshHelper
{

    UIView*headerView;
    
    UIView*headContainerView;
    
    
    UIActivityIndicatorView*actView;
    
    UILabel*lbTime;
    UILabel*lbState;
    
    UIImageView*arrowImgView;
    
    
    YooPushRefreshHelperObj*attachObj;
    
    YooPushRefreshHelperStateType currentState;
    
    NSDateFormatter*myDateFormat;
    
    BOOL markFirstBeenIn;
    
     
}
@synthesize attachSC=_attachSC;
@synthesize refreshBlock;
@synthesize headBackView=_headBackView;
@synthesize tipErrView=_tipErrView;


@synthesize preUpdateDate=_preUpdateDate;
@synthesize localUpdateDatePath=_localUpdateDatePath;


-(void)setHeadBackView:(UIView *)myheadBackView{
    _headBackView=myheadBackView;
    if(self.currentBackV){
        [self.currentBackV removeFromSuperview];
    }
    self.currentBackV=_headBackView;
    self.currentBackV.frame=headerView.bounds;
    [headerView insertSubview:self.currentBackV atIndex:0];
}

-(void)setTipErrView:(UIView *)mytipErrView{
    if(_tipErrView){
        [_tipErrView removeFromSuperview];
    }
    _tipErrView=mytipErrView;
    if(_tipErrView){
        _tipErrView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        _tipErrView.frame=self.attachSC.bounds;
        [self.attachSC addSubview:_tipErrView];
    }
}




-(NSDate*)preUpdateDate{
    if(!_preUpdateDate){
        if(self.localUpdateDatePath){

            NSString*path=[YooPushRefreshHelper createPathByKey:self.localUpdateDatePath];
            NSData *fileData;
            NSString*str=[YooPushRefreshHelper createPath:path];
            fileData=[NSData dataWithContentsOfFile:str];
            id returnObj=[NSKeyedUnarchiver unarchiveObjectWithData:fileData];
            _preUpdateDate=returnObj;
            
            
        }
    }
    return _preUpdateDate;
}

-(id)initWithScrollView:(UIScrollView*)sc withLocalUpdateDateDataPath:(NSString*)path{
    self=[super init];
    if(self){
        bool isPageEnable=sc.pagingEnabled;
        self.markInitPageEnable=isPageEnable;
        
        self.localUpdateDatePath=path;
        markFirstBeenIn=false;
        myDateFormat = [[NSDateFormatter alloc] init];
		[myDateFormat setDateStyle:NSDateFormatterShortStyle];
		[myDateFormat setTimeStyle:NSDateFormatterShortStyle];
		myDateFormat.locale = [NSLocale currentLocale];
        
        currentState=-1;
        attachObj=[[YooPushRefreshHelperObj alloc]init];
        attachObj.attachHelper=self;
        
        self.attachSC=sc;
        
        headerView=[[UIView alloc]initWithFrame:CGRectMake(0,-sc.frame.size.height, sc.frame.size.width, sc.frame.size.height)];
        
        headerView.backgroundColor=[UIColor clearColor];
        
        headContainerView=[[UIView alloc]initWithFrame:headerView.bounds];
        [headerView addSubview:headContainerView];
        
        actView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        actView.hidesWhenStopped=YES;
        
        float midX=sc.frame.size.width/2.;
        actView.frame=CGRectMake(midX-55, sc.frame.size.height-40, actView.frame.size.width, actView.frame.size.height);
        [headContainerView addSubview:actView];
        
        lbState=[[UILabel alloc]initWithFrame:CGRectMake(midX-25, sc.frame.size.height-50, 150, 20)];
        lbState.backgroundColor=[UIColor clearColor];
        lbState.textColor=[UIColor colorWithWhite:0.05 alpha:1];
        lbState.font=[UIFont systemFontOfSize:14];
        [headContainerView addSubview:lbState];
        
        
        
        lbTime=[[UILabel alloc]initWithFrame:CGRectMake(midX-25, sc.frame.size.height-30, 200, 20)];
        lbTime.backgroundColor=[UIColor clearColor];
        lbTime.textColor=[UIColor colorWithWhite:0.3 alpha:1];
        lbTime.font=[UIFont systemFontOfSize:9];
        lbTime.text=@"Last update:";
        [headContainerView addSubview:lbTime];
        
        
        arrowImgView=[[UIImageView alloc]initWithFrame:CGRectMake(midX-55, sc.frame.size.height-48, 18, 32)];
        arrowImgView.image=[UIImage imageNamed:kImgArrow];
        [headContainerView addSubview:arrowImgView];
        
        
        [self setLastUpdatedDate:self.preUpdateDate withWrite:false];
        
        [self switchToNormalState];
        [sc addSubview:headerView];
        
        
        
        __block YooPushRefreshHelper*blockSelf=self;
        
        attachObj.contentOffsetChangeBlock=^(CGPoint p)
        {
            [blockSelf offsetChangeBlock:p];
        };
        
        [sc addObserver:attachObj forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [sc addObserver:attachObj forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        
        
        
        UIView*defBack=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        defBack.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
        self.headBackView=defBack;
        
        
    }
    return self;
}


-(id)initWithScrollView:(UIScrollView*)sc{
    return [self initWithScrollView:sc withLocalUpdateDateDataPath:nil];
}


-(void)normalArrow{
    [UIView animateWithDuration:kArrowDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        CGAffineTransform trans=CGAffineTransformIdentity;
        arrowImgView.transform=trans;
        
    } completion:^(BOOL finished) {
        
    }];
}
-(void)rotateArrow{
    [UIView animateWithDuration:kArrowDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{

        CGAffineTransform trans=CGAffineTransformIdentity;
            trans=CGAffineTransformRotate(trans, M_PI);//是旋转的。
            arrowImgView.transform=trans;

    } completion:^(BOOL finished) {
        
    }];
}




-(void)triggerRefresh{
    [self switchToLoadingState:NO];
}
-(void)completed{
    self.attachSC.pagingEnabled=self.markInitPageEnable;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.attachSC.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);

    } completion:^(BOOL finished) {
        
        
    }];
    
 
    [actView stopAnimating];
    [self switchToNormalState];
}

-(void)updateLastRefreshTime{
    [self setLastUpdatedDate:[NSDate date] withWrite:YES];
}

- (void)dealloc {
    [self.attachSC removeObserver:attachObj forKeyPath:@"contentOffset"];
    [self.attachSC removeObserver:attachObj forKeyPath:@"frame"];
}

- (void)setLastUpdatedDate:(NSDate *)newLastUpdatedDate withWrite:(BOOL)write{
    if(!newLastUpdatedDate){
        lbTime.text = @"Last update:none";
    }else{
        
        NSString*lastString=[self setTimeFormat:newLastUpdatedDate];
        lbTime.text=[NSString stringWithFormat:@"Last update:%@",lastString];
        
    }
    
    if(write){
        self.preUpdateDate=newLastUpdatedDate;
        if(self.localUpdateDatePath){
            NSString*path=[YooPushRefreshHelper createPathByKey:self.localUpdateDatePath];
            NSData *freezeDrid;
            freezeDrid=[NSKeyedArchiver archivedDataWithRootObject:self.preUpdateDate];
            NSString *str =[YooPushRefreshHelper createPath:path];
            bool result=[freezeDrid writeToFile:str atomically:YES];
            if(result){
                
            }
        }
    }
}



+(NSString*)createPathByKey:(NSString*)key{
    NSString*resturnString=[key stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString*resuleS=[NSString stringWithFormat:@"YooPushRefresh%@.plist",resturnString];
    return resuleS;
}

+(NSString*)createPath:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *str = [documentsDirectory stringByAppendingPathComponent:fileName];
    return str;
}


-(NSString*)setTimeFormat:(NSDate*)newDate;
{

    
    NSDate *inputDate=newDate;
    
    NSDate *nowDate=[NSDate date];
    NSCalendar *today=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendar *tagetDay=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents=[today components:NSDayCalendarUnit fromDate:nowDate];
    NSDateComponents *tagetDayComponents=[tagetDay components:NSDayCalendarUnit fromDate:inputDate];
    
    NSTimeInterval time=[nowDate timeIntervalSinceDate:inputDate];
    NSLog(@"time:%f",time);
    
    if (time <60) {
        return @"now";
    }
    else if (time>=60 && time <60*60) {
        int min=time/60;
        return [NSString stringWithFormat:@"%d minites ago",min];
    }
    else if (time>=60*60 && time <60*60*24) {
        if (todayComponents.day==tagetDayComponents.day) {
            NSDateFormatter *outputFormatter=[[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"HH:mm"];
            NSString *timeStr=[outputFormatter stringFromDate:inputDate];

            return [NSString stringWithFormat:@"today %@",timeStr];
        }
        else if (todayComponents.day>tagetDayComponents.day) {
            NSDateFormatter *outputFormatter=[[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *timeStr=[outputFormatter stringFromDate:inputDate];

            return timeStr;
        }
    }
    else  {
        NSDateFormatter *outputFormatter=[[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *timeStr=[outputFormatter stringFromDate:inputDate];

        return timeStr;
    }
    
    return @"";
}




-(void)switchToLoadingState:(BOOL)aa{
    YooPushRefreshHelperStateType myCurrentType=currentState;
    
    if(myCurrentType==YooPushRefreshHelperStateTypeLoading){
        return;
        
    }
    currentState=YooPushRefreshHelperStateTypeLoading;
    
    self.attachSC.pagingEnabled=false;
    
    [actView startAnimating];
    
    CGSize markOldSize=self.attachSC.contentSize;
    if (aa == NO) {
        self.attachSC.contentSize=CGSizeMake(0, 0);
        
    }

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.attachSC.contentInset=UIEdgeInsetsMake(60.0f, 0, 0, 0);
        
    } completion:^(BOOL finished) {
        
        
    }];
    self.attachSC.contentSize=markOldSize;
    
    
    [arrowImgView setHidden:YES];
    [self rotateArrow];
    lbState.text=@"Loading";
    if(self.refreshBlock){
        NSLog(@"refreshBlock");
        self.refreshBlock();
    }
}


-(void)switchToNormalState{
    if(currentState==YooPushRefreshHelperStateTypeNormal){
        return;
    }
  
    [arrowImgView setHidden:false];
    [self normalArrow];
    lbState.text=@"Loading";
    currentState=YooPushRefreshHelperStateTypeNormal;
}

-(void)switchToTriggeredState{
    if(currentState==YooPushRefreshHelperStateTypeTriggered){
        return;
    }
    [self rotateArrow];
    lbState.text=@"Release to refresh";
    currentState=YooPushRefreshHelperStateTypeTriggered;
}



-(void)offsetChangeBlock:(CGPoint)p{
    float y=p.y;
   // NSLog(@"y:%f",y);
    
    if(currentState!=YooPushRefreshHelperStateTypeLoading){
        
        
        if(y<=-60){
            if(self.attachSC.isDragging){
                [self switchToTriggeredState];
            }else{
                [self switchToLoadingState:YES];
            }
            
        }
        else{
            if(!markFirstBeenIn){
                [self setLastUpdatedDate:self.preUpdateDate withWrite:false];
            }
            markFirstBeenIn=YES;
            [self switchToNormalState];

        }
    

    }
    
    
    if(y==0){
        markFirstBeenIn=false;
    }
    
    
  //  NSLog(@"offsetChangeBlock:%f",p.y);
}

 




@end
