//
//  NetworkRequest.m
//  OpenChat
//
//  Created by Ashish Nigam on 26/09/14.
//  Copyright (c) 2014 Self. All rights reserved.
//

#import "NetworkRequest.h"

@implementation NetworkRequest

-(void)sendAsync
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
       // [connection start];
    });
                   
     //[NSURLConnection sendAsynchronousRequest:<#(NSURLRequest *)#> queue:<#(NSOperationQueue *)#> completionHandler:<#^(NSURLResponse *response, NSData *data, NSError *connectionError)handler#>];
                   
}
@end
