#!/usr/bin/perl -w
use strict;
use warnings;
use Test::More tests => 10;

BEGIN { eval("use Term::Menu"); ok(!$@, "Load Term::Menu") };
SKIP: {
	eval("use Test::Expect");
	skip "Couldn't load Test::Expect",9 if $@;

	# This is required by Test::More:
	SKIP: {
		## First we find the Expect.pl file.
		my $command = "perl ";
		for(qw( ./ ../ ../../ ./t/ ../t/ ../../t/ )) {
			if(-e $_."Expect.pl") {
				$command .= $_."Expect.pl";
				last;
			}
		}
		
		if($command eq "perl ") {
			plan skip_all => "Can't find the Expect file";
		}
		
		expect_run(
			command => $command,
			prompt	=> "test: ",
			quit	=> "q",
		);
		
		expect("a", "ok", "Giving a good answer");
		expect("5", "error", "Giving a bad answer");
		expect_send("abcdefg", "Asking a small question");
		expect_like(qr/ok\n\na\)\nb\)/, "Giving a first");
		expect("b", "ok", "Answering the order question");
	}
}
