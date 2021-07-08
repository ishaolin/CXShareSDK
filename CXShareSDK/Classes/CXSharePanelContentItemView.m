//
//  CXSharePanelContentItemView.m
//  Pods
//
//  Created by wshaolin on 2018/6/30.
//

#import "CXSharePanelContentItemView.h"
#import "CXSharePanelModel.h"
#import <CXUIKit/CXUIKit.h>

@interface CXSharePanelContentItemView () {
    UIButton *_iconView;
    UILabel *_nameLabel;
}

@end

@implementation CXSharePanelContentItemView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _iconView = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconView.userInteractionEnabled = NO;
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = CX_PingFangSC_RegularFont(12.0);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = CXHexIColor(0x333333);
        
        [self addSubview:_iconView];
        [self addSubview:_nameLabel];
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    _iconView.highlighted = highlighted;
    _nameLabel.textColor = CXHexIColor(highlighted ? 0x999999 : 0x333333);
}

- (void)setDataModel:(CXSharePanelModel *)dataModel{
    _dataModel = dataModel;
    
    [_iconView setBackgroundImage:dataModel.icon forState:UIControlStateNormal];
    [_iconView setBackgroundImage:dataModel.icon forState:UIControlStateHighlighted];
    [_iconView setImage:dataModel.highlightedIcon forState:UIControlStateHighlighted];
    _nameLabel.text = dataModel.name;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat iconView_W = _dataModel.iconSize.width;
    CGFloat iconView_H = _dataModel.iconSize.height;
    CGFloat iconView_Y = 0;
    CGFloat iconView_X = (CGRectGetWidth(self.bounds) - iconView_W) * 0.5;
    _iconView.frame = (CGRect){iconView_X, iconView_Y, iconView_W, iconView_H};
    [_iconView cx_roundedCornerRadii:iconView_W * 0.5];
    
    CGFloat nameLabel_X = 0;
    CGFloat nameLabel_W = CGRectGetWidth(self.bounds);
    CGFloat nameLabel_H = _nameLabel.font.lineHeight;
    CGFloat nameLabel_Y = CGRectGetHeight(self.bounds) - nameLabel_H;
    _nameLabel.frame = (CGRect){nameLabel_X, nameLabel_Y, nameLabel_W, nameLabel_H};
}

@end
