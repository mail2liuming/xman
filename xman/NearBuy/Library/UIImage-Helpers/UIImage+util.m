#import "UIImage+util.h"

@implementation UIImage (util)

- (UIImage *)limitImgWithLen:(int)maxlen{
    CGSize s=self.size;
    CGSize reSize;
    
    float radio=s.width/s.height;
    
    bool isWidthMax=false;
    float max=0;
    if(s.width>=s.height){
        isWidthMax=true;
        max=s.width;
    }
    else{
        isWidthMax=false;
        max=s.height;
    }
    
    if(max>maxlen){
        float targetWidth;
        float targetHeight;
        if(isWidthMax){
            targetWidth=maxlen;
            targetHeight=maxlen/radio;
        }
        else{
            targetHeight=maxlen;
            targetWidth=maxlen*radio;
        }
        
        reSize=CGSizeMake(targetWidth, targetHeight);
        
    }
    else{
        reSize=s;
    }
    UIImage *resizeImg =[self resizedImage:reSize interpolationQuality: kCGInterpolationHigh];
    return resizeImg;
}


@end