//
//  CXSharePanelContentView.m
//  Pods
//
//  Created by wshaolin on 2018/6/30.
//

#import "CXSharePanelContentView.h"
#import "CXSharePanelContentItemView.h"

@interface CXSharePanelContentView () {
    NSMutableArray<CXSharePanelContentItemView *> *_itemViews;
    NSUInteger _pageIndex;
}

@end

@implementation CXSharePanelContentView

- (instancetype)initWithItemDataModels:(NSArray<CXSharePanelModel *> *)itemDataModels pageIndex:(NSUInteger)pageIndex{
    if(self = [super initWithFrame:CGRectZero]){
        _itemViews = [NSMutableArray array];
        _pageIndex = pageIndex;
        
        [itemDataModels enumerateObjectsUsingBlock:^(CXSharePanelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CXSharePanelContentItemView *itemView = [[CXSharePanelContentItemView alloc] init];
            itemView.dataModel = obj;
            [itemView addTarget:self action:@selector(handleActionForItemView:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:itemView];
            [self->_itemViews addObject:itemView];
        }];
    }
    
    return self;
}

- (void)handleActionForItemView:(CXSharePanelContentItemView *)itemView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(sharePanelContentView:didClickItemWithDataModel:)]){
        [self.delegate sharePanelContentView:self didClickItemWithDataModel:itemView.dataModel];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSUInteger maxColumn = CXSharePanelContentItemMaxColumn();
    NSUInteger rows = _itemViews.count / maxColumn;
    if(_itemViews.count % maxColumn != 0){
        rows ++;
    }
    
    CGFloat itemView_W = 70.0;  // 宽
    CGFloat itemView_H = 80.0;  // 高
    CGFloat itemView_T = 25.0;  // 顶部间距
    CGFloat itemView_X1 = 0;    // 左右侧间距（满行时）
    CGFloat itemView_M1 = 0;    // 渠道之间的间距（满行时）
    if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)){
        itemView_X1 = 12.0;
    }else{
        itemView_X1 = 34.0;
    }
    
    itemView_M1 = (self.bounds.size.width - itemView_X1 * 2 - itemView_W * maxColumn) / (maxColumn - 1);
    
    if(rows == 1 && _pageIndex == 0 && _itemViews.count != maxColumn){ // 只有一行，且不满一行
        CGFloat itemView_Y = itemView_T;
        CGFloat itemView_M = (self.bounds.size.width - itemView_W * _itemViews.count) / (_itemViews.count + 1);
        
        for(NSUInteger column = 0; column < _itemViews.count; column ++){
            CGFloat itemView_X = itemView_M + (itemView_M + itemView_W) * column;
            CXSharePanelContentItemView *itemView = _itemViews[column];
            itemView.frame = (CGRect){itemView_X, itemView_Y, itemView_W, itemView_H};
        }
        
        return;
    }
    
    for(NSUInteger row = 0; row < rows; row ++){
        CGFloat itemView_Y = itemView_H * row + itemView_T * (row + 1);
        
        // 每一行的有效列数
        NSUInteger _columns = _itemViews.count;
        if(_itemViews.count > maxColumn){
            _columns = maxColumn;
            if(row == rows - 1 && _itemViews.count % maxColumn != 0){
                _columns = _itemViews.count % maxColumn;
            }
        }
        
        for(NSUInteger column = 0; column < _columns; column ++){
            CGFloat itemView_X = itemView_X1 + (itemView_M1 + itemView_W) * column;
            NSUInteger index = row * maxColumn + column;
            CXSharePanelContentItemView *itemView = _itemViews[index];
            itemView.frame = (CGRect){itemView_X, itemView_Y, itemView_W, itemView_H};
        }
    }
}

@end

NSUInteger CXSharePanelContentItemMaxColumn(void){
    if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)){
        return 4;
    }
    
    return 6;
}
