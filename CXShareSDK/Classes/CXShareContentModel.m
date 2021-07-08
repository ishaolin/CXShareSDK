//
//  CXShareContentModel.m
//  Pods
//
//  Created by wshaolin on 2018/6/30.
//

#import "CXShareContentModel.h"
#import <CXFoundation/CXFoundation.h>

@implementation CXShareContentModel

- (BOOL)onlyImageShare{
    if([CXStringUtil isValidString:_content]){
        return NO;
    }
    
    if([CXStringUtil isValidString:_title]){
        return NO;
    }
    
    if([CXStringUtil isHTTPURL:_shareURL]){
        return NO;
    }
    
    if([CXStringUtil isHTTPURL:_videoURL]){
        return NO;
    }
    
    return YES;
}

- (BOOL)isValidData{
    if([CXStringUtil isHTTPURL:_shareURL]){
        return YES;
    }
    
    if([CXStringUtil isHTTPURL:_imageURL]){
        return YES;
    }
    
    if([CXStringUtil isHTTPURL:_videoURL]){
        return YES;
    }
    
    if([CXStringUtil isValidString:_title]){
        return YES;
    }
    
    if([CXStringUtil isValidString:_content]){
        return YES;
    }
    
    return _image != nil;
}

- (NSString *)smsContent{
    NSMutableArray<NSString *> *content = [NSMutableArray array];
    if([CXStringUtil isValidString:_title]){
        [content addObject:_title];
    }
    
    if([CXStringUtil isValidString:_content]){
        [content addObject:_content];
    }
    
    if([CXStringUtil isHTTPURL:_shareURL]){
        [content addObject:_shareURL];
    }else if([CXStringUtil isHTTPURL:_videoURL]){
        [content addObject:_videoURL];
    }else if([CXStringUtil isHTTPURL:_imageURL]){
        [content addObject:_imageURL];
    }
    
    return [content componentsJoinedByString:@", "];
}

@end

@implementation CXShareTrackerData

@end
