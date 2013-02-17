package Glib::IO;

use strict;
use warnings;
use Glib::Object::Introspection;

our $GIO_BASENAME = 'Gio';
our $GIO_VERSION = '2.0';
our $GIO_PACKAGE = 'Glib::IO';

sub import {
  Glib::Object::Introspection->setup(
    basename => $GIO_BASENAME,
    version => $GIO_VERSION,
    package => $GIO_PACKAGE);
}

1;
__END__

=head1 NAME

Glib::IO - Perl bindings to the GIO library

=head1 SYNOPSIS

  XXX

=head1 ABSTRACT

XXX

=head1 DESCRIPTION

XXX

=head1 SEE ALSO

XXX

=head1 AUTHORS

=encoding utf8

XXX

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010, 2013 by Torsten Schoenfeld <kaffeetisch@gmx.de>

This library is free software; you can redistribute it and/or modify it under
the terms of the Lesser General Public License (LGPL).  For more information,
see http://www.fsf.org/licenses/lgpl.txt

=cut
