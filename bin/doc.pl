#!/usr/bin/env perl
# List, search, and show the markdown references under docs/.
#
# Invoked by the doc() launcher in zsh/conf.d/80-doc.zsh, which passes
# the docs directory as the first argument and GLOW_STYLE as an
# environment variable.
use v5.36;
use utf8;
use autodie qw(:default exec);

use File::Basename qw(basename);
use File::Find;
use File::Spec;
use Getopt::Long qw(GetOptions);
use List::Util   qw(max);

sub main() {
    my $docdir = shift @ARGV;
    unless ( defined $docdir && length $docdir ) {
        print_usage();
        return 2;
    }

    Getopt::Long::Configure(qw(pass_through));
    my ( $list, $pattern, $help );
    return 2
      unless GetOptions(
        'l'      => \$list,
        'k=s'    => \$pattern,
        'h|help' => \$help
      );

    return {
        help => sub {
            print_usage();
            return 0;
        },
        search => sub {
            search_docs( $docdir, $pattern, @ARGV );
            return 0;
        },
        list => sub {
            list_docs($docdir);
            return 0;
        },
        missing_pattern => sub {
            say STDERR 'doc: -k requires a pattern';
            return 2;
        },
        unknown_option => sub {
            say STDERR "doc: unknown option: $ARGV[0]";
            return 2;
        },
        show => sub {
            my $path = resolve_doc( $docdir, $ARGV[0] );
            return 1 unless defined $path;
            show_doc( $path,
                defined $ENV{GLOW_STYLE}
                ? ( '--style', $ENV{GLOW_STYLE} )
                : () );
            return 0;
        },
    }->{ mode( $list, $pattern, $help, @ARGV ) }->();
}

sub mode ( $list, $pattern, $help, @args ) {
    return 'help'            if $help;
    return 'search'          if defined $pattern;
    return 'list'            if $list || !@args;
    return 'missing_pattern' if $args[0] eq '-k';
    return 'unknown_option'  if $args[0] =~ /^-/;
    return 'show';
}

sub print_usage() {
    print <<'USAGE';
usage: doc [-h|--help] [-l] [-k PATTERN] [NAME]

  NAME          show the reference for NAME
  -l            list available references
  -k PATTERN    search references for PATTERN
  -h, --help    show this help
USAGE
}

sub list_docs ($docdir) {
    my @pages = find_markdown_files($docdir);
    @pages = sort @pages;

    my $width = max map { length doc_name( $docdir, $_ ) } @pages;
    for my $path (@pages) {
        printf "%-${width}s  %s\n", doc_name( $docdir, $path ),
          doc_title($path);
    }
}

sub search_docs ( $docdir, $pattern, @extra_args ) {
    chdir $docdir;
    exec 'rg', '--smart-case', '--heading', '--line-number',
      $pattern, @extra_args, '--iglob', '*.md', '.';
}

sub resolve_doc ( $docdir, $name ) {
    my $exact = "$docdir/$name.md";
    return $exact if -f $exact;

    my $basename = basename($name);
    my @found    = grep { basename($_) =~ s{\.md\z}{}ir eq $basename }
      find_markdown_files($docdir);

    if ( @found == 0 ) {
        say STDERR "doc: no reference for '$name'";
        return;
    }
    if ( @found > 1 ) {
        say STDERR "doc: '$name' is ambiguous:";
        say STDERR "  ", doc_name( $docdir, $_ ) for sort @found;
        return;
    }
    return $found[0];
}

sub show_doc ( $path, @style ) {
    exec 'glow', @style, '--pager', $path;
}

sub find_markdown_files ($dir) {
    my @files;
    find(
        {
            wanted => sub {
                return unless -f;
                return unless /\.md\z/i;
                push @files, $File::Find::name;
            },
            no_chdir => 1,
        },
        $dir
    );
    return @files;
}

sub doc_name ( $docdir, $path ) {
    my $name = File::Spec->abs2rel( $path, $docdir );
    $name =~ s{\.md\z}{}i;
    return $name;
}

sub doc_title ($path) {
    ## no critic (InputOutput::RequireBriefOpen)
    # $fh is lexical: it closes on scope exit.
    my @title;
    open my $fh, '<', $path;
    while ( my $line = <$fh> ) {
        chomp $line;
        if ( !@title ) {
            push @title, substr( $line, 2 ) if $line =~ /^\# /;
        }
        elsif (@title) {
            push @title, substr( $line, 3 )
              if $line =~ /^\#{2} /
              && substr( $line, 3 ) ne 'See Also';
        }
    }
    return join " - ", @title;
}

exit main();
