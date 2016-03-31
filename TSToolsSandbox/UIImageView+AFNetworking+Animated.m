#import "UIImageView+AFNetworking+Animated.h"
#import "TSNotifier.h"

@implementation UIImageView (Animated)
- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage animated:(BOOL) animated{
    [self setImageWithURL:url placeholderImage:placeholderImage animated:animated success:nil failure:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage animated:(BOOL) animated
                success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage animated:animated success:success failure:failure];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                      animated:(BOOL) animated
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    [self cancelImageRequestOperation];
    
    UIImage *cachedImage = [[[self class] af_sharedImageCache] cachedImageForRequest:urlRequest];
    if (cachedImage) {
        if (success) {
            success(nil, nil, cachedImage);
        }
        if (animated){
            [self animateImage:cachedImage forImageView:self];
        }else{
            self.image = cachedImage;
        }
        
        self.af_imageRequestOperation = nil;
    } else {
        if (!animated)
            self.image = placeholderImage;
        [TSNotifier showProgressOnView:self];
        __weak __typeof(self)weakSelf = self;
        self.af_imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        self.af_imageRequestOperation.responseSerializer = self.imageResponseSerializer;
        [self.af_imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([[urlRequest URL] isEqual:[operation.request URL]]) {
                if (success) {
                    success(urlRequest, operation.response, responseObject);
                }
                if (responseObject) {
                    if (animated) {
                        [strongSelf animateImage:responseObject forImageView:strongSelf];
                    }else{
                        strongSelf.image = responseObject;
                    }
                }
            } else {
                
            }
            [TSNotifier hideProgressOnView:weakSelf];
            
            [[[strongSelf class] af_sharedImageCache] cacheImage:responseObject forRequest:urlRequest];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([[urlRequest URL] isEqual:[operation.response URL]]) {
                if (failure) {
                    failure(urlRequest, operation.response, error);
                }
            }
            [TSNotifier hideProgressOnView:weakSelf];
        }];
        
        [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
    }
}

-(void) animateImage:(UIImage*)image forImageView:(UIImageView*) imageView{
    [UIView transitionWithView:imageView duration:0.5f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        imageView.image = image;
    } completion:NULL];
}

@end
