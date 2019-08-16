//
//  AppDelegate.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "PLShortVideoKit/PLShortVideoKit.h"
#import <SXVideoEnging/SXVideoEnging.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // pili 短视频日志系统
    [PLShortVideoKitEnv initEnv];
    [PLShortVideoKitEnv setLogLevel:PLShortVideoLogLevelDebug];
    [PLShortVideoKitEnv enableFileLogging];
    
    // crash 收集
    [Fabric with:@[[Crashlytics class]]];
    
     [SXLicense setLicense:@"Ih0p8+9ix9GqQz401Kcxm8aPajlf1bNhlXzoNGX5z6WeDxFhV7aZ96cFq/vMa2mBjb3ZRx8ccvYwRiMVeK/pkow12VeErQ786ICuzppG50X66AiYj+ybjVdr/sLzmdvV80Lq9zcTC9tlrWm6bPySfekIGgmkBc/dCGApD4zjgoz9DTUATQoJr57TWBuNL7G8k/NrdLUhAo0A6+PGig0236t0TG0OpnbNhKsLPlNDliJl75FFjTBSGzN2yyp64/AIjqZHOcf7Dl5cyEhndgOSVrreAXk2pkEyBI4otzuKlJBEEeVXkq4ROa0C36316HgTXB2GTXP9QDE4hKx6R+mm91d2IUQ90EEu1h+oj/Z5IkIXiJtMSECkbPOdbV46KLmktFNFZCFH2NknZqoUdgtkjJ9JYFGiNxYdi1UWU7wA21Z9JcrOvnl4DAFhsweaIlZtpJMgf+dPVRVeBwVCN/fU/goj8KhC+gPOrdN0OC15Z07Zs0r3wJ3ekuG8S8L8+sETHnSpmqpoC8rdGC7fiLtq9hDLdA9bGBxGbnHz/iJ8vYbpCBoJpAXP3QhgKQ+M44KMxUbi3T1iFOjvQy5oAc2+pse7WuyJGL1bhngm1T3zPeEe+Xf8rgzWPp6RWGsVub7S6b2TF1Lxi8Z3gLgYSjoEVWXTeXtq98fcJV9lnB3qg5Y8lmxgg+lC2tZnWi79ry8tmXIctXztFs6rvRL540BD4AxL/8KtXd7qXNGfCqwLzTeTccin3c+NWu2pOMletQwWlGVAzjammIT+AKuGbvGmNaF9KRrTfVKLtL6093cliqWR7NCGQ/lnmzfKXxbRlliA1OtdSubeLQIvY44PCW6J9Q=="];
    
    [[AVAudioSession sharedInstance] setCategory:(AVAudioSessionCategoryPlayback) error:nil];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
