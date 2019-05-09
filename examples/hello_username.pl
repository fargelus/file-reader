#! /usr/bin/perl
use warnings;
use strict;

use Tk;

my $mw = MainWindow->new;
$mw->geometry('300x200');
$mw->title('Hello %username%');

my $frame = $mw->Frame;
buildApp($frame);
$frame->pack(-expand => 1);

MainLoop;

sub showName {
  my ($frame, $name) = @_;

  my $greeting = $frame->Label(-text => "Hello, $name");
  $greeting->pack;
}

sub buildApp {
  my $top_frame = shift;

  my $inner_frame = $top_frame->Frame;

  my $lbl = $inner_frame->Label(-text => 'Enter your name:');
  $lbl->pack(-side => 'left', -padx => 5);

  my $entry = $inner_frame->Entry(-background => 'black', -foreground => 'green');
  $entry->pack;

  $inner_frame->pack(-expand => 1);
  $top_frame->Button(-text => 'Ok', -command => sub {
    my $entry_text = $entry->get();
    showName($top_frame, $entry_text);
  })->pack(-pady => 5, -side => 'right');
}
