#! /usr/bin/perl
use warnings;
use strict;

use Tk;
use Tk::FileSelect;
use Cwd;
use File::Slurp;

main();

MainLoop;

sub main {
  my $mw = MainWindow->new;
  initWindow($mw);

  my $text_area = $mw->Text();

  my ($save_btn, $open_btn) = packBtns($mw);
  $open_btn->configure(-command => sub {
    my $content = readFileContent($mw);
    toggleSaveBtnState($save_btn, $content);
    $text_area->Contents($content);
  });

  $text_area->pack(-side => 'top');
}

sub initWindow {
  my $win = shift;

  $win->geometry('300x200');
  $win->title('File Reader');
}

sub packBtns {
  my $mw = shift;

  my $save_btn = $mw->Button(-text => 'Save', -state => 'disabled');
  my $open_btn = $mw->Button(-text => 'Open');

  my %btn_pos = (
    -side => 'bottom',
    -anchor => 'e',
  );
  $save_btn->pack(%btn_pos);
  $open_btn->pack(%btn_pos);

  return ($save_btn, $open_btn);
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

sub toggleSaveBtnState {
  my ($btn, $content) = @_;

  my $state = $content ? 'normal' : 'disabled';
  $btn->configure(-state => $state);
}
