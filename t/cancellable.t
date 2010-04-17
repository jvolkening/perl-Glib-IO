#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;
use Glib::IO;

my $cancellable = Glib::IO::Cancellable->new ();
$cancellable->connect (sub {
  my ($data) = @_;
  is ($data->[0], 23);
  is ($data->[1], 'bla');
}, [ 23, 'bla' ]);
$cancellable->cancel ();
