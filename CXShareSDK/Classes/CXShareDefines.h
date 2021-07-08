//
//  CXShareDefines.h
//  Pods
//
//  Created by wshaolin on 2018/6/30.
//

#ifndef CXShareDefines_h
#define CXShareDefines_h

#import <CXUIKit/CXUIKit.h>

#if defined(__cplusplus)
#define CX_SHARE_EXTERN   extern "C"
#else
#define CX_SHARE_EXTERN   extern
#endif

#define CX_SHARE_IMAGE(name) CX_POD_IMAGE(name, @"CXShareSDK")

#endif /* CXShareDefines_h */
