//
//  CXSharePanel.h
//  Pods
//
//  Created by wshaolin on 2018/6/30.
//

#import <CXUIKit/CXUIKit.h>
#import "CXSharePanelModel.h"

typedef NS_ENUM(NSUInteger, CXSharePanelCancelType){
    CXSharePanelCancelTypeClickMasked  = 0, // 点击蒙层
    CXSharePanelCancelTypeClickCancel  = 1, // 点击取消按钮
    CXSharePanelCancelTypeRotateScreen = 2  // 旋转屏幕（横竖屏切换）
};

@class CXSharePanel;

typedef void (^CXSharePanelDidCancelBlock)(CXSharePanel *sharePanel, CXSharePanelCancelType cancelType);

typedef void (^CXSharePanelDidActionBlock)(CXSharePanel *sharePanel, CXSharePanelModel *dataModel);

@interface CXSharePanel : CXBaseActionPanel

- (instancetype)initWithShareDataModel:(CXShareContentModel *)shareDataModel
                           actionBlock:(CXSharePanelDidActionBlock)actionBlock
                           cancelBlock:(CXSharePanelDidCancelBlock)cancelBlock;

- (instancetype)initWithPanelDatas:(NSArray<CXSharePanelModel *> *)panelDatas
                       actionBlock:(CXSharePanelDidActionBlock)actionBlock
                       cancelBlock:(CXSharePanelDidCancelBlock)cancelBlock;

@end
