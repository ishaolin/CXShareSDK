//
//  CXSharePanelModel.h
//  Pods
//
//  Created by wshaolin on 2018/6/30.
//

#import "CXShareType.h"
#import "CXShareContentModel.h"

typedef NS_ENUM(NSInteger, CXSharePanelActionType) {
    CXSharePanelActionShare,
    CXSharePanelActionRefresh
};

@interface CXSharePanelModel : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) UIImage *icon;
@property (nonatomic, assign, readonly) CGSize iconSize;
@property (nonatomic, strong, readonly) UIImage *highlightedIcon;

@property (nonatomic, copy, readonly) CXShareChannel shareChannel;
@property (nonatomic, assign, readonly) CXSharePanelActionType actionType;

@property (nonatomic, strong) CXShareContentModel *shareDataModel;

- (instancetype)initWithShareChannel:(CXShareChannel)shareChannel
                          actionType:(CXSharePanelActionType)actionType;

@end
