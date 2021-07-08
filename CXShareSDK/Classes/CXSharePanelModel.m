//
//  CXSharePanelModel.m
//  Pods
//
//  Created by wshaolin on 2018/6/30.
//

#import "CXSharePanelModel.h"
#import "CXShareUtils.h"

@implementation CXSharePanelModel

- (instancetype)initWithShareChannel:(CXShareChannel)shareChannel
                          actionType:(CXSharePanelActionType)actionType{
    if(self = [super init]){
        _shareChannel = shareChannel;
        _actionType = actionType;
        _iconSize = CGSizeMake(50.0, 50.0);
        
        _name = CXShareNameFromChannel(shareChannel);
        _icon = CXShareIconFromChannel(shareChannel);
        _highlightedIcon = CXShareMaskImage(_iconSize, CXHexIColor(0x999999), 0.5, _iconSize.width * 0.5);
    }
    
    return self;
}

@end
