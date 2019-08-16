//
//  SXFileManager.m
//  SXEditDemo
//
//  Created by Yin Xie on 2018/11/14.
//  Copyright © 2018 Yin Xie. All rights reserved.
//

#import "SXFileManager.h"

@implementation SXFileManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mSystemFileManager = [NSFileManager defaultManager];
    }
    return self;
}

+(instancetype) shared
{
    __strong static SXFileManager * SharedFileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SharedFileManager = [[SXFileManager alloc] init];
    });
    
    return SharedFileManager;
}

-(BOOL) fileExists:(NSString *) path
{
    return [_mSystemFileManager fileExistsAtPath:path];
}

-(BOOL) fileExistsUrl:(NSURL *) url
{
    BOOL exists = [url checkResourceIsReachableAndReturnError:nil];
    return exists;
}

-(BOOL) folderExists:(NSString *) path
{
    BOOL isFolder = NO;
    BOOL exists = [_mSystemFileManager fileExistsAtPath:path isDirectory:&isFolder];
    return exists && isFolder;
}

-(BOOL) copyFileFrom:(NSString *) src to:(NSString *) dst
{
    if ([[SXFileManager shared] fileExists:src])
    {
        NSError * error = nil;
        return [_mSystemFileManager copyItemAtPath:src toPath:dst error:&error] && error == nil;
    }
    return NO;
}

-(BOOL) copyFileFromURL:(NSURL *) src to:(NSURL *) dst
{
    if ([[SXFileManager shared] fileExists:src.path])
    {
        NSError * error = nil;
        return [_mSystemFileManager copyItemAtURL:src toURL:dst error:&error] && error == nil;
    }
    return NO;
}

-(BOOL) moveFileFrom:(NSString *) src to:(NSString *) dst
{
    if ([self fileExists:src])
    {
        NSError * error = nil;
        return [_mSystemFileManager moveItemAtPath:src toPath:dst error:&error] && error == nil;
    }
    
    return NO;
}

-(BOOL) createDirectoryForPath:(NSString*) path
{
    if (![self folderExists:path])
    {
        return [_mSystemFileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

-(BOOL) removeFileAt:(NSString *) path
{
    NSError * error = nil;
    return (![_mSystemFileManager removeItemAtPath:path error:&error] || error != nil);
}

-(BOOL) removeFileAtURL:(NSURL *) path
{
    NSError * error = nil;
    return (![_mSystemFileManager removeItemAtURL:path error:&error] || error != nil);
}

//-(void) unzipFile:(NSString *) path to:(NSString *) des progressHandler:(void(^)(int percent))progressHandler completeHandler:(void(^)(BOOL success))completeHandler
//{
//    if([self fileExists:path] )
//    {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            
//            __block int percent = 0;
//            ZipArchive * archive = [[ZipArchive alloc] init];
//            archive.progressBlock = ^(int percentage, int filesProcessed, unsigned long numFiles)
//            {
//                percent = percentage;
//                progressHandler(percentage);
//            };
//            [archive UnzipOpenFile:path];
//            [archive UnzipFileTo:des overWrite:YES];
//            
//            completeHandler(percent == 100);
//        });
//    }
//    else
//    {
//        completeHandler(YES);
//    }
//}
//
//-(void) syncUnzipFile:(NSString *) path to:(NSString *) des progressHandler:(void(^)(int percent))progressHandler completeHandler:(void(^)(BOOL success))completeHandler
//{
//    if([self fileExists:path] )
//    {
//        __block int percent = 0;
//        ZipArchive * archive = [[ZipArchive alloc] init];
//        archive.progressBlock = ^(int percentage, int filesProcessed, unsigned long numFiles)
//        {
//            percent = percentage;
//            progressHandler(percentage);
//        };
//        [archive UnzipOpenFile:path];
//        [archive UnzipFileTo:des overWrite:YES];
//        
//        completeHandler(percent == 100);
//    }
//    else
//    {
//        completeHandler(YES);
//    }
//}
//
//-(void) unzipFile:(NSString *) path to:(NSString *) des password:(NSString*) password progressHandler:(void(^)(int percent))progressHandler completeHandler:(void(^)(BOOL success))completeHandler
//{
//    if([self fileExists:path] )
//    {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            __block int percent = 0;
//            ZipArchive * archive = [[ZipArchive alloc] init];
//            archive.progressBlock = ^(int percentage, int filesProcessed, unsigned long numFiles)
//            {
//                percent = percentage;
//                progressHandler(percentage);
//            };
//            
//            [archive UnzipOpenFile:path Password:password];
//            [archive UnzipFileTo:des overWrite:YES];
//            
//            completeHandler(percent == 100);
//        });
//    }
//    else
//    {
//        completeHandler(YES);
//    }
//}
//
//- (void)zipFile:(NSString *)path to:(NSString *)des completeHandler:(void (^)(BOOL))completeHandler {
//    if([self fileExists:path] )
//    {
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            ZipArchive * archive = [[ZipArchive alloc] init];
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            [archive CreateZipFile2:des];
//            BOOL isDirectory;
//            [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
//            BOOL finish = YES;
//            if (isDirectory) {
//                NSArray *subPaths = [fileManager subpathsAtPath:path];// 关键是subpathsAtPath方法
//                for(NSString *subPath in subPaths){
//                    NSString *fullPath = [path stringByAppendingPathComponent:subPath];
//                    BOOL isDir;
//                    if([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir)// 只处理文件
//                    {
//                        finish = finish && [archive addFileToZip:fullPath newname:[path.lastPathComponent stringByAppendingPathComponent:subPath]];
//                    }
//                    if (!finish) {
//                        break;
//                    }
//                }
//            }else {
//                finish = [archive addFileToZip:path newname:path.lastPathComponent];
//            }
//            
//            [archive CloseZipFile2];
//            completeHandler(finish);
//        });
//    }
//    else
//    {
//        completeHandler(YES);
//    }
//}
@end
