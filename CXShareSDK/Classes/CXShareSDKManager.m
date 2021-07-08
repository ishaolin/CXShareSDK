//
//  CXShareSDKManager.m
//  Pods
//
//  Created by wshaolin on 2018/5/16.
//

#import "CXShareSDKManager.h"
#import "CXShareSDKLib.h"
#import "CXShareController.h"
#import "CXSharePanel.h"
#import "CXShareUtils.h"
#import "CXSharePlatformKey.h"

#ifdef CX_SHARE_AVAILABLE_QQ
#define TencentOAuthDelegate TencentSessionDelegate
#else
#define TencentOAuthDelegate NSObject
#endif

@interface CXShareSDKManager() <CXShareControllerDelegate, TencentOAuthDelegate> {
    CXShareController *_shareController;
#ifdef CX_SHARE_AVAILABLE_QQ
    TencentOAuth *_tencentOAuth;
#endif
}

@property (nonatomic, copy) CXShareSDKManagerCallback callback;
@property (nonatomic, weak) CXSharePanel *sharePanel;

@end

@implementation CXShareSDKManager

+ (instancetype)sharedManager{
    static CXShareSDKManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[CXShareSDKManager alloc] init];
        _manager->_shareController = [[CXShareController alloc] init];
        _manager->_shareController.delegate = _manager;
    });
    
    return _manager;
}

- (void)registerPlatformKeys:(NSArray<CXSharePlatformKey *> *)platformKeys{
    [platformKeys enumerateObjectsUsingBlock:^(CXSharePlatformKey * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
#ifdef CX_SHARE_AVAILABLE_WECHAT
        if([key.platform isEqualToString:CXSharePlatformWeChat]){
            [WXApi registerApp:key.appId universalLink:key.universalLink];
            return;
        }
#endif
        
#ifdef CX_SHARE_AVAILABLE_ALIPAY
        if([key.platform isEqualToString:CXSharePlatformAlipay]){
            [APOpenAPI registerApp:key.appId];
            return;
        }
#endif
        
#ifdef CX_SHARE_AVAILABLE_QQ
        if([key.platform isEqualToString:CXSharePlatformQQ]){
            self->_tencentOAuth = [[TencentOAuth alloc] initWithAppId:key.appId andDelegate:self];
            return;
        }
#endif
        
#ifdef CX_SHARE_AVAILABLE_WEIBO
        if([key.platform isEqualToString:CXSharePlatformWeibo]){
            [WeiboSDK registerApp:key.appId universalLink:key.universalLink];
            return;
        }
#endif
    }];
}

- (void)shareContent:(CXShareContentModel *)content tracker:(CXShareSDKManagerTracker)tracker callback:(CXShareSDKManagerCallback)callback{
    [self shareContent:content inWindow:nil tracker:tracker callback:callback];
}

- (void)shareContent:(CXShareContentModel *)content
            inWindow:(UIWindow *)window
             tracker:(CXShareSDKManagerTracker)tracker
            callback:(CXShareSDKManagerCallback)callback{
    NSArray<CXShareChannel> *shareChannes = CXEnableShareChannels();
    if(CXArrayIsEmpty(shareChannes)){
        return;
    }
    
    NSMutableArray<CXSharePanelModel *> *panelDatas = [NSMutableArray array];
    [shareChannes enumerateObjectsUsingBlock:^(CXShareChannel  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXSharePanelModel *sharePanelModel = [[CXSharePanelModel alloc] initWithShareChannel:obj actionType:CXSharePanelActionShare];
        sharePanelModel.shareDataModel = content;
        [panelDatas addObject:sharePanelModel];
    }];
    
    [self shareWithPanelDatats:[panelDatas copy] inWindow:window tracker:tracker callback:callback];
}

- (void)shareContent:(CXShareContentModel *)content
           toChannel:(CXShareChannel)channel
            callback:(CXShareSDKManagerCallback)callback{
    self.callback = callback;
    [_shareController shareContent:content toChannel:channel];
}

- (void)shareWithPanelDatats:(NSArray<CXSharePanelModel *> *)panelDatas
                     tracker:(CXShareSDKManagerTracker)tracker
                    callback:(CXShareSDKManagerCallback)callback{
    [self shareWithPanelDatats:panelDatas inWindow:nil tracker:tracker callback:callback];
}

- (void)shareWithPanelDatats:(NSArray<CXSharePanelModel *> *)panelDatas
                    inWindow:(UIWindow *)window
                     tracker:(CXShareSDKManagerTracker)tracker
                    callback:(CXShareSDKManagerCallback)callback{
    CXSharePanel *sharePanel = [[CXSharePanel alloc] initWithPanelDatas:panelDatas actionBlock:^(CXSharePanel *sharePanel, CXSharePanelModel *dataModel) {
        !tracker ?: tracker(dataModel);
        if(dataModel.actionType == CXSharePanelActionRefresh){
            return;
        }
        
        self.callback = callback;
        [self->_shareController shareContent:dataModel.shareDataModel toChannel:dataModel.shareChannel];
    } cancelBlock:^(CXSharePanel *sharePanel, CXSharePanelCancelType cancelType) {
        !callback ?: callback(nil, CXShareStateCancelled);
    }];
    
    [sharePanel showInWindow:window];
    self.sharePanel = sharePanel;
}

- (void)dismissSharePanel{
    [self.sharePanel dismissWithAnimated:YES];
}

- (void)onResp:(id)resp{
    [_shareController handleShareResp:resp];
}

- (void)shareController:(CXShareController *)shareController didFinishShareWithState:(CXShareState)state shareChannel:(CXShareChannel)shareChannel{
    !self.callback ?: self.callback(shareChannel, state);
    self.callback = nil;
}

#ifdef CX_SHARE_AVAILABLE_QQ

- (void)tencentDidLogin{
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled{
    
}

- (void)tencentDidNotNetWork{
    
}

#endif

@end
