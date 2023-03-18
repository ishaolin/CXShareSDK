//
//  CXShareType.h
//  Pods
//
//  Created by wshaolin on 2018/6/30.
//


#import <Foundation/Foundation.h>
#import "CXShareDefines.h"

typedef NSString *CXShareChannel;
typedef NSString *CXSharePlatform;

CX_SHARE_EXTERN CXShareChannel const CXShareChannelWeChatSession;       // 微信好友
CX_SHARE_EXTERN CXShareChannel const CXShareChannelWeChatTimeLine;      // 微信朋友圈
CX_SHARE_EXTERN CXShareChannel const CXShareChannelAliSceneSession;     // 支付宝好友
CX_SHARE_EXTERN CXShareChannel const CXShareChannelAliSceneTimeLine;    // 支付宝生活圈
CX_SHARE_EXTERN CXShareChannel const CXShareChannelQQ;                  // QQ好友
CX_SHARE_EXTERN CXShareChannel const CXShareChannelQQZone;              // QQ空间
CX_SHARE_EXTERN CXShareChannel const CXShareChannelWeibo;               // 新浪微博
CX_SHARE_EXTERN CXShareChannel const CXShareChannelSMS;                 // 短信

CX_SHARE_EXTERN NSArray<CXShareChannel> *CXAllShareChannels(void);
CX_SHARE_EXTERN BOOL CXShareChannelIsValid(CXShareChannel shareChannel);

CX_SHARE_EXTERN CXSharePlatform const CXSharePlatformWeChat;    // 微信
CX_SHARE_EXTERN CXSharePlatform const CXSharePlatformAlipay;    // 支付宝
CX_SHARE_EXTERN CXSharePlatform const CXSharePlatformQQ;        // QQ
CX_SHARE_EXTERN CXSharePlatform const CXSharePlatformWeibo;     // 新浪微博

typedef NS_ENUM(NSInteger, CXShareState){
    CXShareStateSuccess   = 0, // 成功
    CXShareStateFailed    = 1, // 失败
    CXShareStateCancelled = 2  // 取消
};
