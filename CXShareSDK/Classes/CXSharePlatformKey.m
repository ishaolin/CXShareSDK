//
//  CXSharePlatformKey.m
//  Pods
//
//  Created by wshaolin on 2021/7/4.
//

#import "CXSharePlatformKey.h"

@implementation CXSharePlatformKey

- (instancetype)initWithPlatform:(CXSharePlatform)platform
                           appId:(NSString *)appId
                   universalLink:(nullable NSString *)universalLink{
    if(self = [super init]){
        _platform = platform;
        _appId = appId;
        _universalLink = universalLink;
    }
    
    return self;
}

+ (instancetype)keyWithPlatform:(CXSharePlatform)platform
                          appId:(NSString *)appId
                  universalLink:(nullable NSString *)universalLink{
    return [[self alloc] initWithPlatform:platform appId:appId universalLink:universalLink];
}

@end
