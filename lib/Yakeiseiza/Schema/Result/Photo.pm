package Yakeiseiza::Schema::Result::Photo;

use utf8;
use base 'Yakeiseiza::Schema::ResultBase';
use Yakeiseiza::Models;

__PACKAGE__->table('photo');

__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1,
        is_nullable => 0,
        extra => {
            unsigned => 1,
        },
    },

    user_id => {
        data_type => 'integer',
        is_nullable => 0,
        extra => {
            unsigned => 1,
        },
    },

    filename => {
        data_type => 'varchar',
        is_nullable => 0,
        size => 255,
    },

    name => {
        data_type => 'varchar',
        is_nullable => 1,
        size => 255,
    },

    comment => {
        data_type => 'varchar',
        is_nullable => 1,
        size => 255,
    },

    lon => {
        data_type => 'decimal',
        size => [9,6],
        #is_nullable => 0,
    },

    lat => {
        data_type => 'decimal',
        size => [9,6],
        #is_nullable => 0,
    },

    #geohash => {
    #    data_type => 'varchar',
    #    #is_nullable => 0,
    #    size => 255,
    #},

    created_at => {
        data_type => 'datetime',
        is_nullable => 1,
        time_zone => 'Asia/Tokyo',
    },

    updated_at => {
        data_type => 'datetime',
        is_nullable => 1,
        time_zone => 'Asia/Tokyo',
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to( user => 'Yakeiseiza::Schema::Result::User', 'user_id' );
__PACKAGE__->has_many( likes => 'Yakeiseiza::Schema::Result::Like', 'photo_id' );

sub to_json {
    my $self = shift;
    return {
        id        => $self->id,
        image_url => Yakeiseiza::Models->get('conf')->{url}.'/uploads/'.$self->filename,
        user_id   => $self->user_id,
        name      => $self->name,
        comment   => $self->comment,
        lon       => $self->lon,
        lat       => $self->lat,
        user_name => $self->user->username,
    };
}

sub recent_likes {
    my $self =shift;

    Yakeiseiza::Models->get('Schema::Like')->search(
        {
            'me.photo_id' => $self->id,
        },
        {
            order_by => { -desc => 'me.id' },
            rows => $conf->{limit},
            prefetch => 'user',
        },
    );

}

1;
