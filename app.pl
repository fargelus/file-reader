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

  my $text_area = $mw->Text;
  my $file_path = $mw->Label;

  my ($save_btn, $open_btn) = packBtns($mw);
  $open_btn->configure(-command => sub {
    my $file_to_open = getUserSelectedFile($mw);
    $file_path->configure(-text => $file_to_open);

    my $content = readFileContent($file_to_open);
    toggleSaveBtnState($save_btn, $content);
    $text_area->Contents($content);
  });

  $file_path->pack(-side => 'top', -pady => 5);
  $text_area->pack(-side => 'top');
}

sub initWindow {
  my $win = shift;

  $win->geometry('300x200');
  $win->title('File Viewer');
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

  ($save_btn, $open_btn);
}

sub getUserSelectedFile {
  my $mw = shift;

  my $f_select = $mw->FileSelect(-directory => getcwd);
  $f_select->Show;
}

sub readFileContent {
  my $file_to_open = shift;

  return '' unless($file_to_open);
  join '', read_file($file_to_open);
}

sub toggleSaveBtnState {
  my ($btn, $content) = @_;

  my $state = $content ? 'normal' : 'disabled';
  $btn->configure(-state => $state);
}
