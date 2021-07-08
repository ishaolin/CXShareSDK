//
//  CXShareController.h
//  Pods
//
//  Created by wshaolin on 2018/5/16.
//

#import "CXShareType.h"

@class CXShareContentModel;
@class CXShareController;

@protocol CXShareControllerDelegate <NSObject>

@optional

- (void)shareController:(CXShareController *)shareController
didFinishShareWithState:(CXShareState)state
           shareChannel:(CXShareChannel)shareChannel;

@end

@interface CXShareController : NSObject

@property (nonatomic, weak) id<CXShareControllerDelegate> delegate;

- (void)shareContent:(CXShareContentModel *)content toChannel:(CXShareChannel)shareChannel;

- (void)handleShareResp:(id)resp;

@end
