
#import "UIButton+util.h"


static char clickActionChar;




@implementation  UIButton (uitl)


 

@dynamic buttonTitle;
@dynamic clickAction;

+(UIButton*)createNewWithByImgName:(NSString*)imgName{
    UIButton*btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackImgByImgName:imgName];
    return btn;
}



-(NSString*)buttonTitle{
    NSString*text=self.titleLabel.text;
    return text;
}

-(void)setButtonTitle:(NSString *)buttonTitle{
    [self setTitle:buttonTitle forState:UIControlStateNormal];
}



-(void)setBackImg:(UIImage*)img{
    [self setBackgroundImage:img forState:UIControlStateNormal];
}
-(void)setBackImgByImgName:(NSString*)name{
    [self setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}


-(void)setClickAction:(void (^)(void))clickAction{
    [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self,&clickActionChar,clickAction,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(void(^)(void))clickAction{
    void(^action)(void)=objc_getAssociatedObject(self,&clickActionChar);
    if(!action){
        action=nil;
        objc_setAssociatedObject(self,&clickActionChar,action,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return action;
}


-(void)raiseClickEvent{
    if(self.clickAction){
        self.clickAction();
    }
}


//-------------------------------------------------------------------------------------------


-(void)btnClick{
    if(self.clickAction){
        self.clickAction();
    }
}

@end
