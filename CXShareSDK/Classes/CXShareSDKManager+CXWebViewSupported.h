//
//  CXShareSDKManager+CXWebViewSupported.h
//  Pods
//
//  Created by wshaolin on 2019/1/29.
//

#import "CXShareSDKManager.h"
#import "CXSharePanelModel.h"
#import "CXShareContentModel.h"

@interface CXShareSDKManager (CXWebViewSupported)

- (void)shareWithDictionary:(NSDictionary<NSString *, id> *)dictionary
                   inWindow:(UIWindow *)window
                    tracker:(CXShareSDKManagerTracker)tracker
                   callback:(CXShareSDKManagerCallback)callback;

@end

@interface CXSharePanelModel (CXWebViewSupported)

+ (CXSharePanelModel *)modelWithDictionary:(NSDictionary<NSString *, id> *)dictionary;

@end

@interface CXShareContentModel (CXWebViewSupported)

+ (CXShareContentModel *)modelWithDictionary:(NSDictionary<NSString *, id> *)dictionary;

@end
