//
//  CXShareSDKManager+CXWebViewSupported.m
//  Pods
//
//  Created by wshaolin on 2019/1/29.
//

#import "CXShareSDKManager+CXWebViewSupported.h"
#import <CXFoundation/CXFoundation.h>
#import "CXShareUtils.h"

@implementation CXShareSDKManager (CXWebViewSupported)

- (void)shareWithDictionary:(NSDictionary<NSString *,id> *)dictionary
                   inWindow:(UIWindow *)window
                    tracker:(CXShareSDKManagerTracker)tracker
                   callback:(CXShareSDKManagerCallback)callback{
    if(CXDictionaryIsEmpty(dictionary)){
        return;
    }
    
    NSArray<NSDictionary<NSString *, id> *> *shareData = [dictionary cx_arrayForKey:@"data"];
    if(CXArrayIsEmpty(shareData)){
        CXSharePanelModel *sharePanelModel = [CXSharePanelModel modelWithDictionary:dictionary];
        [self shareContent:sharePanelModel.shareDataModel
                 toChannel:sharePanelModel.shareChannel
                  callback:callback];
    }else{
        NSMutableArray<CXSharePanelModel *> *sharePanelDatas = [NSMutableArray array];
        [shareData enumerateObjectsUsingBlock:^(NSDictionary<NSString *, id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CXSharePanelModel *sharePanelModel = [CXSharePanelModel modelWithDictionary:obj];
            if(CXShareChannelEnabled(sharePanelModel.shareChannel)){
                [sharePanelDatas addObject:sharePanelModel];
            }
        }];
        
        [self shareWithPanelDatats:sharePanelDatas
                          inWindow:window
                           tracker:tracker
                          callback:callback];
    }
}

@end

@implementation CXSharePanelModel (CXWebViewSupported)

+ (CXSharePanelModel *)modelWithDictionary:(NSDictionary<NSString *, id> *)dictionary{
    CXShareChannel shareChannel = [dictionary cx_stringForKey:@"channel"];
    if(CXStringIsEmpty(shareChannel)){
        return nil;
    }
    
    CXSharePanelModel *sharePanelModel = [[CXSharePanelModel alloc] initWithShareChannel:shareChannel actionType:CXSharePanelActionShare];
    CXShareContentModel *shareDataModel = [CXShareContentModel modelWithDictionary:[dictionary cx_dictionaryForKey:@"data"]];
    NSDictionary<NSString *, id> *tracker = [dictionary cx_dictionaryForKey:@"tracker"];
    if(!CXDictionaryIsEmpty(tracker)){
        CXShareTrackerData *trackerData = [[CXShareTrackerData alloc] init];
        trackerData.id = [tracker cx_stringForKey:@"id"];
        trackerData.params = [tracker cx_dictionaryForKey:@"params"];
        shareDataModel.trackerData = trackerData;
    }
    sharePanelModel.shareDataModel = shareDataModel;
    
    return sharePanelModel;
}

@end

@implementation CXShareContentModel (CXWebViewSupported)

+ (CXShareContentModel *)modelWithDictionary:(NSDictionary<NSString *, id> *)dictionary{
    if(CXDictionaryIsEmpty(dictionary)){
        return nil;
    }
    
    CXShareContentModel *model = [[CXShareContentModel alloc] init];
    if([@"image" isEqualToString:[dictionary cx_stringForKey:@"type"]]){
        model.imageURL = [dictionary cx_stringForKey:@"url"];
    }else{
        model.shareURL = [dictionary cx_stringForKey:@"url"];
        model.title = [dictionary cx_stringForKey:@"title"];
        model.content = [dictionary cx_stringForKey:@"content"];
        model.imageURL = [dictionary cx_stringForKey:@"icon"];
    }
    
    return model;
}

@end
