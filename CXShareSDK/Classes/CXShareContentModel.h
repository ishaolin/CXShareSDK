//
//  CXShareContentModel.h
//  Pods
//
//  Created by wshaolin on 2018/6/30.
//

#import <Foundation/Foundation.h>
#import "CXShareDefines.h"

@class UIImage;
@class CXShareTrackerData;

@interface CXShareContentModel : NSObject

@property (nonatomic, copy) NSString *shareURL; // 分享地址
@property (nonatomic, copy) NSString *imageURL; // 分享图片URL
@property (nonatomic, copy) NSString *title;    // 分享标题
@property (nonatomic, copy) NSString *content;  // 分享内容
@property (nonatomic, copy) NSString *videoURL; // 分享视频的URL

@property (nonatomic, strong) UIImage *image;   // 分享的图片（纯图片分享）

@property (nonatomic, copy) NSArray<NSString *> *recipients; // 短信分享的接收人
@property (nonatomic, strong) CXShareTrackerData *trackerData; // 埋点数据

/**
 * 判断内容是否纯图片分享，判断依据：url、title、text为空（nil或者""），imageUrl或者image非空
 *
 * @return YES: 纯图片分享, NO: 非纯图片分享
 */
- (BOOL)onlyImageShare;

/**
 * 判断分享数据是否有效，如果所有属性是否为空（nil或者""）
 *
 * @return YES:有效，允许分享，NO:无效，不允许分享，弹框提示
 */
- (BOOL)isValidData;

/**
 * 根据当前的分享内容拼接短信分享的内容
 *
 * @return 短信分享的内容
 */
- (NSString *)smsContent;

@end

@interface CXShareTrackerData : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) NSDictionary<NSString *, id> *params;

@end
