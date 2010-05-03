#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;
use Glib::IO;

my $cancellable = Glib::IO::Cancellable->new ();
$cancellable->connect (\&callback, [ 23, 'bla' ]);
sub callback {
  my ($data) = @_;
  is_deeply ($data, [ 23, 'bla' ]);
}
$cancellable->cancel ();

eval { $cancellable->set_error_if_cancelled (); };
ok (defined $@);
