//
//  VersionObject.m
//  motel
//
//  Created by aidenjlee on 2015. 2. 11..
//  Copyright (c) 2015년 yanolja. All rights reserved.
//

#import "VersionObject.h"

@interface VersionObject ()

@end


@implementation VersionObject

- (id)initWithVersionString:(NSString *)versinSrting {
    
    self = [super init];
    if (self) {
        
        self.absoluteString = versinSrting;
        self.strDescription = @"";
        
        NSArray *arrVersions = [self.absoluteString componentsSeparatedByString:@"."];
        
        // Version 정보는 세자리라고 고정
        switch ([arrVersions count]) {
            case 3:
                self.strMicro = arrVersions[2];
                
            case 2:
                self.strMinor = arrVersions[1];
                
            case 1:
                self.strMajor = arrVersions[0];
                break;
                
            default:
                @throw NSInvalidArgumentException;
        }
        
        return self;
        
    }
    
    return nil;
    
}


#pragma mark -
#pragma mark Comparison

- (VersionObjectCompareType )compareToVersionString:(NSString *)versionString {
    
    NSComparisonResult order = [self.absoluteString compare:versionString options:NSNumericSearch];
    
    if (order == NSOrderedSame) {
        self.strDescription = @"equal";
        return VOCompareTypeEqual;
    }
    else if (order == NSOrderedDescending) {
        self.strDescription = @"greater";
        return VOCompareTypeGreater;
    }
    else if (order == NSOrderedAscending) {
        self.strDescription = @"less";
        return VOCompareTypeLess;
    }
    
    self.strDescription = @"none";
    return VOCompareTypeNone;
    
}

@end
