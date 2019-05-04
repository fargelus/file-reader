#! /usr/bin/perl
use warnings;
use strict;

use Tk;

my $mw = MainWindow->new;
$mw->geometry('200x100');
$mw->title('File Reader');
$mw->Label(-text => 'Hello world!!!')->pack();
$mw->Button(-text => 'Close', -command => sub{exit})->pack();

MainLoop;
