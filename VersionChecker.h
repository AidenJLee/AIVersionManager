//
//  VersionChecker.h
//  pet diary
//
//  Created by aidenjlee on 2015. 3. 13..
//  Copyright (c) 2015년 entist. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^versionCheckerCompletionHandler)(NSString *bundleVersion, NSString *storeVersion, NSString *storeURL, NSString *releaseNotes);

@interface VersionChecker : NSObject

+ (void)automaticCheckForUpdateWithHandler:(versionCheckerCompletionHandler)handler;

@end
