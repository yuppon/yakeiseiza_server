use strict;
use warnings;

use FindBin::libs;
use Path::Class qw/file/;

use Yakeiseiza::Models;

my $schema = models('Schema');
my $current_version = $schema->schema_version;
my $next_version = $current_version + 1;

$schema->create_ddl_dir(
    [qw/MySQL/], $next_version, "$FindBin::Bin/../sql/",
);

{
    my $f = file( $INC{'Yakeiseiza/Schema.pm'} );
    my $content = $f->slurp;
    $content =~ s/(\$VERSION\s*=\s*(['"]))(.+?)\2/$1$next_version$2/
      or die 'Faild to replace version.';

    my $fh = $f->openw or die $1;
    print $fh $content;
    $fh->close;
}
