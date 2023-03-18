//
//  CXShareChannel.m
//  Pods
//
//  Created by wshaolin on 2018/7/1.
//

#import "CXShareType.h"

CXShareChannel const CXShareChannelWeChatSession = @"wechat";
CXShareChannel const CXShareChannelWeChatTimeLine = @"wechat_timeline";
CXShareChannel const CXShareChannelAliSceneSession = @"alipay";
CXShareChannel const CXShareChannelAliSceneTimeLine = @"alipay_timeline";
CXShareChannel const CXShareChannelQQ = @"qq";
CXShareChannel const CXShareChannelQQZone = @"qq_zone";
CXShareChannel const CXShareChannelWeibo = @"sina_weibo";
CXShareChannel const CXShareChannelSMS = @"sms";

CXSharePlatform const CXSharePlatformWeChat = @"wechat";
CXSharePlatform const CXSharePlatformAlipay = @"alipay";
CXSharePlatform const CXSharePlatformQQ = @"qq";
CXSharePlatform const CXSharePlatformWeibo = @"weibo";

NSArray<CXShareChannel> *CXAllShareChannels(void){
    static NSArray<CXShareChannel> *allShareChannels = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allShareChannels = @[CXShareChannelWeChatSession,
                             CXShareChannelWeChatTimeLine,
                             CXShareChannelAliSceneSession,
                             CXShareChannelAliSceneTimeLine,
                             CXShareChannelQQ,
                             CXShareChannelQQZone,
                             CXShareChannelWeibo,
                             CXShareChannelSMS];
    });
    return allShareChannels;
}

BOOL CXShareChannelIsValid(CXShareChannel shareChannel){
    if(!shareChannel){
        return NO;
    }
    
    return [CXAllShareChannels() containsObject:shareChannel];
}
