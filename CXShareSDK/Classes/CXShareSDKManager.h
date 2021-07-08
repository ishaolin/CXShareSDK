//
//  CXShareSDKManager.h
//  Pods
//
//  Created by wshaolin on 2018/5/16.
//

#import "CXShareType.h"

@class CXShareContentModel;
@class CXSharePanelModel;
@class CXSharePlatformKey;
@class UIWindow;

typedef void(^CXShareSDKManagerCallback)(CXShareChannel shareChannel, CXShareState state);
typedef void(^CXShareSDKManagerTracker)(CXSharePanelModel *dataModel);

@interface CXShareSDKManager : NSObject

+ (instancetype)sharedManager;

// 注册分享平台
- (void)registerPlatformKeys:(NSArray<CXSharePlatformKey *> *)platformKeys;

// 面板分享，各分享渠道的分享内容相同
- (void)shareContent:(CXShareContentModel *)content
             tracker:(CXShareSDKManagerTracker)tracker
            callback:(CXShareSDKManagerCallback)callback;

- (void)shareContent:(CXShareContentModel *)content
            inWindow:(UIWindow *)window
             tracker:(CXShareSDKManagerTracker)tracker
            callback:(CXShareSDKManagerCallback)callback;

// 单渠道分享
- (void)shareContent:(CXShareContentModel *)content
           toChannel:(CXShareChannel)channel
            callback:(CXShareSDKManagerCallback)callback;

// 面板分享，各分享渠道的分享内容可以配置不同
- (void)shareWithPanelDatats:(NSArray<CXSharePanelModel *> *)panelDatas
                     tracker:(CXShareSDKManagerTracker)tracker
                    callback:(CXShareSDKManagerCallback)callback;

- (void)shareWithPanelDatats:(NSArray<CXSharePanelModel *> *)panelDatas
                    inWindow:(UIWindow *)window
                     tracker:(CXShareSDKManagerTracker)tracker
                    callback:(CXShareSDKManagerCallback)callback;

- (void)dismissSharePanel;

- (void)onResp:(id)resp;

@end
