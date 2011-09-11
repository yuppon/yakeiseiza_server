package Yakeiseiza::Schema::ResultBase;

use base 'DBIx::Class';
use DateTime;

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);

sub insert {
    my $self = shift;
    my $now = DateTime->now( time_zone => 'Asia/Tokyo' );
    $self->created_at( $now ) if $self->can('created_at');
    $self->updated_at( $now ) if $self->can('updated_at');

    $self->next::method(@_);
}

sub update {
    my $self = shift;
    my $now = DateTime->now( time_zone => 'Asia/Tokyo' );
    $self->updated_at( $now ) if $self->can('updated_at');

    $self->next::method(@_);
}

1;
