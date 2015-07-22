//
//  VersionObject.h
//  motel
//
//  Created by aidenjlee on 2015. 2. 11..
//  Copyright (c) 2015년 yanolja. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    VOCompareTypeNone    = 0,
    VOCompareTypeLess    = 1,
    VOCompareTypeEqual   = 2,
    VOCompareTypeGreater = 3
} VersionObjectCompareType;

@interface VersionObject : NSObject

@property (strong, nonatomic) NSString *strMajor;
@property (strong, nonatomic) NSString *strMinor;
@property (strong, nonatomic) NSString *strMicro;

@property (strong, nonatomic) NSString *absoluteString;
@property (strong, nonatomic) NSString *strDescription;

- (id)initWithVersionString:(NSString *)versinSrting;
- (VersionObjectCompareType )compareToVersionString:(NSString *)versionString;

@end
