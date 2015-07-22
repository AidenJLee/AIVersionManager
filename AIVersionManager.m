//
//  AIVersionManager.m
//  motel
//
//  Created by aidenjlee on 2015. 3. 13..
//  Copyright (c) 2015년 yanolja. All rights reserved.
//

#import "AIVersionManager.h"

@interface AIVersionManager () {
    NSString *strAlertTitle;
    NSString *strAlertMessage;
    NSString *strAlertCancelTitle;
    NSString *strAlertOtherTitle;
}

@property (nonatomic, strong) NSString *strStoreURL;
@property (nonatomic, strong) NSString *strStoreVersion;

@property (nonatomic, strong) VersionObject *vObjectBundle;
@property (nonatomic, strong) VersionObject *vObjectStore;

@end


@implementation AIVersionManager

// Auto Checking - non block method
+ (void)automaticCheckForUpdate {
    
    [VersionChecker automaticCheckForUpdateWithHandler:^(NSString *bundleVersion, NSString *storeVersion, NSString *storeURL, NSString *releaseNotes) {
        
        // 비교 : 결과 값은 greater, equal, less 로 나옴.
        VersionObject *vObjectBundle    = [[VersionObject alloc] initWithVersionString:bundleVersion];
        VersionObject *vObjectStore     = [[VersionObject alloc] initWithVersionString:storeVersion];
        
        VersionObjectCompareType vType = [vObjectBundle compareToVersionString:vObjectStore.absoluteString];
        
        // 버전이 낮을 때
        if (vType == VOCompareTypeLess) {
            
            NSString *strTitleFormat = NSLocalizedString(@"Version %@ Now Available", @"Update alert title. %@ = version number");
            NSString *strMessageFormat = NSLocalizedString(@"New in this version:\n%@", @"Update alert text. %@ = release notes");
            NSString *strCancelTitleFormat = nil;
            
            // 메이저, 마이너 일 때는 강제 업데이트 / 마이크로 일 때만 업데이트 권유 임
            if ([vObjectBundle.strMajor integerValue] < [vObjectStore.strMajor integerValue] ||
                [vObjectBundle.strMinor integerValue] < [vObjectStore.strMinor integerValue]) {
                strCancelTitleFormat = nil;
            } else if ([vObjectBundle.strMicro integerValue] < [vObjectStore.strMicro integerValue]) {
                strCancelTitleFormat = NSLocalizedString(@"Not Now", @"Update alert Cancel button.");
            }
            
            [UIAlertView showWithTitle:[NSString stringWithFormat:strTitleFormat, storeVersion]
                               message:[NSString stringWithFormat:strMessageFormat, releaseNotes]
                     cancelButtonTitle:strCancelTitleFormat
                     otherButtonTitles:@[NSLocalizedString(@"Update", @"Update alert Other button.")]
                              tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  
                                  if (alertView.cancelButtonIndex != buttonIndex) {
                                      // Update : Store로 이동
                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:storeURL]];
                                  }
                                  
                              }];
            
        }
        
    }];
    
}

// Manual checking - block method
- (id)initWithStoreURL:(NSString *)strURL storeVersionString:(NSString *)versionString {
    
    self = [super init];
    if (self) {
        self.strStoreURL = strURL;
        self.strStoreVersion = versionString;
        self.vObjectBundle = [[VersionObject alloc] initWithVersionString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
        self.vObjectStore = [[VersionObject alloc] initWithVersionString:self.strStoreVersion];
        
        strAlertTitle       = NSLocalizedString(@"알림", @"Update alert title.");
        strAlertMessage     = NSLocalizedString(@"새로운 %@ 업데이트 버전이 있습니다.", @"Update alert message.");
        strAlertCancelTitle = NSLocalizedString(@"취소", @"Update alert cancel button title.");
        strAlertOtherTitle  = NSLocalizedString(@"설치하러가기", @"Update alert other button title. %@ = version number");
    }
    return self;
    
}

- (void)customCheckForUpdateWithCompleteHandler:(versionManagerCompleteHandler)completeHandler {
    
    // 버전 비교
    // 비교 : 결과 값은 greater, equal, less 로 나옴.
    VersionObjectCompareType vType = [self.vObjectBundle compareToVersionString:self.strStoreVersion];
    
    // 버전이 낮을 때
    if (vType == VOCompareTypeLess) {
        
        // 메이저, 마이너 일 때는 강제 업데이트 / 마이크로 일 때만 업데이트 권유 임
        if ([self.vObjectBundle.strMajor integerValue] < [self.vObjectStore.strMajor integerValue] ||
            [self.vObjectBundle.strMinor integerValue] < [self.vObjectStore.strMinor integerValue]) {
            [self forceUpdateAlert];
        } else if ([self.vObjectBundle.strMicro integerValue] < [self.vObjectStore.strMicro integerValue]) {
            [self updateAlertWithCompleteHandler:completeHandler];
        }
        
    } else {
        completeHandler(YES);
    }
    
}

- (void)forceUpdateAlert {
    
    [UIAlertView showWithTitle:strAlertTitle
                       message:[NSString stringWithFormat:strAlertMessage, self.strStoreVersion]
             cancelButtonTitle:nil
             otherButtonTitles:@[strAlertOtherTitle] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                 if (alertView.cancelButtonIndex != buttonIndex) {
                     // Update : Store로 이동
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.strStoreURL]];
                 }
             }];
    
}

- (void)updateAlertWithCompleteHandler:(versionManagerCompleteHandler)completeHandler {
    
    [UIAlertView showWithTitle:strAlertTitle
                       message:[NSString stringWithFormat:strAlertMessage, self.strStoreVersion]
             cancelButtonTitle:strAlertCancelTitle
             otherButtonTitles:@[strAlertOtherTitle]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          
                          if (alertView.cancelButtonIndex == buttonIndex) {
                              completeHandler(YES);
                          } else {
                              // Update : Store로 이동
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.strStoreURL]];
                          }
                          
                      }];
    
}

@end
