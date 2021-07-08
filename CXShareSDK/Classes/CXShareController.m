//
//  CXShareController.m
//  Pods
//
//  Created by wshaolin on 2018/5/16.
//

#import "CXShareController.h"
#import <MessageUI/MessageUI.h>
#import "CXShareUtils.h"
#import "CXShareSDKLib.h"
#import "CXShareContentModel.h"
#import <CXUIKit/CXUIKit.h>

@interface CXShareController () <MFMessageComposeViewControllerDelegate> {
    CXShareChannel _shareChannel;
}

@end

@implementation CXShareController

- (instancetype)init{
    if(self = [super init]){
        [NSNotificationCenter addObserver:self
                                   action:@selector(applicationDidBecomeActiveNotification:)
                                     name:UIApplicationDidBecomeActiveNotification];
    }
    
    return self;
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification{
    if(!_shareChannel){
        return;
    }
    
    [self finishShareWithState:CXShareStateCancelled];
}

- (void)dealloc{
    [NSNotificationCenter removeObserver:self];
}

- (void)shareContent:(CXShareContentModel *)content toChannel:(CXShareChannel)shareChannel{
    if(!(content && content.isValidData)){
        CXShareShowAlert(nil, @"缺少分享数据");
        [self finishShareWithState:CXShareStateFailed shareChannel:shareChannel];
        return;
    }
    
    _shareChannel = shareChannel;
    
    if([shareChannel isEqualToString:CXShareChannelQQ]){
        [self shareToQQWithContent:content];
    }else if([shareChannel isEqualToString:CXShareChannelQQZone]){
        [self shareToQQZoneWithContent:content];
    }else if([shareChannel isEqualToString:CXShareChannelWeChatSession]){
        [self shareToWeChatSessionWithContent:content];
    }else if([shareChannel isEqualToString:CXShareChannelWeChatTimeLine]){
        [self shareToWeChatTimeLineWithContent:content];
    }else if([shareChannel isEqualToString:CXShareChannelAliSceneSession]){
        [self shareToAliSceneSessionWithContent:content];
    }else if([shareChannel isEqualToString:CXShareChannelAliSceneTimeLine]){
        [self shareToAliSceneTimeLineWithContent:content];
    }else if([shareChannel isEqualToString:CXShareChannelWeibo]){
        [self shareToSinaWeiboWithContent:content];
    }else if([shareChannel isEqualToString:CXShareChannelSMS]){
        [self shareToSMSWithContent:content];
    }else{
        CXShareShowAlert(nil, @"未知分享渠道");
        [self finishShareWithState:CXShareStateFailed shareChannel:shareChannel];
    }
}

- (void)shareToQQWithContent:(CXShareContentModel *)content{
    [self shareToQQPlatformWithContent:content channel:CXShareChannelQQ];
}

- (void)shareToQQZoneWithContent:(CXShareContentModel *)content{
    if(CX_SHARE_QQ_APP_INSTALLED){
        [self shareToQQPlatformWithContent:content channel:CXShareChannelQQZone];
    }else{
        CXShareShowAlert(nil, @"没有安装QQ客户端");
        [self finishShareWithState:CXShareStateFailed shareChannel:CXShareChannelQQZone];
    }
}

- (void)shareToQQPlatformWithContent:(CXShareContentModel *)content channel:(CXShareChannel)channel{
#ifdef CX_SHARE_AVAILABLE_QQ
    void (^CXShareSDKShareToQQBlock)(NSData *) = ^(NSData *imageData){
        QQApiObject *qqShareObject = nil;
        if([content onlyImageShare]){
            qqShareObject = [QQApiImageObject objectWithData:imageData
                                            previewImageData:imageData
                                                       title:content.title
                                                 description:content.content];
        }else if([CXStringUtil isHTTPURL:content.videoURL]){
            qqShareObject = [QQApiVideoObject objectWithURL:[NSURL URLWithString:content.videoURL]
                                                      title:content.title
                                                description:content.content
                                           previewImageData:imageData];
        }else{
            qqShareObject = [QQApiNewsObject objectWithURL:[NSURL URLWithString:content.shareURL]
                                                     title:content.title
                                               description:content.content
                                           previewImageURL:[NSURL URLWithString:content.imageURL]];
        }
        
        SendMessageToQQReq *request = [SendMessageToQQReq reqWithContent:qqShareObject];
        QQApiSendResultCode resultCode;
        if([channel isEqualToString:CXShareChannelQQ]){
            resultCode = [QQApiInterface sendReq:request];
        }else{
            resultCode = [QQApiInterface SendReqToQZone:request];
        }
        
        if(resultCode != EQQAPISENDSUCESS && resultCode != EQQAPIAPPSHAREASYNC){
            [self finishShareWithState:CXShareStateFailed];
        }
    };
    
    // 如果是纯图片分享，但是又没有image，说明是使用imageUrl作为纯图片分享
    // 因此需要异步先下载图片，不能使用同步，否则阻塞主线程
    if(content.image){
        NSData *imageData = UIImageJPEGRepresentation(content.image, 1.0);
        CXShareSDKShareToQQBlock(imageData);
    }else{
        [self downloadShareImage:content completion:^(UIImage *image, NSData *data) {
            CXShareSDKShareToQQBlock(data);
        }];
    }
#endif
}

- (void)shareToWeChatSessionWithContent:(CXShareContentModel *)content{
    if(CX_SHARE_WECHAT_APP_INSTALLED){
        [self shareToWeChatPlatformWithContent:content channel:CXShareChannelWeChatSession];
    }else{
        CXShareShowAlert(nil, @"没有安装微信客户端");
        [self finishShareWithState:CXShareStateFailed shareChannel:CXShareChannelWeChatSession];
    }
}

- (void)shareToWeChatTimeLineWithContent:(CXShareContentModel *)content{
    if(CX_SHARE_WECHAT_APP_INSTALLED){
        [self shareToWeChatPlatformWithContent:content channel:CXShareChannelWeChatTimeLine];
    }else{
        CXShareShowAlert(nil, @"没有安装微信客户端");
        [self finishShareWithState:CXShareStateFailed shareChannel:CXShareChannelWeChatTimeLine];
    }
}

- (void)shareToWeChatPlatformWithContent:(CXShareContentModel *)content channel:(CXShareChannel)channel{
#ifdef CX_SHARE_AVAILABLE_WECHAT
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.scene = [channel isEqualToString:CXShareChannelWeChatSession] ? WXSceneSession : WXSceneTimeline;
    
    WXMediaMessage *message = [WXMediaMessage message];
    if(![content onlyImageShare]){
        message.title = content.title;
        message.description = content.content;
        
        if([CXStringUtil isHTTPURL:content.shareURL]){
            WXWebpageObject *webpageObject = [WXWebpageObject object];
            webpageObject.webpageUrl = content.shareURL;
            message.mediaObject = webpageObject;
        }else if([CXStringUtil isHTTPURL:content.videoURL]){
            WXVideoObject *videoObject = [WXVideoObject object];
            videoObject.videoUrl = content.videoURL;
            videoObject.videoLowBandUrl = content.videoURL;
            message.mediaObject = videoObject;
        }
    }
    
    void (^CXShareSDKSendWXRequestBlock)(BaseReq *) = ^(BaseReq *request){
        [WXApi sendReq:req completion:^(BOOL success) {
            if(success){
                return;
            }
            
            // 打开微信失败
            [self finishShareWithState:CXShareStateFailed];
        }];
    };
    
    void (^CXShareSDKShareToWeChatBlock)(NSData *) = ^(NSData *imageData){
        if(imageData){
            if([content onlyImageShare]){
                WXImageObject *imageObj = [WXImageObject object];
                imageObj.imageData = imageData;
                message.mediaObject = imageObj;
            }else if(imageData.length < 32 * 1024){
                [message setThumbData:imageData];
            }
        }
        
        req.message = message;
        CXShareSDKSendWXRequestBlock(req);
    };
    
    if(content.image){
        NSData *imageData = UIImageJPEGRepresentation(content.image, 1.0);
        CXShareSDKShareToWeChatBlock(imageData);
    }else{
        [self downloadShareImage:content completion:^(UIImage *image, NSData *data) {
            CXShareSDKShareToWeChatBlock(data);
        }];
    }
#endif
}

- (void)shareToAliSceneSessionWithContent:(CXShareContentModel *)content{
    if(CX_SHARE_ALIPAY_APP_INSTALLED){
        [self shareToAliPlatformWithContent:content channel:CXShareChannelAliSceneSession];
    }else{
        CXShareShowAlert(nil, @"没有安装支付宝客户端");
        [self finishShareWithState:CXShareStateFailed shareChannel:CXShareChannelAliSceneSession];
    }
}

- (void)shareToAliSceneTimeLineWithContent:(CXShareContentModel *)content{
    if(CX_SHARE_ALIPAY_APP_INSTALLED){
        [self shareToAliPlatformWithContent:content channel:CXShareChannelAliSceneTimeLine];
    }else{
        CXShareShowAlert(nil, @"没有安装支付宝客户端");
        [self finishShareWithState:CXShareStateFailed shareChannel:CXShareChannelAliSceneTimeLine];
    }
}

- (void)shareToAliPlatformWithContent:(CXShareContentModel *)content channel:(CXShareChannel)channel{
#ifdef CX_SHARE_AVAILABLE_ALIPAY
    APMediaMessage *message = [[APMediaMessage alloc] init];
    if([content onlyImageShare]){
        APShareImageObject *imgObj = [[APShareImageObject alloc] init];
        if(content.image){
            imgObj.imageData = UIImageJPEGRepresentation(content.image, 1.0);
        }else{
            imgObj.imageUrl = content.imageURL;
        }
        message.mediaObject = imgObj;
    }else{
        message.title = content.title;
        message.desc = content.content;
        if(content.image){
            message.thumbData = UIImageJPEGRepresentation(content.image, 1.0);
        }else{
            message.thumbUrl = content.imageURL;
        }
        
        APShareWebObject *webObj = [[APShareWebObject alloc] init];
        webObj.wepageUrl = content.shareURL ?: content.videoURL;
        message.mediaObject = webObj;
    }
    
    APSendMessageToAPReq *request = [[APSendMessageToAPReq alloc] init];
    request.message = message;
    request.scene = [channel isEqualToString:CXShareChannelAliSceneSession] ? APSceneSession : APSceneTimeLine;
    if(![APOpenAPI sendReq:request]){
        [self finishShareWithState:CXShareStateFailed];
    }
#endif
}

- (void)shareToSinaWeiboWithContent:(CXShareContentModel *)content {
    if(!CX_SHARE_WEIBO_APP_INSTALLED){
        CXShareShowAlert(nil, @"没有安装新浪微博客户端");
        [self finishShareWithState:CXShareStateFailed shareChannel:CXShareChannelWeibo];
        return;
    }
    
#ifdef CX_SHARE_AVAILABLE_WEIBO
    void (^CXShareSDKSendWeiboRequestBlock)(WBSendMessageToWeiboRequest *) = ^(WBSendMessageToWeiboRequest *request){
        [WeiboSDK sendRequest:request completion:^(BOOL success) {
            if(success){
                return;
            }
            
            // 打开微博失败
            [self finishShareWithState:CXShareStateFailed];
        }];
    };
    
    WBMessageObject *message = [WBMessageObject message];
    message.text = content.content;
    
    void (^CXShareSDKShareToWeiboBlock)(NSData *) = ^(NSData *imageData){
        if(imageData){
            WBImageObject *webpage = [WBImageObject object];
            webpage.imageData =  imageData;
            message.imageObject = webpage;
        }
        
        if([CXStringUtil isHTTPURL:content.videoURL]){
            WBNewVideoObject *videoObject = [WBNewVideoObject object];
            [videoObject addVideo:[NSURL URLWithString:content.videoURL]];
            message.videoObject = videoObject;
        }
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        CXShareSDKSendWeiboRequestBlock(request);
    };
    
    if(content.image){
        NSData *imageData = UIImageJPEGRepresentation(content.image, 1.0);
        CXShareSDKShareToWeiboBlock(imageData);
    }else{
        [self downloadShareImage:content completion:^(UIImage *image, NSData *data) {
            CXShareSDKShareToWeiboBlock(data);
        }];
    }
#endif
}

- (void)downloadShareImage:(CXShareContentModel *)content completion:(CXImageDownloadCompletionBlock)completion{
    if([CXStringUtil isHTTPURL:content.imageURL]){
        [CXHUD showHUD:@"正在下载图片...."];
        [CXWebImage downloadImageWithURL:content.imageURL completion:^(UIImage *image, NSData *data) {
            if(!data && image){
                data = UIImageJPEGRepresentation(image, 1.0);
            }
            
            if(!data && [content onlyImageShare]){
                [CXHUD showMsg:@"图片下载失败，不能分享"];
                [self finishShareWithState:CXShareStateFailed];
            }else{
                [CXHUD dismiss];
                completion(image, data);
            }
        }];
    }else{
        completion(nil, nil);
    }
}

- (void)shareToSMSWithContent:(CXShareContentModel *)content{
    if([MFMessageComposeViewController canSendText]){
        [self shareToSMSWithRecipients:content.recipients body:[content smsContent]];
    }else{
        CXShareShowAlert(nil, @"此设备不支持发送短信");
        [self finishShareWithState:CXShareStateFailed shareChannel:CXShareChannelSMS];
    }
}

- (void)shareToSMSWithRecipients:(NSArray<NSString *> *)recipients body:(NSString *)body{
    MFMessageComposeViewController *viewController = [[MFMessageComposeViewController alloc] init];
    viewController.recipients = recipients;
    viewController.body = body;
    viewController.messageComposeDelegate = self;
    
    UIViewController *visibleViewController = [[UIApplication sharedApplication] cx_visibleViewController];
    [visibleViewController presentViewController:viewController
                                        animated:YES
                                      completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch(result){
        case MessageComposeResultSent:{
            [self finishShareWithState:CXShareStateSuccess];
        }
            break;
        case MessageComposeResultFailed:{
            [self finishShareWithState:CXShareStateFailed];
        }
            break;
        case MessageComposeResultCancelled:{
            [self finishShareWithState:CXShareStateCancelled];
        }
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)finishShareWithState:(CXShareState)state shareChannel:(CXShareChannel)shareChannel{
    if(self.delegate && [self.delegate respondsToSelector:@selector(shareController:didFinishShareWithState:shareChannel:)]){
        [self.delegate shareController:self didFinishShareWithState:state shareChannel:shareChannel];
    }
    
    _shareChannel = nil;
}

- (void)finishShareWithState:(CXShareState)state{
    [self finishShareWithState:state shareChannel:_shareChannel];
}

- (void)handleShareResp:(id)resp{
    if(!_shareChannel){
        return;
    }
    
    int code = [self shareRespStatusCode:resp];
    
    /** QQ好友和QQ空间分享取消result值是@"-4", 分享成功result值是@"0"，其他的result值记为失败 */
    /** 微信好友和微信朋友圈分享取消result值是-2，分享成功result值是0，其他的result值记为失败 */
    /** 支付宝好友和支付宝生活圈分享取消result值是-2，分享成功result值是0，其他的result值记为失败 */
    if(code == 0){
        // 分享成功
        [self finishShareWithState:CXShareStateSuccess];
    }else if(code == -2 || code == -4){
        // SendMessageToWXResp(微信)的errCode=-4表示'授权失败'
        // SendMessageToQQResp(QQ)的result=-2表示'该群不在自己的群列表里面'
        // APSendMessageToAPResp(支付宝)的errCode=-4表示'授权失败'
        // 因此都需要加类名判断
        NSString *className = NSStringFromClass([resp class]);
        if(code == -2 && ([className isEqualToString:@"SendMessageToWXResp"] ||
                          [className isEqualToString:@"APSendMessageToAPResp"])){
            // 微信好友、微信朋友圈、支付宝好友、支付宝生活圈分享取消
            [self finishShareWithState:CXShareStateCancelled];
        }else if(code == -4 && [className isEqualToString:@"SendMessageToQQResp"]){
            // QQ、QQ空间分享取消
            [self finishShareWithState:CXShareStateCancelled];
        }else{
            [self finishShareWithState:CXShareStateFailed];
        }
    }else{
        // 分享失败
        [self finishShareWithState:CXShareStateFailed];
    }
}

- (int)shareRespStatusCode:(id)resp{
    int code = -1;
    if([resp respondsToSelector:@selector(errCode)]){
        // 微信和支付宝
        code = (int)[resp performSelector:@selector(errCode)];
    }else if ([resp respondsToSelector:@selector(statusCode)]){
        // 微博
        code = (int)[resp performSelector:@selector(statusCode)];
    }else if([resp respondsToSelector:@selector(result)]){
        // QQ
        NSString *result = [resp performSelector:@selector(result)];
        if(result){
            code = result.intValue;
        }
    }
    
    return code;
}

@end
