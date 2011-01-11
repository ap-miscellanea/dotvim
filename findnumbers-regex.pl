#!/usr/bin/env perl
use strict;
use Regexp::Trie;

sub rt {
	my $rt = Regexp::Trie->new;
	$rt->add( $_ ) for @_;
	for ( $rt->regexp ) {
		s!\A\(\?-xism:!!, s!\)\z!!; # take off the wrapper
		s!\\/!/!g, s!\|!\\|!g, s!\(\?:!\\%(!g, s!\)!\\)!g, s!\?!\\?!g; # translate to vim
		return $_;
	}
}

print
	rt( qw(
		<one two three four five six seven <eight nine <ten>
		eleven twelve thir four fif six seven <eigh nine
		twen thir four fif six seven <eigh nine
		hundred thousand
	) )
	. '\\%(teen\\|ty\\)\\?'
	. "\n";
