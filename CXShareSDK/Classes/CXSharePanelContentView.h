//
//  CXSharePanelContentView.h
//  Pods
//
//  Created by wshaolin on 2018/6/30.
//

#import <UIKit/UIKit.h>
#import "CXShareDefines.h"

@class CXSharePanelContentView;
@class CXSharePanelModel;

@protocol CXSharePanelContentViewDelegate <NSObject>

@optional

- (void)sharePanelContentView:(CXSharePanelContentView *)contentView didClickItemWithDataModel:(CXSharePanelModel *)itemDataModel;

@end

@interface CXSharePanelContentView : UIView

@property (nonatomic, weak) id<CXSharePanelContentViewDelegate> delegate;

- (instancetype)initWithItemDataModels:(NSArray<CXSharePanelModel *> *)itemDataModels pageIndex:(NSUInteger)pageIndex;

@end

CX_SHARE_EXTERN NSUInteger CXSharePanelContentItemMaxColumn(void);
