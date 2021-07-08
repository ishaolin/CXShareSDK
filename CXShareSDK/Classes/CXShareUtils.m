//
//  CXShareHelper.m
//  Pods
//
//  Created by wshaolin on 2018/5/16.
//

#import "CXShareUtils.h"
#import "CXShareSDKLib.h"
#import <MessageUI/MessageUI.h>

@implementation CXShareUtils

+ (BOOL)platformAppInstalled:(CXSharePlatform)platform{
    if([platform isEqualToString:CXSharePlatformWeChat]){
#ifdef CX_SHARE_AVAILABLE_WECHAT
        return [WXApi isWXAppInstalled];
#else
        return NO;
#endif
    }else if([platform isEqualToString:CXSharePlatformAlipay]){
#ifdef CX_SHARE_AVAILABLE_ALIPAY
        return [APOpenAPI isAPAppInstalled];
#else
        return NO;
#endif
    }else if([platform isEqualToString:CXSharePlatformQQ]){
#ifdef CX_SHARE_AVAILABLE_QQ
        return [QQApiInterface isQQInstalled];
#else
        return NO;
#endif
    }else if([platform isEqualToString:CXSharePlatformWeibo]){
#ifdef CX_SHARE_AVAILABLE_WEIBO
        return [WeiboSDK isWeiboAppInstalled];
#else
        return NO;
#endif
    }
    
    return NO;
}

@end

UIImage *CXShareIconFromChannel(CXShareChannel shareChannel){
    if(!shareChannel){
        return nil;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"share_%@", shareChannel];
    return CX_SHARE_IMAGE(imageName);
}

NSString *CXShareNameFromChannel(CXShareChannel shareChannel){
    if(!shareChannel){
        return nil;
    }
    
    static NSDictionary<NSString *, NSString *> *channelNames = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        channelNames = @{CXShareChannelWeChatSession : @"微信",
                         CXShareChannelWeChatTimeLine : @"微信朋友圈",
                         CXShareChannelAliSceneSession : @"支付宝好友",
                         CXShareChannelAliSceneTimeLine : @"生活圈",
                         CXShareChannelQQ : @"QQ",
                         CXShareChannelQQZone : @"QQ空间",
                         CXShareChannelWeibo : @"新浪微博",
                         CXShareChannelSMS : @"短信"};
    });
    
    return channelNames[shareChannel];
}

void CXShareShowAlert(NSString *title, NSString *msg){
    [CXAlertControllerUtils showAlertWithConfigBlock:^(CXAlertControllerConfigModel *config) {
        if(title){
            config.title = title;
            config.message = msg;
        }else{
            config.title = msg;
        }
    } completion:nil];
}

BOOL CXShareChannelEnabled(CXShareChannel shareChannel){
    if(!shareChannel){
        return NO;
    }
    
    if([shareChannel isEqualToString:CXShareChannelWeChatSession] ||
       [shareChannel isEqualToString:CXShareChannelWeChatTimeLine]){
        return CX_SHARE_WECHAT_APP_INSTALLED;
    }else if([shareChannel isEqualToString:CXShareChannelAliSceneSession] ||
             [shareChannel isEqualToString:CXShareChannelAliSceneTimeLine]){
        return CX_SHARE_ALIPAY_APP_INSTALLED;
    }else if([shareChannel isEqualToString:CXShareChannelQQ] ||
             [shareChannel isEqualToString:CXShareChannelQQZone]){
        return CX_SHARE_QQ_APP_INSTALLED;
    }else if([shareChannel isEqualToString:CXShareChannelWeibo]){
        return CX_SHARE_WEIBO_APP_INSTALLED;
    }else if([shareChannel isEqualToString:CXShareChannelSMS]){
        return [MFMessageComposeViewController canSendText];
    }
    
    return NO;
}

NSArray<CXShareChannel> *CXEnableShareChannels(void){
    NSMutableArray<CXShareChannel> *shareChannels = [NSMutableArray array];
    [GLAllShareChannels() enumerateObjectsUsingBlock:^(CXShareChannel  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(CXShareChannelEnabled(obj)){
            [shareChannels addObject:obj];
        }
    }];
    
    return [shareChannels copy];
}

UIImage *CXShareMaskImage(CGSize size, UIColor *color, CGFloat alpha, CGFloat cornerRadius){
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, size}];
    view.backgroundColor = color;
    view.alpha = alpha;
    if(cornerRadius > 0){
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = cornerRadius;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
