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
    if([CXStringUtils isValidString:_content]){
        return NO;
    }
    
    if([CXStringUtils isValidString:_title]){
        return NO;
    }
    
    if([CXStringUtils isHTTPURL:_shareURL]){
        return NO;
    }
    
    if([CXStringUtils isHTTPURL:_videoURL]){
        return NO;
    }
    
    return YES;
}

- (BOOL)isValidData{
    if([CXStringUtils isHTTPURL:_shareURL]){
        return YES;
    }
    
    if([CXStringUtils isHTTPURL:_imageURL]){
        return YES;
    }
    
    if([CXStringUtils isHTTPURL:_videoURL]){
        return YES;
    }
    
    if([CXStringUtils isValidString:_title]){
        return YES;
    }
    
    if([CXStringUtils isValidString:_content]){
        return YES;
    }
    
    return _image != nil;
}

- (NSString *)smsContent{
    NSMutableArray<NSString *> *content = [NSMutableArray array];
    if([CXStringUtils isValidString:_title]){
        [content addObject:_title];
    }
    
    if([CXStringUtils isValidString:_content]){
        [content addObject:_content];
    }
    
    if([CXStringUtils isHTTPURL:_shareURL]){
        [content addObject:_shareURL];
    }else if([CXStringUtils isHTTPURL:_videoURL]){
        [content addObject:_videoURL];
    }else if([CXStringUtils isHTTPURL:_imageURL]){
        [content addObject:_imageURL];
    }
    
    return [content componentsJoinedByString:@", "];
}

@end

@implementation CXShareTrackerData

@end
