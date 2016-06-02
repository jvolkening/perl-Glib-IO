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

=head3 Reading and writing files with the Gio API

GIO reads and writes files in raw bytes format. We have to convert these data so that Perl can understand them better. Therefore we convert the bytes (= pure digits) to a bytestring without encoding The user then needs to decide what to do with it und possibly decode or encode the string in the UTF-8 Format by himself with my $content_utf8 = decode('utf-8', $content); or my $content_bytesrting = encode('utf-8', $content_utf8);

This modification is implemented for the following methods:
  
=over

=item * Glib::IO::File::load_contents

=item * Glib::IO::File::replace_contents

=back

=cut

sub Glib::IO::File::load_contents {
	my ($gfile, $gcancellable) = @_;
	my ($success, $raw_content, $etags) = Glib::Object::Introspection->invoke (
		'Gio','File','load_contents',$gfile,$gcancellable
		);
	# the problem is, that GIO reads and writes files in raw bytes format.
	# We have to convert these data so that Perl can understand them.
	# Therefore we convert the bytes (= pure digits) to a bytestring without encoding
	# The user then needs to decide what to do with it und possibly decode the string
	# in the UTF-8 Format by himself
	my $content = pack "C*", @{$raw_content};

	return ($success,$content,$etags);
}

sub Glib::IO::File::replace_contents {
	my ($gfile, $content, $etag, $make_backup, $flags, $gerror) = @_;
	# the problem is, that GIO reads and writes files in raw bytes format,
	# which means everything is passed on without any encoding/decoding.
	# Therefore we have to convert the perlish content into an array ref containing
	# the raw bytes
	my @contents = unpack "C*", $content;
	return Glib::Object::Introspection->invoke (
		'Gio','File','replace_contents', $gfile, \@contents, $etag, $make_backup, $flags, $gerror
		);
}

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
