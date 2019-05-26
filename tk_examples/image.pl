#! /usr/bin/perl
use warnings;
use strict;

use Tk;
use Tk::PNG;
use Tk::JPEG;
use File::HomeDir;

my $mw = new MainWindow;

my $img_path = File::HomeDir->my_home . '/img.jpg';
my $img = $mw->Photo(-file => $img_path, -format=>'JPEG');

my $btn = $mw->Button(-image => $img);
$btn->pack(-fill => 'both', -expand => 1);

MainLoop;
