//
//  AIVersionManager.h
//  motel
//
//  Created by aidenjlee on 2015. 3. 13..
//  Copyright (c) 2015년 yanolja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionObject.h"
#import "VersionChecker.h"
#import "UIAlertView+Blocks.h"


typedef void (^versionManagerCompleteHandler)(BOOL isComplete);

@interface AIVersionManager : NSObject

- (id)initWithStoreURL:(NSString *)strURL storeVersionString:(NSString *)versionString;
- (void)customCheckForUpdateWithCompleteHandler:(versionManagerCompleteHandler)completeHandler;

+ (void)automaticCheckForUpdate;

@end
