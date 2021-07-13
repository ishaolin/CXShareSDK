//
//  CXSharePlatformKey.h
//  Pods
//
//  Created by wshaolin on 2021/7/4.
//

#import <Foundation/Foundation.h>
#import "CXShareType.h"

NS_ASSUME_NONNULL_BEGIN

@interface CXSharePlatformKey : NSObject

@property (nonatomic, copy, readonly) CXSharePlatform platform;
@property (nonatomic, copy, readonly) NSString *appId;
@property (nonatomic, copy, readonly, nullable) NSString *universalLink;

- (instancetype)initWithPlatform:(CXSharePlatform)platform
                           appId:(NSString *)appId
                   universalLink:(nullable NSString *)universalLink;

+ (instancetype)keyWithPlatform:(CXSharePlatform)platform
                          appId:(NSString *)appId
                  universalLink:(nullable NSString *)universalLink;
@end

NS_ASSUME_NONNULL_END
