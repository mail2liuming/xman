#import <Foundation/Foundation.h>



@interface YooPushRefreshHelper : NSObject
{
    
}

@property(nonatomic,strong)void(^refreshBlock)(void);
@property(nonatomic,retain)UIView*headBackView;
@property(nonatomic,retain)UIView*tipErrView;


-(id)initWithScrollView:(UIScrollView*)sc;
-(id)initWithScrollView:(UIScrollView*)sc withLocalUpdateDateDataPath:(NSString*)path;

-(void)updateLastRefreshTime;


-(void)triggerRefresh;//激发刷新
-(void)completed;//加载完成的时候调用





@end
