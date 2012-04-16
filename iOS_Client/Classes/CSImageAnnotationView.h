//
//  CSImageAnnotationView.h
//  mapLines
//
//  Created by Craig on 5/15/09.
//  Copyright 2009 Craig Spitzkoff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CSImageAnnotationView : MKAnnotationView
{
	UIImageView* _imageView;
	NSString *imageName;
}

//- (id)initWithAnnotation:(id )annotation reuseIdentifier:(NSString *)reuseIdentifier image:(NSString *)name;

//-(void) setImage:(NSString *)name;

@property (nonatomic, retain) UIImageView* imageView;
@end

