package Glib::IO;

=encoding utf8

=head1 NAME

Glib::IO - Perl bindings to the GIO library

=head1 SYNOPSIS

  XXX

=head1 ABSTRACT

XXX

=head1 DESCRIPTION

XXX

=cut

use strict;
use warnings;
use Glib::Object::Introspection;

=head2 Wrapped libraries

XXX

=cut

my $GIO_BASENAME = 'Gio';
my $GIO_VERSION = '2.0';
my $GIO_PACKAGE = 'Glib::IO';

sub import {
  Glib::Object::Introspection->setup(
    basename => $GIO_BASENAME,
    version => $GIO_VERSION,
    package => $GIO_PACKAGE);
}

=head2 Customizations and overrides

XXX

=cut

1;
__END__

=head1 SEE ALSO

XXX

=head1 AUTHORS

=over

=item Torsten Schönfeld <kaffeetisch@gmx.de>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010-2015 by Torsten Schönfeld <kaffeetisch@gmx.de>

This library is free software; you can redistribute it and/or modify it under
the terms of the Lesser General Public License (LGPL).  For more information,
see http://www.fsf.org/licenses/lgpl.txt

=cut
