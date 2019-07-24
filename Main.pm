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

my @G_WIDGETS_LIST = qw /Window Label Text Photo Img_btn Open_btn Save_btn/;
my %G_WIDGETS = map {$_ => undef} @G_WIDGETS_LIST;

sub main {
  my $mw = MainWindow->new;
  $G_WIDGETS{'Window'} = $mw;

  initWindowMeta();
  initUI();
  packControlBtns();

  my $filepath;
  my $file_path_lbl = $G_WIDGETS{'Label'};
  $file_path_lbl->configure(-textvariable => \$filepath);

  my $open_btn = $G_WIDGETS{'Open_btn'};
  $open_btn->configure(-command => sub {
    $filepath = getUserSelectedFile($filepath);

    if ($filepath) {
      viewFileContent();
    } else {
      restoreToDefaultState();
    }
  });

  my $save_btn = $G_WIDGETS{'Save_btn'};
  $save_btn->configure(-command => sub {
    my $updated = $G_WIDGETS{'Text'}->Contents();

    my $msg = 'File was saved';
    $msg = 'Error, while saving file' unless (write_file($filepath, $updated));
    $mw->messageBox(-message => $msg);
  });

  MainLoop;
}

sub initWindowMeta {
  my $win = $G_WIDGETS{'Window'};

  $win->title('File Viewer');
  $win->bind('<Configure>' => sub {
    my $w = shift;
    $w->minsize($w->Width, $w->Height);
    $w->bind('<Configure>' => sub {});
  });
}

sub initUI {
  my $mw = $G_WIDGETS{'Window'};

  $G_WIDGETS{'Text'} = $mw->Text;
  $G_WIDGETS{'Label'} = $mw->Label;
  $G_WIDGETS{'Photo'} = $mw->Photo;
  $G_WIDGETS{'Img_btn'} = $mw->Button;
}

sub packControlBtns {
  my $mw = $G_WIDGETS{'Window'};

  my $btn_frame = $mw->Frame;
  my $save_btn = $btn_frame->Button(-text => 'Save', -state => 'disabled');
  my $open_btn = $btn_frame->Button(-text => 'Open');

  $btn_frame->pack(-anchor => 'e', -side => 'bottom');

  my %btn_pos = (
    -side => 'left',
  );
  $save_btn->pack(%btn_pos);
  $open_btn->pack(%btn_pos);

  $G_WIDGETS{'Save_btn'} = $save_btn;
  $G_WIDGETS{'Open_btn'} = $open_btn;
}

sub getUserSelectedFile {
  my $path = shift;

  my $dir = $path ? dirname($path) : getcwd;
  my $mw = $G_WIDGETS{'Window'};
  my $f_select = $mw->FileSelect(-directory => $dir);
  $f_select->Show;
}

sub viewFileContent {
  my $file_path_lbl = $G_WIDGETS{'Label'};
  my $filepath = $file_path_lbl->cget('-text');

  my $mw = $G_WIDGETS{'Window'};
  my $text_area = $G_WIDGETS{'Text'};
  my $img_btn = $G_WIDGETS{'Img_btn'};
  my $is_image = isImage($filepath);
  my $content;

  $file_path_lbl->pack(-side => 'top', -pady => 5);
  if ($is_image) {
    $text_area->packForget;

    my $ext = getFileExtension($filepath);
    my $photo_obj = $G_WIDGETS{'Photo'};
    $photo_obj->blank;
    $photo_obj->configure(-file => $filepath, -format => $ext);

    $img_btn->configure(-image => $photo_obj);
    $img_btn->pack(-side => 'top');
  } else {
    $img_btn->packForget;
    $text_area->pack(-side => 'top');

    $content = readFileContent($filepath);
    $text_area->Contents($content);
  }

  my $state = defineSaveBtnState($content, $is_image);
  $G_WIDGETS{'Save_btn'}->configure(-state => $state);
}

sub restoreToDefaultState {
  $G_WIDGETS{'Text'}->packForget;
  $G_WIDGETS{'Img_btn'}->packForget;
  $G_WIDGETS{'Label'}->packForget;
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
