#!/usr/bin/perl -w

use strict;

my $question_type = '';
my $question_text = '';
my @wrong_answers = ();
my @correct_answers = ();
my $line;

while(<>) {
    #print $_;
    if(m!^(MC|MA|FIB):!) {
        if($question_type ne '') {
            # dump previous question
            output_question();
        }
        # get next question type
        ($question_type) = ($_ =~ m!^(\w+):!);
        $question_text = '';
        @wrong_answers = ();
        @correct_answers = ();
    } elsif(m!^\s*\-\s*(.*)$!) {
        # wrong answer
        push(@wrong_answers, cleanup_text($1));
    } elsif(m!^\s*\*\s*(.*)$!) {
        # correct answer
        push(@correct_answers, cleanup_text($1));
    } else {
        $line = cleanup_text($_);
        # if line is not empty, save it as part of the question text
        if($line =~ m!\S!) {
            $question_text .= $line;
        }
    }
}
# output last question in the file
if($question_type ne '') {
    output_question();
}

sub cleanup_text {
    my ($txt) = @_;
    $txt =~ s/[\t\n]/ /g;
    return $txt;
}

sub output_question {
    print "$question_type\t$question_text\t";
    if($question_type =~ m!^FIB$!) {
        print $correct_answers[0]."\t";
    }
    if($question_type =~ m!^(MC|MA)$!) {
        foreach my $txt (@wrong_answers) {
            print "$txt\tincorrect\t";
        }
        foreach my $txt (@correct_answers) {
            print "$txt\tcorrect\t";
        }
    }
    print "\n";
}
