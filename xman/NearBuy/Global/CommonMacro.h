//
//  CommonMacro.m
//  LNGaosutong
//
//  Created by 罗 建镇 on 15/3/4.
//  Copyright (c) 2015年 URoad. All rights reserved.
//

#import <Foundation/Foundation.h>

//程序版本
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define DEVICE_IS_IPHONE_4 ([UIScreen mainScreen].bounds.size.height == 480)

#define DEVICE_IS_IPHONE_5 ([UIScreen mainScreen].bounds.size.height == 568)

#define DEVICE_IS_IPHONE_6 ([UIScreen mainScreen].bounds.size.height ==667)

#define DEVICE_IS_IPHONE_6PLUS ([UIScreen mainScreen].bounds.size.height ==736)

#define kTabBarHeight 60

#define KEY_WINDOW [UIApplication sharedApplication].keyWindow

//-----------------------导航堆栈方法-------------------//
#define MAIN_NAVI_CONTROLLER [Base sharedInstance].currentNavi
#define PUSH_CONTROLLER(__X) [[Base sharedInstance].currentNavi pushViewController:__X animated:YES]
#define POP_CONTROLLER [[Base sharedInstance].currentNavi popViewControllerAnimated:YES]

/**
 *  向前返回几个页面
 *
 *  @param __X 需要返回的页面的个数，即回退几个
 *
 *  @return 
 */
#define POP_CONTROLLER_BY_BACKINDEX(__X) [[Base sharedInstance].currentNavi popBackControllerByBackIndex:__X]
//-----------------------导航堆栈方法-------------------//


#define SYSTEM_VERSION_EARLY_THAN_7_0 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
#define SYSTEM_VERSION_LATER_THAN_7_0 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define SYSTEM_VERSION_LATER_THAN_8_0 ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)

//主屏幕高度和宽度
#define UIScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIScreenWidth [UIScreen mainScreen].bounds.size.width

//手机号合理性检查正则表达式
#define MOBILE_PHONE_NUM_REGEX @"^((13[0-9])|(15[^4,\\D])|(18[0-1,5-9]))\\d{8}$"


#undef	RGB
#define RGB(R,G,B)		[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#undef RGBA
#define RGBA(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]



//------定义一些字体大小------//
//单位为像素
#define CELL_TITLE_FONT_PIX 25
#define CELL_CONTENT_FONT_PIX 21
#define CELL_TIME_FONT_PIX 16
#define CELL_STACK_FONT_PIX 18
#define CELL_ADDRESS_FONT_PIX 16
//------

#undef FONT
#define FONT(__X) [UIFont systemFontOfSize:__X]

#undef FONT_PIX
#define FONT_PIX(__X) [UIFont systemFontOfSize:__X*72/96]

#undef FONT_SIZE_BY_PIX
#define FONT_SIZE_BY_PIX(__X) __X*72/96

#define UI_NAVIBAR_COLOR RGB(69,158,204)
#define UI_INPUT_LAYER_COLOR RGB(196,196,196)

//单例
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

//--------------------第三方注册的一些key--------------------------//
//--------------------------加载指示器-----------------------------------------


//#define SHOW_LOADING_MESSAGE(__T,__V) [DejalActivityView activityViewForView:__V withLabel:__T];
#define SHOW_LOADING_MESSAGE(__T,__V) [[LoadingView sharedInstance]showInView:__V];
#define DISMISS_LOADING [[LoadingView sharedInstance]stopAnimation];
//
//#define DISMISS_LOADING [SVProgressHUD dismiss]
//
//#define SHOW_LOADING_PROGRESS(__X,__Y) [SVProgressHUD showProgress:__X status:__Y]
//
//#define SHOW_SUCCESS_MESSAGE(__X) [SVProgressHUD showSuccessWithStatus:__X]
//
//#define SHOW_ERROR_MESSAGE(__X) [SVProgressHUD showErrorWithStatus:__X]

//--------------------------加载指示器-----------------------------------------

#define LOAD_XIB_CLASS( __X ) [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass( [ __X class] ) owner:nil options:nil] objectAtIndex:0]

typedef void (^LoadServerDataFinishedBlock) (id result,BOOL success);

typedef void (^LoadServerDataFinishedWithRetBlock) (id result,BOOL success,NSInteger ret);



#define SAFE_STRING(__X) ([__X isKindOfClass:[NSNull class]]||__X == nil)?@"":__X
#define SAFE_FLOAT(__X) ([__X isKindOfClass:[NSNull class]]||__X == nil)? 0:[__X floatValue]
//拨打电话
#define CALL( __X ) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",__X]]]


//判断用户是否已经登录
#define HAS_LOGIN ([AccountManager sharedInstance].currentUser?YES:NO)

#define LOGOUT_NOTIFICATION_POST @"LOGOUT_NOTIFICATION_POST_SERVER"
#define LOGIN_NOTIFICATION_POST @"LOGIN_NOTIFICATION_POST_SERVER"

//从父视图移除
#define REMOVE_FROM_SUPERVIEW(__X) __X.superview==nil?:[__X removeFromSuperview]

#define LOADDATAERRORCOMMON @"Please check your internet connection"
#define GPSUPDATENOTIFICATION @"GPSUPDATENOTIFICATION"

#define kKeyChainSaveAccountService @"com.NearBuy.keychainaccountpwd"

typedef NS_ENUM(NSInteger,FUNCTIONCODE) {
    NORMAL_FUNCTION,
    MY_CURRENT_FUNCTION,
    MY_EXPIRED_FUNCTION,
    MY_WITHDRAWN_FUNCTION,
    FAVOURITES_FUNCTION
};


typedef NS_ENUM(NSInteger,FooterType) {
    Footer_Normal_AddFavi,
    Footer_Normal_RemoveFavi,
    Footer_Current,
    Footer_Expired,
    Footer_Withdrawn
};

