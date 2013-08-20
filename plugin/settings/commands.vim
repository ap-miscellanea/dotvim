command! FindMarker /\([<=>|]\)\1\{6}/

command! -range TidyHTML <line1>,<line2>!tidy -q -utf8 -config ~/.tidy.conf.unintrusive

function s:GreekPants()
	silent! %s!\%u201C!«!g
	silent! %s!<<!«!g
	silent! %s!>>!»!g
	silent! %s!\%u201D!»!g
	silent! %s! - !\=' ' . nr2char(8211) . ' '!g
	silent! %s!?!\=nr2char(894)!gc
endfunction
command! GreekPants call s:GreekPants()

if exists( ':filetype' )
	command! -nargs=+ Man delcommand Man | runtime ftplugin/man.vim | Man <args>
endif


if ! has( 'perl' ) | finish | endif

" wheee!

perl eval 'use lib "$ENV{HOME}/.vim/lib";'
perl eval 'use HTML::Entities;'
perl eval 'use URI::Escape;'
perl eval 'use Text::Markdown qw(markdown);'
perl eval 'use Text::SmartyPants; *smarten = \&Text::SmartyPants::process;'
perl << EOF
use Encode;
sub VIM::Filter {
	my ( $start, $end, $func ) = @_;
	my $encoding = VIM::Eval( '&fileencoding' ) || VIM::Eval( '&encoding' );
	my $text = join '', map "$_\n", map { decode $encoding, $_ } $curbuf->Get( $start .. $end );
	my @filtered = $func->( $text );
	chomp @filtered;
	$curbuf->Delete( $start + 1, $end ) if $end > $start;
	$curbuf->Append( $start, map { split m!$/!, $_, -1 } @filtered );
	$curbuf->Delete( $start );
}
EOF

command! -range Markdown       perl VIM::Filter( <line1>, <line2>, sub { my $_ = smarten( markdown( shift ), 2 ); s/&#(\d+);/chr $1/eg; return $_ } )
command! -range SmartyPants    perl VIM::Filter( <line1>, <line2>, sub { my $_ = smarten( shift, 2 ); s/&#(\d+);/chr $1/eg; return $_ } )
command! MailPants 0/^$/ , /^-- /-1 SmartyPants
command! -range DecodeHTML     perl VIM::Filter( <line1>, <line2>, \&HTML::Entities::decode )
command! -range DecodeHTMLSafe perl my @special = qw( amp gt lt quot apos ); local @HTML::Entities::entity2char{ @special } = map "&$_;", @special; VIM::Filter( <line1>, <line2>, \&HTML::Entities::decode )
