package Yakeiseiza::Schema::Result::Like;

use utf8;
use base 'Yakeiseiza::Schema::ResultBase';

__PACKAGE__->table('like');

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

    photo_id => {
        data_type => 'integer',
        is_nullable => 0,
        extra => {
            unsigned => 1,
        },
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
__PACKAGE__->belongs_to( user  => 'Yakeiseiza::Schema::Result::User', 'user_id' );
__PACKAGE__->belongs_to( photo => 'Yakeiseiza::Schema::Result::Photo', 'photo_id' );

1;
