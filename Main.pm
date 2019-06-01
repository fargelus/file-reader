package Main;

use warnings;
use strict;

use Tk;
use Tk::FileSelect;
use Tk::PNG;
use Tk::JPEG;
use Cwd;
use File::Slurp;
use File::Basename;

sub main {
  my $mw = MainWindow->new;

  initWindowMeta($mw);
  my (
    $text_area,
    $file_path_lbl,
    $photo_obj,
    $img_btn,
    $open_btn,
    $save_btn
    ) = initUI($mw);

  my $filepath;
  $file_path_lbl->configure(-textvariable => \$filepath);

  $open_btn->configure(-command => sub {
    $filepath = getUserSelectedFile($mw, $filepath);
    my $content;
    my $is_image = isImage($filepath);

    if ($is_image) {
      $text_area->packForget;

      my $ext = getFileExtension($filepath);
      $photo_obj->configure(-file => $filepath, -format => $ext);

      $img_btn->configure(-image => $photo_obj);
      $img_btn->pack(-side => 'top');
    } else {
      $img_btn->packForget;
      packTextArea($text_area);

      $content = readFileContent($filepath);
      $text_area->Contents($content);
    }

    my $state = defineSaveBtnState($content, $is_image);
    $save_btn->configure(-state => $state);
  });

  $save_btn->configure(-command => sub {
    my $updated = $text_area->Contents();

    my $msg = 'File was saved';
    $msg = 'Error, while saving file' unless (write_file($filepath, $updated));
    $mw->messageBox(-message => $msg);
  });

  $file_path_lbl->pack(-side => 'top', -pady => 5);
  packTextArea($text_area);

  MainLoop;
}

sub initWindowMeta {
  my $win = shift;

  $win->geometry('300x200');
  $win->title('File Viewer');
}

sub initUI {
  my $mw = shift;

  my $text_area = $mw->Text;
  my $file_path_lbl = $mw->Label;
  my $photo_obj = $mw->Photo;
  my $img_btn = $mw->Button;
  my ($save_btn, $open_btn) = packBtns($mw);

  ($text_area, $file_path_lbl, $photo_obj, $img_btn, $open_btn, $save_btn);
}

sub packBtns {
  my $mw = shift;

  my $btn_frame = $mw->Frame;
  my $save_btn = $btn_frame->Button(-text => 'Save', -state => 'disabled');
  my $open_btn = $btn_frame->Button(-text => 'Open');

  $btn_frame->pack(-anchor => 'e', -side => 'bottom');

  my %btn_pos = (
    -side => 'left',
  );
  $save_btn->pack(%btn_pos);
  $open_btn->pack(%btn_pos);

  ($save_btn, $open_btn);
}

sub isImage {
  my $file = shift;

  return 0 unless ($file);

  $file =~ /.(png|jpe?g|gif)$/i;
}

sub getFileExtension {
  my $path = shift;

  $path =~ /.([^.]+)$/ ? $1 : '';
}

sub packTextArea {
  my $text = shift;
  $text->pack(-side => 'top')
}

sub getUserSelectedFile {
  my ($mw, $path) = @_;

  my $dir = $path ? dirname($path) : getcwd;
  my $f_select = $mw->FileSelect(-directory => $dir);
  $f_select->Show;
}

sub readFileContent {
  my $file_to_open = shift;

  return '' unless($file_to_open);
  join '', read_file($file_to_open);
}

sub defineSaveBtnState {
  my ($content, $is_image) = @_;

  my $state = 'normal';
  $state = 'disabled' if ($is_image || !$content);
  $state;
}

1;
