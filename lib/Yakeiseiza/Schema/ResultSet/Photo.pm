package Yakeiseiza::Schema::ResultSet::Photo;

use utf8;
use base 'DBIx::Class::ResultSet';
use Yakeiseiza::Models;

my $conf = Yakeiseiza::Models->get('conf');

sub recent {
    my ($self, $page, $offset_id) = @_;

    $self->search(
        {
            'me.id' => { '>', $offset_id || 0 },
        },
        {
            order_by => { -desc => 'me.id' },
            page => $page,
            rows => $conf->{limit},
            prefetch => 'user',
        }
    );
}

sub area {
    my ($self, $param) = @_;

    $self->search(
        {
            lat => { -between => [$param->{min_lat}, $param->{max_lat}] },
            lon => { -between => [$param->{min_lon}, $param->{max_lon}] },
        },
        {
        },
    );
}

1;
