
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>


@interface UIButton (uitl)

@property(assign)NSString*buttonTitle;




-(void)setBackImg:(UIImage*)img;
-(void)setBackImgByImgName:(NSString*)name;

@property(assign) void(^clickAction)(void);

 

+(UIButton*)createNewWithByImgName:(NSString*)imgName;

-(void)raiseClickEvent;

@end


