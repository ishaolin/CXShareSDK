//
//  CXSharePanel.m
//  Pods
//
//  Created by wshaolin on 2018/6/30.
//

#import "CXSharePanel.h"
#import "CXSharePanelContentView.h"
#import "CXShareUtils.h"

static inline NSArray<NSArray<CXSharePanelModel *> *> *CXSharePanelDatasFromArray(NSArray<CXSharePanelModel *> *dataArray, NSUInteger subArrayMaxCount){
    if(subArrayMaxCount == 0 || dataArray.count <= subArrayMaxCount){
        return @[dataArray];
    }
    
    NSMutableArray<NSArray<CXSharePanelModel *> *> *tempArray = [NSMutableArray array];
    NSUInteger arrayCount = dataArray.count / subArrayMaxCount;
    NSUInteger remainder = dataArray.count % subArrayMaxCount;
    if(remainder != 0){
        arrayCount ++;
    }
    
    for(NSUInteger index = 0; index < arrayCount; index ++){
        NSArray<CXSharePanelModel *> *subArray = nil;
        if(index == arrayCount - 1 && remainder > 0){
            subArray = [dataArray subarrayWithRange:NSMakeRange(dataArray.count - remainder, remainder)];
        }else{
            subArray = [dataArray subarrayWithRange:NSMakeRange(index * subArrayMaxCount, subArrayMaxCount)];
        }
        
        [tempArray addObject:subArray];
    }
    
    return [tempArray copy];
}

@interface CXSharePanel () <UIScrollViewDelegate, CXSharePanelContentViewDelegate> {
    UIToolbar *_backgroundView;
    NSArray<NSArray<CXSharePanelModel *> *> *_dataModelGroups;
    NSMutableArray<CXSharePanelContentView *> *_contentPageViews;
    
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    UIView *_lineView;
    UIButton *_cancelButton;
    UIView *_maskView;
}

@property (nonatomic, copy) CXSharePanelDidActionBlock actionBlock;
@property (nonatomic, copy) CXSharePanelDidCancelBlock cancelBlock;

@end

@implementation CXSharePanel

- (instancetype)initWithShareDataModel:(CXShareContentModel *)shareDataModel
                           actionBlock:(CXSharePanelDidActionBlock)actionBlock
                           cancelBlock:(CXSharePanelDidCancelBlock)cancelBlock{
    if(!shareDataModel || !shareDataModel.isValidData){
        return nil;
    }
    
    NSMutableArray<CXSharePanelModel *> *panelDatas = [NSMutableArray array];
    [CXEnableShareChannels() enumerateObjectsUsingBlock:^(CXShareChannel  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXSharePanelModel *sharePanelModel = [[CXSharePanelModel alloc] initWithShareChannel:obj actionType:CXSharePanelActionShare];
        sharePanelModel.shareDataModel = shareDataModel;
        [panelDatas addObject:sharePanelModel];
    }];
    
    return [self initWithPanelDatas:panelDatas actionBlock:actionBlock cancelBlock:cancelBlock];
}

- (instancetype)initWithPanelDatas:(NSArray<CXSharePanelModel *> *)panelDatas
                       actionBlock:(CXSharePanelDidActionBlock)actionBlock
                       cancelBlock:(CXSharePanelDidCancelBlock)cancelBlock{
    if(CXArrayIsEmpty(panelDatas)){
        return nil;
    }
    
    if(self = [super initWithFrame:CGRectZero]){
        self.actionBlock = actionBlock;
        self.cancelBlock = cancelBlock;
        
        self.overlayStyle = CXActionPanelOverlayStyleClear;
        self.animationType = CXActionPanelAnimationCustom;
        
        _backgroundView = [[UIToolbar alloc] init];
        _backgroundView.translucent = NO;
        [self addSubview:_backgroundView];
        
        // 最大总列数
        NSUInteger columns = CXSharePanelContentItemMaxColumn();
        _dataModelGroups = CXSharePanelDatasFromArray(panelDatas, columns * 2);
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = _dataModelGroups.count > 1;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _contentPageViews = [NSMutableArray array];
        [_dataModelGroups enumerateObjectsUsingBlock:^(NSArray<CXSharePanelModel *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CXSharePanelContentView *contentPageView = [[CXSharePanelContentView alloc] initWithItemDataModels:obj pageIndex:idx];
            contentPageView.delegate = self;
            [self->_scrollView addSubview:contentPageView];
            [self->_contentPageViews addObject:contentPageView];
        }];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = _dataModelGroups.count;
        _pageControl.hidden = !_scrollView.scrollEnabled;
        _pageControl.pageIndicatorTintColor = CXHexIColor(0xE5E5E5);
        _pageControl.currentPageIndicatorTintColor = CXHexIColor(0x999999);
        [self addSubview:_pageControl];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = CX_PingFangSC_RegularFont(16.0);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:CXHexIColor(0x666666) forState:UIControlStateNormal];
        [_cancelButton cx_setBackgroundColor:CXHexIColor(0xFFFFFF)  forState:UIControlStateNormal];
        [_cancelButton cx_setBackgroundColor:CXHexIColor(0xEEEEEE)  forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(handleActionForCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat safeAreaBottom = [UIScreen mainScreen].cx_safeAreaInsets.bottom;
        if(safeAreaBottom > 0){
            _cancelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, safeAreaBottom - 10.0, 0);
        }
        [self addSubview:_cancelButton];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = CXHexIColor(0xEEEEEE);
        [self addSubview:_lineView];
        
        [self configPanelSizeWithMaxColumn:columns];
    }
    
    return self;
}

- (void)configPanelSizeWithMaxColumn:(NSUInteger)maxColumn{
    NSArray<CXSharePanelModel *> *firstPageDatas = _dataModelGroups.firstObject;
    CGFloat panelHeight = [UIScreen mainScreen].cx_safeAreaInsets.bottom;
    if(firstPageDatas.count > maxColumn){
        panelHeight += 280.0;
    }else{
        panelHeight += 175.0;
    }
    
    panelHeight += _pageControl.isHidden ? 0 : 20.0;
    
    self.panelSize = CGSizeMake(0, panelHeight);
}

- (void)handleActionForCancelButton:(UIButton *)cancelButton{
    [self dismissWithAnimated:YES];
    
    if(self.cancelBlock){
        self.cancelBlock(self, CXSharePanelCancelTypeClickCancel);
    }
}

- (void)handleMaskTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer{
    [self dismissWithAnimated:YES];
    
    if(self.cancelBlock){
        self.cancelBlock(self, CXSharePanelCancelTypeClickMasked);
    }
}

- (void)dismissForRotateScreen{
    [super dismissForRotateScreen];
    
    if(self.cancelBlock){
        self.cancelBlock(self, CXSharePanelCancelTypeRotateScreen);
    }
}

- (void)sharePanelContentView:(CXSharePanelContentView *)contentView didClickItemWithDataModel:(CXSharePanelModel *)itemDataModel{
    if(self.actionBlock){
        self.actionBlock(self, itemDataModel);
    }
    
    [self dismissWithAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _pageControl.currentPage = round(scrollView.contentOffset.x / scrollView.bounds.size.width);
}

- (CXActionAnimationBlock)showAnimationWithSuperView:(UIView *)superView{
    if(!_maskView){
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMaskTapGestureRecognizer:)]];
        [superView addSubview:_maskView];
    }
    
    _maskView.alpha = 0;
    _maskView.frame = superView.bounds;
    
    CGFloat width = CGRectGetWidth(superView.bounds);
    CGFloat height = self.panelSize.height;
    CGFloat x = 0;
    CGFloat y = CGRectGetHeight(superView.bounds);
    CGRect panelFrame = (CGRect){x, y, width, height};
    self.frame = panelFrame;
    
    panelFrame.origin.y -= self.panelSize.height;
    CGRect maskFrame = superView.bounds;
    maskFrame.size.height = panelFrame.origin.y;
    
    return ^{
        self->_maskView.alpha = 1.0;
        self->_maskView.frame = maskFrame;
        self.frame = panelFrame;
    };
}

- (CXActionAnimationBlock)dismissAnimationWithSuperView:(UIView *)superView{
    return ^{
        self->_maskView.alpha = 0;
        self->_maskView.frame = superView.bounds;
        
        CGRect panelFrame = self.frame;
        panelFrame.origin.y = CGRectGetHeight(superView.bounds);
        self.frame = panelFrame;
    };
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _backgroundView.frame = self.bounds;
    
    CGFloat cancelButton_X = 0;
    CGFloat cancelButton_W = CGRectGetWidth(self.bounds);
    CGFloat cancelButton_H = 50.0 + [UIScreen mainScreen].cx_safeAreaInsets.bottom;
    CGFloat cancelButton_Y = CGRectGetHeight(self.bounds) - cancelButton_H;
    _cancelButton.frame = (CGRect){cancelButton_X, cancelButton_Y, cancelButton_W, cancelButton_H};
    
    CGFloat lineView_X = 0;
    CGFloat lineView_W = CGRectGetWidth(self.bounds);
    CGFloat lineView_H = 0.5;
    CGFloat lineView_Y = cancelButton_Y - lineView_H;
    _lineView.frame = (CGRect){lineView_X, lineView_Y, lineView_W, lineView_H};
    
    CGFloat scrollView_X = cancelButton_X;
    CGFloat scrollView_W = cancelButton_W;
    CGFloat scrollView_H = lineView_Y;
    CGFloat scrollView_Y = 0;
    _scrollView.frame = (CGRect){scrollView_X, scrollView_Y, scrollView_W, scrollView_H};
    _scrollView.contentSize = CGSizeMake(scrollView_W * _contentPageViews.count, 0);
    
    [_contentPageViews enumerateObjectsUsingBlock:^(CXSharePanelContentView *contentView, NSUInteger idx, BOOL *stop) {
        CGFloat contentView_X = scrollView_W * idx;
        CGFloat contentView_Y = 0;
        CGFloat contentView_W = scrollView_W;
        CGFloat contentView_H = scrollView_H;
        contentView.frame = (CGRect){contentView_X, contentView_Y, contentView_W, contentView_H};
    }];
    
    CGFloat pageControl_X = 0;
    CGFloat pageControl_H = 20.0;
    CGFloat pageControl_W = self.bounds.size.width;
    CGFloat pageControl_Y = lineView_Y - pageControl_H - 8.0;
    _pageControl.frame = (CGRect){pageControl_X, pageControl_Y, pageControl_W, pageControl_H};
}

@end
