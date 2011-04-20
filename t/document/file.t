use Test::More;
use strict;
use warnings;

use MetaCPAN::Document::File;

use MetaCPAN::Pod::Lines;

{
    my $content = <<'END';
package Foo;
use strict;

=head1 NAME

MyModule - mymodule1 abstract

  not this

=pod

bla

=cut

more perl code

=head1 SYNOPSIS

more pod
more

even more

END

    my $file =
      MetaCPAN::Document::File->new( author       => 'Foo',
                                     path         => 'bar',
                                     release      => 'release',
                                     distribution => 'foo',
                                     name         => 'module.pm',
                                     content      => \$content );

    is( $file->abstract, 'mymodule1 abstract' );
    is_deeply( $file->pod_lines, [ [ 3, 11 ], [ 17, 6 ] ] );
    is( $file->sloc, 3 );
}
{
    my $content = <<'END';
=head1 NAME

MyModule

END

    my $file =
      MetaCPAN::Document::File->new( author       => 'Foo',
                                     path         => 'bar',
                                     release      => 'release',
                                     distribution => 'foo',
                                     name         => 'module.pm',
                                     content      => \$content );

    is( $file->abstract, '' );
}
{
    my $content = <<'END';
#$Id: Config.pm,v 1.5 2008/09/02 13:14:18 kawas Exp $

=head1 NAME

MOBY::Config.pm - An object B<containing> information about how to get access to teh Moby databases, resources, etc. from the 
mobycentral.config file

=cut


=head2 USAGE

=cut

package MOBY::Config;

END

    my $file =
      MetaCPAN::Document::File->new( author       => 'Foo',
                                     path         => 't/bar/bat.t',
                                     release      => 'release',
                                     distribution => 'foo',
                                     name         => 'module.pm',
                                     content_cb   => sub { \$content } );

    is( $file->abstract,
'An object containing information about how to get access to teh Moby databases, resources, etc. from the mobycentral.config file'
    );
    is( $file->indexed, 1, 'indexed' );
    is( $file->level, 2);
}

{
    my $content = <<'END';
package
  Number::Phone::NANP::AS;

# numbering plan at http://www.itu.int/itudoc/itu-t/number/a/sam/86412.html

use strict;

use base 'Number::Phone::NANP';

use Number::Phone::Country qw(noexport);

our $VERSION = 1.1;

my $cache = {};

# NB this module doesn't register itself, the NANP module should be
# used and will load this one as necessary

=head1 NAME

Number::Phone::NANP::AS

AS specific methods for Number::Phone

=cut

1;
END
    my $file =
      MetaCPAN::Document::File->new( author       => 'Foo',
                                     path         => 'bar',
                                     release      => 'release',
                                     distribution => 'foo',
                                     name         => 'module.pm',
                                     module => [{ name => 'Number::Phone::NANP::AS', version => 1.1 }],
                                     content_cb   => sub { \$content } );
    is( $file->sloc, 8, '8 lines of code' );
    is( $file->slop, 4, '4 lines of pod' );
    is( $file->indexed, 0, 'not indexed' );
    is( $file->abstract, 'AS specific methods for Number::Phone' );
    is( $file->documentation, 'Number::Phone::NANP::AS' );
    is_deeply( $file->pod_lines, [ [ 18, 7 ] ], 'correct pod_lines' );
    is( $file->module->[0]->version_numified, 1.1, 'numified version has been calculated');
}

done_testing;