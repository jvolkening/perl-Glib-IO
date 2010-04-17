#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 4;
use Glib::IO;

my $loop = Glib::MainLoop->new ();

# FIXME: Glib::IO::File->new_for_path?
my $file = Glib::IO::File::new_for_path ($0);

$file->query_info_async ('*', [], 0, undef, \&info, [ 23, 'bla' ]);
sub info {
  my ($file, $res, $data) = @_;

  my $info = $file->query_info_finish ($res);
  ok (defined $info->get_name ());
  ok (defined $info->get_size ());

  {
  local $TODO = 'FIXME: user data does not get through in this case';
  is ($data->[0], 23);
  is ($data->[1], 'bla');
  }

  $loop->quit ();
}

$loop->run ();
