//
//  NetworkAdaptor.m
//  NetworkSupport_ASI_iOS
//
//  Created by PY on 12-9-16.
//  Copyright (c) 2012年 PY. All rights reserved.
//

#import "NetworkAdaptor.h"
#import "../TouchJSON/JSON/CJSONDeserializer.h"
#import "../TouchJSON/JSON/CJSONSerializer.h"

@implementation NetworkAdaptor


-(id) init
{
    if( self = [super init] )
    {
        postQueue = [[ASINetworkQueue alloc] init];
        [postQueue reset];
        [postQueue setDelegate:self];
        postQueue.maxConcurrentOperationCount = 2;
        [postQueue setShouldCancelAllRequestsOnFailure:NO];
        [postQueue go];
        
        downloadQueue = [[ASINetworkQueue alloc] init];
        [downloadQueue reset];
        [downloadQueue setDelegate:self];
        downloadQueue.maxConcurrentOperationCount = 5;
        [downloadQueue setShouldCancelAllRequestsOnFailure:NO];
        [downloadQueue go];
    }
    return self;
}


-(void) httpPost:(NSDictionary *)sentDic toURL:(NSURL *)url withNotificationName:(NSString *)notname
{
    /*
    NSError *error = NULL;
    NSData *jsonData = [[CJSONSerializer serializer] serializeDictionary:sentDic error:&error];
    NSString *jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    */
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    for (NSString *key in [sentDic allKeys]) {
        [request setPostValue:[sentDic valueForKey:key] forKey:key];
    }
    [reqhash2notname setObject:notname forKey:[NSString stringWithFormat:@"%d", [request hash]]];
    [request setDidFinishSelector:@selector(postDown:)];
    [request setDidFailSelector:@selector(postFailed:)];
    //NSLog(@"post(receivejson):%@\n",sentDic);
    [postQueue addOperation:request];
}

-(void) postDone:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    NSString *responseJson = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    //NSLog(@"post response(json):\n%@",responseJson);
    
    NSData *jsonData = [responseJson dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *responseDic = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
    
    NSString *reqhash = [NSString stringWithFormat:@"%d", [request hash]];
    [[NSNotificationCenter defaultCenter] postNotificationName:[reqhash2notname valueForKey:reqhash] object:nil userInfo:responseDic];
    [reqhash2notname removeObjectForKey:reqhash];
}

-(void) postFailed:(ASIHTTPRequest *)request
{
    NSString *reqhash = [NSString stringWithFormat:@"%d", [request hash]];
    NSLog(@"%@ failed!", [reqhash2notname valueForKey:reqhash]);
    [reqhash2notname removeObjectForKey:reqhash];
}



-(void) dealloc
{
    [postQueue release];
    [downloadQueue release];
    
    [super dealloc];
}

@end
