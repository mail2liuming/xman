

#import "UIImage+Base64.h"



@implementation UIImage(base64)


-(NSString*)base64Value{
    NSData *imageData = UIImageJPEGRepresentation(self, 0.2);
    NSString*encodedString = [imageData base64EncodingWithLineLength:0];
    return encodedString;
}





@end
