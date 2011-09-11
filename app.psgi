use strict;
use warnings;

use Plack::Builder;
use Plack::Middleware::Static;

use lib './lib';
use Yakeiseiza;

my $app = Yakeiseiza->new;
$app->setup;

builder {
    enable 'Plack::Middleware::Static',
        path => qr{^/(uploads/|themes/|js/|css/|swf/|images?/|imgs?/|static/|[^/]+\.[^/]+$)},
        root => $app->path_to('root')->stringify;

    $app->handler;
};
