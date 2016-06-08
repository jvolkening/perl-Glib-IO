#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 23;
use Glib::IO;
use Glib ('TRUE', 'FALSE');


#
# Test der customizations for the overrides
#

# new_for_path
{
	my $file = Glib::IO::File->new_for_path ($0);
	ok (defined $file->hash (), 'test for new_for_path()');
}

# new_for_uri
{
	my $file = Glib::IO::File->new_for_path ($0);
	my $uri = $file->get_uri();
	my $file2 = Glib::IO::File->new_for_uri($uri);
	ok (defined $file->hash (), 'test for new_for_uri()');
}

# new for commandline_arg and new_for_commandline_arg_and_cwd
{
	my $file = Glib::IO::File->new_for_path ($0);
	my $path = $file->get_path();
	my $uri = $file->get_uri();
	my $parent = $file->get_parent();
	my $cwd = $parent->get_path();
	my $basename = $file->get_basename();

	# test with an absolute path
	my $file2 = Glib::IO::File->new_for_commandline_arg($path);
	ok (defined $file->hash(), 'test for new_for_commandline_arg() with path');

	# test with uri
	my $file3 = Glib::IO::File->new_for_commandline_arg($uri);
	ok ($file->equal($file3), 'test for new_for_commandline_arg() with uri');

	# test with relative path and cws
	my $file4 = Glib::IO::File->new_for_commandline_arg_and_cwd($basename, $cwd);
	ok ($file->equal($file4), 'test for new_for_commandline_arg_and_cwd() with relative path and cwd');
}

# new_tmp
{
	my ($gfile, $iostream) = Glib::IO::File->new_tmp(undef);
	ok (defined $gfile & defined $iostream, 'test for new_tmp')
}

# parse_name
{
	my $file = Glib::IO::File->new_for_path ($0);
	my $parse_name = $file->get_parse_name();
	my $file2 = Glib::IO::File->parse_name($parse_name);
	ok (defined $file2->hash (), 'test for parse_name');
}

# load_contents
{
	my $file = Glib::IO::File->new_for_path ($0);
	my $parent = $file->get_parent();
	my $dir = $parent->get_path();
	
	# mit Perl eine Datei erstellen
	open my $fh, ">", "$dir/test.tmp";
	print $fh "This is a test string";
	close $fh;

	# Read with Gio load_contents
	my $file2 = Glib::IO::File->new_for_path("$dir/test.tmp");
	my ($success, $content, $length, $etag_out) = $file2->load_contents(undef);
	ok($content eq "This is a test string", 'test for load_contents');
	unlink ("$dir/test.tmp");
}

# load_contents_async
TODO: {
	local $TODO = '$file->load_contents_finish() only works if no argument is passed; But it should be $file->load_contents_finish($res)';

	my $loop = Glib::MainLoop->new ();

	my $file = Glib::IO::File->new_for_path ($0);
	my $parent = $file->get_parent();
	my $dir = $parent->get_path();

	# mit Perl eine Datei erstellen
	open my $fh, ">", "$dir/test.tmp";
	print $fh "This is a test string";
	close $fh;

	# Read with Gio load_contents
	my $file2 = Glib::IO::File->new_for_path("$dir/test.tmp");
	my $start = $file2->load_contents_async(undef,\&load, undef);

	sub load {
		my ($file, $res) = @_;
		my ($success, $contents, $etag_out) = $file->load_contents_finish();

		ok($contents eq "This is a test string", 'test for load_contents_async');
		unlink ("$dir/test.tmp");

		$loop->quit();
	}
	$loop->run();
}

# replace_contents
{
	# get the current directory
	my $file = Glib::IO::File->new_for_path ($0);
	my $parent = $file->get_parent();
	my $dir = $parent->get_path();

	# create a GFILE with Gio API
	my $file2 = Glib::IO::File->new_for_path("$dir/test.tmp");
	my ($success, $etag_out) = $file2->replace_contents('This is a test string',undef, FALSE,'none', undef);

	# open and read the file to test with perl API
	open my $fh, "<", "$dir/test.tmp";
	my $line = <$fh>;
	close $fh;

	# TEST
	ok($line eq 'This is a test string', 'test for replace_contents()');

	# Delete the file with Gio API
	$file2->delete(undef);

	# TEST whether file is deleted
	my $n = $file2->query_exists();
	ok($n != 1, 'test for delete()');

}

# replace_contents_async
{
	my $file = Glib::IO::File->new_for_path ($0);
	my $parent = $file->get_parent();
	my $dir = $parent->get_path();

	# Create a file with replace_contents_async
	my $file2 = Glib::IO::File->new_for_path("$dir/test.tmp");
	$file2->replace_contents('This is a test string',undef, FALSE,'none', undef,\&replace);

	# open and read the file to test with perl API
	open my $fh, "<", "$dir/test.tmp";
	my $line = <$fh>;
	close $fh;

	# TEST
	ok($line eq 'This is a test string', 'test for replace_contents_async()');

	# Delete the file with Gio API
	$file2->delete(undef);

	# TEST whether file is deleted
	my $n = $file2->query_exists();
	ok($n != 1, 'test for delete()');

	sub replace {
		my ($file2, $res) = @_;
		my ($etag_out) = $file2->replace_contents_finish($res);
	}

}

{
  my $file = Glib::IO::File->new_for_path ('non-existent');
  eval { $file->read () };
  isa_ok ($@, 'Glib::IO::IOErrorEnum');
  is ($@->value, 'not-found');
}

{
  my $loop = Glib::MainLoop->new ();

  my $file = Glib::IO::File->new_for_path ($0);
  $file->query_info_async ('*', [], 0, undef, \&info, [ 23, 'bla' ]);
  sub info {
    my ($file, $res, $data) = @_;

    my $info = $file->query_info_finish ($res);
    ok (defined $info->get_name ());
    ok (defined $info->get_size ());
    is_deeply ($data, [ 23, 'bla' ]);

    $loop->quit ();
  }

  $loop->run ();
}

SKIP: {
  skip 'copy_async is not introspectable currently', 5;

  my $loop = Glib::MainLoop->new ();

  my $src = Glib::IO::File::new_for_path ($0);
  my $dst = Glib::IO::File::new_for_path ($0 . '.bak');
  $src->copy_async ($dst, [], 0, undef, \&progress, [ 23, 'bla' ], \&read, [ 42, 'blub' ]);

  my $progress_called = 0;
  sub progress {
    my ($current, $total, $data) = @_;
    return if $progress_called++;
    ok (defined $current);
    ok (defined $total);
    is_deeply ($data, [ 23, 'bla' ]);
  }
  sub read {
    my ($file, $res, $data) = @_;
    my $success = $file->copy_finish ($res);
    ok ($success);
    is_deeply ($data, [ 42, 'blub' ]);
    $loop->quit ();
  }

  $loop->run ();

  $dst->delete ();
}
