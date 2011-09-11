package Yakeiseiza::Schema::Result::User;

use strict;
use warnings;

use base 'Yakeiseiza::Schema::ResultBase';
use Yakeiseiza::Models;

__PACKAGE__->table('user');
__PACKAGE__->load_components(qw/DigestColumns/);

__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1,
        is_nullable => 0,
        extra => {
            unsigned => 1,
        },
    },

    email => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 0,
    },

    username => {
        data_type => 'varchar',
        size => 255,
    },

    password => {
        data_type => 'varchar',
        size => 255,
        digest_check_method => 'check_password',
        is_nullable => 0,
    },

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
__PACKAGE__->add_unique_constraint('email_unique', ['email']);

__PACKAGE__->has_many( photos => 'Yakeiseiza::Schema::Result::Photo', 'user_id' );
__PACKAGE__->has_many( likes => 'Yakeiseiza::Schema::Result::Like', 'user_id' );

__PACKAGE__->digestcolumns(
    columns   => [qw/password/],
    algorithm => 'SHA1',
    encoding  => 'hex',
    auto => 1,
    dirty => 1,
);

sub to_json {
    my $self = shift;
    return {
        id => $self->id,
        username => $self->username,
    };
}

sub has_like {
    my ($self, $photo_id) = @_;

    Yakeiseiza::Models->get('Schema::Like')->search(
        {
            photo_id => $photo_id,
            user_id  => $self->id,
        },
        {
            rows => 1,
        }
    )->slice(0, 1)->count;
}

sub like {
    my ($self, $photo_id) = @_;

    Yakeiseiza::Models->get('Schema::Like')->create({
            user_id => $self->id,
            photo_id => $photo_id,
    });
}

sub unlike {
    my ($self, $photo_id) = @_;

    Yakeiseiza::Models->get('Schema::Like')->search({
            user_id => $self->id,
            photo_id => $photo_id,
    })->delete;
}

sub recent_likes {
    my ($self, $page) = @_;

    Yakeiseiza::Models->get('Schema::Like')->search(
        {
            'me.user_id' => $self->id,
        },
        {
            order_by => { -desc => 'me.id' },
            page => 1,
            rows => 20,
            prefetch => 'photo',
        }
    );
}

1;
