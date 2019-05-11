#! /usr/bin/perl
use warnings;
use strict;

use Tk;
use Tk::FileSelect;
use Cwd;
use File::Slurp;

my $mw = MainWindow->new;
$mw->geometry('300x200');
$mw->title('File Reader');
buildApp($mw);

MainLoop;

sub buildApp {
  my $win = shift;

  my $text_area = $win->Text();

  my $file_to_open;
  my $btn = $win->Button(-text => 'Open', -command => sub {
    my $content = readFileContent($win);
    $text_area->Contents($content);
  });
  $btn->pack(-side => 'bottom', -anchor => 'e');

  $text_area->pack(-side => 'top');
}

sub readFileContent {
  my $win = shift;

  my $file_to_open = getUserSelectedFile($win);
  return '' unless $file_to_open;

  join '', read_file($file_to_open);
}

sub getUserSelectedFile {
  my $mw = shift;

  my $f_select = $mw->FileSelect(-directory => getcwd);
  $f_select->Show;
}
