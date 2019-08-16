//
//  SXFileManager.h
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/14.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXFileManager : NSObject

@property(nonatomic, readonly) NSFileManager * mSystemFileManager;

+(instancetype) shared;

-(BOOL) fileExists:(NSString *) path;

-(BOOL) fileExistsUrl:(NSURL *) url;

-(BOOL) folderExists:(NSString *) path;

-(BOOL) copyFileFrom:(NSString *) src to:(NSString *) dst;

-(BOOL) copyFileFromURL:(NSURL *) src to:(NSURL *) dst;

-(BOOL) moveFileFrom:(NSString *) src to:(NSString *) dst;

-(BOOL) createDirectoryForPath:(NSString*) path;

-(BOOL) removeFileAt:(NSString *) path;

-(BOOL) removeFileAtURL:(NSURL *) path;

//-(void) unzipFile:(NSString *) path to:(NSString *) des progressHandler:(void(^)(int percent))progressHandler completeHandler:(void(^)(BOOL success))completeHandler;
//
//-(void) syncUnzipFile:(NSString *) path to:(NSString *) des progressHandler:(void(^)(int percent))progressHandler completeHandler:(void(^)(BOOL success))completeHandler;
//
//-(void) unzipFile:(NSString *) path to:(NSString *) des password:(NSString*) password progressHandler:(void(^)(int percent))progressHandler completeHandler:(void(^)(BOOL success))completeHandler;
//
//-(void) zipFile:(NSString *) path to:(NSString *) des completeHandler:(void(^)(BOOL success))completeHandler;
@end

NS_ASSUME_NONNULL_END
