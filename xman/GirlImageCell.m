//
//  GirlImageCell.m
//  xman
//
//  Created by Liu Ming on 5/08/16.
//  Copyright © 2016 Liu Ming. All rights reserved.
//

#import "GirlImageCell.h"
#import "UIImageView+AFNetworking.h"


@interface GirlImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *MemberImage;

@property (weak, nonatomic) IBOutlet UIImageView *deleteImage;



@end

@implementation GirlImageCell

-(void)setImageDataWrapper:(PhotoWrapper *)imageDataWrapper{
    _imageDataWrapper = imageDataWrapper;
    if(imageDataWrapper.imageUrl){
        [self.MemberImage setImageWithURL:[NSURL URLWithString:imageDataWrapper.imageUrl ]];
        [self.deleteImage setHidden:false];
    }else{
        [self.deleteImage setHidden:true];
        [self.MemberImage setImage:[UIImage imageNamed:@"plus.png"]];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    
    UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDelectClick)];
    singleTap.numberOfTapsRequired = 1;
    [self.MemberImage setUserInteractionEnabled:YES];
    [self.MemberImage addGestureRecognizer:singleTap];
    [self.deleteImage setUserInteractionEnabled:YES];
    [self.deleteImage addGestureRecognizer:deleteTap];
}

-(void)tapDetected{
    NSLog(@"single Tap on imageview");
    [self onImageClick];
}


-(void)onDelectClick{
    [self.delegate onDelete:self.imageDataWrapper.index];
}

-(void)onImageClick{
    [self.delegate onClick: self.imageDataWrapper.index];
}

@end
