//
//  SCTCustomCell.h
//  SoundCloudIOSChallenge
//
//  Created by Ben on 10/24/12.
//  Copyright (c) 2012 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTCustomCell : UITableViewCell

/** The title of the track */
@property (weak, nonatomic) IBOutlet UILabel *title;

/** The creation date of the track */
@property (weak, nonatomic) IBOutlet UILabel *creationDate;

/** The waveform image of the track */
@property (weak, nonatomic) IBOutlet UIImageView *waveForm;
@end
