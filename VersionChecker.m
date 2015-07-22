//
//  VersionChecker.m
//  pet diary
//
//  Created by aidenjlee on 2015. 3. 13..
//  Copyright (c) 2015년 entist. All rights reserved.
//

#import "VersionChecker.h"

@implementation VersionChecker

+ (void)automaticCheckForUpdateWithHandler:(versionCheckerCompletionHandler)handler {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSString *iTunesURL = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@&country=%@&lang=%@",
                                  [[NSBundle mainBundle] bundleIdentifier],
                                  [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode],
                                  [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]];
        NSData *dataAppInfo = [NSData dataWithContentsOfURL:[NSURL URLWithString:iTunesURL]];
        
        if (dataAppInfo) {
            
            NSError *error = nil;
            NSDictionary *dicAppInfo = [NSJSONSerialization JSONObjectWithData:dataAppInfo options:NSJSONReadingMutableContainers error:&error];
            
            if (!error){
                
                if (dicAppInfo[@"results"]) {
                    
                    NSDictionary *dicResult = dicAppInfo[@"results"][0];
                    
                    NSString *strStoreURL = dicResult[@"trackViewUrl"];
                    NSString *strReleaseNotes = dicResult[@"releaseNotes"];
                    
                    NSString *strStoreVersion = dicResult[@"version"];
                    NSString *strBundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                    if (strBundleVersion) {
                        strBundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
                    }
                    
                    if (strStoreURL) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            handler(strBundleVersion, strStoreVersion, strStoreURL, strReleaseNotes);
                        });
                    }
                    
                } else {
                    NSLog(@"don`t contain 'result' from iTunes API");
                }
            } else {
                NSLog(@"Error parsing for NSJSONSerialization : %@", error);
            }
        } else {
            NSLog(@"Received no data from iTunes API");
        }
        
    });
    
}

@end
