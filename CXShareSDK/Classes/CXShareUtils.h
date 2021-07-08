//
//  CXShareHelper.h
//  Pods
//
//  Created by wshaolin on 2018/5/16.
//

#import "CXShareType.h"

#define CX_SHARE_WECHAT_APP_INSTALLED  [CXShareUtils platformAppInstalled:CXSharePlatformWeChat]
#define CX_SHARE_ALIPAY_APP_INSTALLED  [CXShareUtils platformAppInstalled:CXSharePlatformAlipay]
#define CX_SHARE_QQ_APP_INSTALLED      [CXShareUtils platformAppInstalled:CXSharePlatformQQ]
#define CX_SHARE_WEIBO_APP_INSTALLED   [CXShareUtils platformAppInstalled:CXSharePlatformWeibo]

@class UIImage;

@interface CXShareUtils : NSObject

+ (BOOL)platformAppInstalled:(CXSharePlatform)platform;

@end

CX_SHARE_EXTERN UIImage *CXShareIconFromChannel(CXShareChannel shareChannel);
CX_SHARE_EXTERN NSString *CXShareNameFromChannel(CXShareChannel shareChannel);

CX_SHARE_EXTERN void CXShareShowAlert(NSString *title, NSString *msg);

CX_SHARE_EXTERN BOOL CXShareChannelEnabled(CXShareChannel shareChannel);

CX_SHARE_EXTERN NSArray<CXShareChannel> *CXEnableShareChannels(void);

CX_SHARE_EXTERN UIImage *CXShareMaskImage(CGSize size, UIColor *color, CGFloat alpha, CGFloat cornerRadius);
