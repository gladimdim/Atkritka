//
//  Authorizer.h
//  Atkritka
//
//  Created by Dmytro Gladkyi on 12/13/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Authorizer : NSObject <NSURLConnectionDelegate>
-(void) authorizeUser:(NSString *) username password:(NSString *) password blockCallBack:(void(^)(BOOL authorized)) block;
//-(void) authorizeUser:(void(^)(BOOL authorized)) block;
@property BOOL reauthorize;
@end
