//
//  Authorizer.h
//  Atkritka
//
//  Created by Dmytro Gladkyi on 12/13/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AuthorizerCallBack <NSObject>
-(void) userWasAuthorized:(BOOL) authorized;
@end

@interface Authorizer : NSObject <NSURLConnectionDelegate>
-(void) authorizeUser;
@property id <AuthorizerCallBack> callBackDelegate;
@end
