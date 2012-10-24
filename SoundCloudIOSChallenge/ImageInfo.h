#import <Foundation/Foundation.h>

@interface ImageInfo : NSObject {
    
}

- (id)initWithSourceURL:(NSURL *)URL;
- (id)initWithSourceURL:(NSURL *)URL imageName:(NSString *)name image:(UIImage *)i;

@property (retain) NSURL * sourceURL;
@property (retain) NSString * imageName;
@property (nonatomic, retain) UIImage * image;

@end
