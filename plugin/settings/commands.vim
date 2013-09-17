command! R enew | setlocal buftype=nofile bufhidden=hide noswapfile

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

function s:ClearUndo()
	let saved = [&undolevels, &modified]
	set undolevels=-1
	exe "normal i \<BS>\<Esc>"
	let [&undolevels, &modified] = saved
endfunction
command! ClearUndo call s:ClearUndo()

if exists( ':filetype' )
	command! -nargs=+ Man delcommand Man | runtime ftplugin/man.vim | Man <args>
endif


if ! has( 'perl' ) | finish | endif

" wheee!

perl << EOF
use lib "$ENV{HOME}/.vim/lib";
use Encode;
use List::Util 'reduce';
sub get_decoded {
	my $encoding = VIM::Eval( 'strlen(&fileencoding) ? &fileencoding : &encoding' );
	decode $encoding, join "\n", $curbuf->Get( @_ );
}
sub filter {
	my ( $start, $end, @func ) = @_;
	my $filtered = reduce { join '', $b->( $a ) } get_decoded( $start .. $end ), @func;
	$filtered =~ s/\n\z//;
	$curbuf->Append( $end, split /\n/, $filtered, -1 );
	$curbuf->Delete( $start, $end );
}
EOF

perl eval 'use Text::SmartyPants; sub smarten { s/&#(\d+);/chr $1/eg, return $_ for Text::SmartyPants::process( shift, 2 ) }'
command! -range SmartyPants perl filter( <line1>, <line2>, \&smarten )
command! MailPants 0/^$/ , /^-- /-1 SmartyPants

perl eval 'use Text::Markdown qw(markdown);'
command! -range Markdown perl filter( <line1>, <line2>, \&markdown, \&smarten )

perl eval 'use HTML::Entities;'
command! -range DecodeHTML     perl filter( <line1>, <line2>, \&HTML::Entities::decode )
command! -range DecodeHTMLSafe perl my @special = qw( amp gt lt quot apos ); local @HTML::Entities::entity2char{ @special } = map "&$_;", @special; filter( <line1>, <line2>, \&HTML::Entities::decode )

perl eval 'use URI::Escape;'
