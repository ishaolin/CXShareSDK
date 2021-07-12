//
//  CXShareSDKLib.h
//  Pods
//
//  Created by wshaolin on 2018/7/1.
//

#ifndef CXShareSDKLib_h
#define CXShareSDKLib_h

/* QQ分享相关 */
#if __has_include(<TencentOpenAPI/TencentOpenApiUmbrellaHeader.h>)
#import <TencentOpenAPI/TencentOpenApiUmbrellaHeader.h>
#define CX_SHARE_AVAILABLE_QQ
#endif

/* 微博分享相关 */
#if __has_include("WeiboSDK.h")
#import "WeiboSDK.h"
#define CX_SHARE_AVAILABLE_WEIBO
#endif

/* 支付宝分享相关 */
#if __has_include("APOpenAPI.h")
#import "APOpenAPI.h"
#define CX_SHARE_AVAILABLE_ALIPAY
#endif

/* 微信分享相关 */
#if __has_include(<WechatOpenSDK/WXApi.h>)
#import <WechatOpenSDK/WXApi.h>
#define CX_SHARE_AVAILABLE_WECHAT
#endif

#endif /* CXShareSDKLib_h */
