//
//  NetworkAdaptor.h
//  NetworkSupport_ASI_iOS
//
//  Created by PY on 12-9-16.
//  Copyright (c) 2012年 PY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSNotification.h>
#import "../ASIHttpRequest/ASINetworkQueue.h"
#import "../ASIHttpRequest/ASIHTTPRequest.h"
#import "../ASIHttpRequest/ASIFormDataRequest.h"


@interface NetworkAdaptor : NSObject
{
    ASINetworkQueue *postQueue;
    ASINetworkQueue *downloadQueue;
    NSMutableDictionary *reqhash2notname;
    
}


-(id) init;
-(void) dealloc;

-(void) httpPost:(NSDictionary *)sentDic toURL:(NSURL *)url withNotificationName:(NSString *)notname;
//-(void) download:(NSURL *)url;
-(void) postDone:(ASIHTTPRequest *)request;
-(void) postFailed:(ASIHTTPRequest *)request;
//-(void) downloadDone:(ASIHTTPRequest *)request;
//-(void) downloadFailed:(ASIHTTPRequest *)request;

@end
