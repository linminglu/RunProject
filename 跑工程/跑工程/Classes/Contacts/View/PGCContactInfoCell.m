//
//  PGCContactInfoCell.m
//  跑工程
//
//  Created by Mac on 16/10/18.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PGCContactInfoCell.h"

@interface PGCContactInfoCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *faxLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@end

@implementation PGCContactInfoCell

- (void)setContactLeft:(PGCContact *)contactLeft
{
    _contactLeft = contactLeft;
    if (!contactLeft) {
        return;
    }
}


#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeholder.text = @"备注...";
    } else {
        self.placeholder.text = @"";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.remarkTextView.delegate = self;
    self.remarkTextView.layer.borderColor = PGCBackColor.CGColor;
    self.remarkTextView.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
