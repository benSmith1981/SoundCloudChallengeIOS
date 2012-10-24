
#import "ImageInfo.h"
#import "ASIHTTPRequest.h"

@implementation ImageInfo

@synthesize sourceURL;
@synthesize imageName;
@synthesize image;

- (void)getImage {
    
    NSLog(@"Getting %@...", sourceURL);
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:sourceURL];
    [request setCompletionBlock:^{
        NSLog(@"Image downloaded.");
        NSData *data = [request responseData];
        image = [[UIImage alloc] initWithData:data];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageupdated" object:self];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error downloading image: %@", error.localizedDescription);
    }];
    [request startAsynchronous];    
}

- (id)initWithSourceURL:(NSURL *)URL {
    if ((self = [super init])) {
        sourceURL = [URL retain];
        imageName = [[URL lastPathComponent] retain];
        [self getImage];
    }
    return self;
}

- (id)initWithSourceURL:(NSURL *)URL imageName:(NSString *)name image:(UIImage *)i {
    if ((self = [super init])) {
        sourceURL = [URL retain];
        imageName = [name retain];
        image = [i retain];
    }
    return self;
}

- (void)dealloc {
    [sourceURL release];
    [imageName release];
    [image release];
    [super dealloc];
}

@end
