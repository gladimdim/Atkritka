//
//  CardsManagementProtocol.h
//  Atkritka
//
//  Created by Dmytro Gladkyi on 12/9/12.
//  Copyright (c) 2012 Dmytro Gladkyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CardsManagementProtocol <NSObject>
-(void) addDummyPostCardsAndUpdateTableView;
-(void) downloadCards:(NSInteger ) pageId;
@end
