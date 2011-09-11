package Yakeiseiza::Schema::ResultSet::User;

use base 'DBIx::Class::ResultSet';

sub has_email {
    my ($self, $email) = @_;

    $self->search(
        {
            'me.email' => { '=', $email },
        },
        {
            rows => 1
        }
    )->count;
}

1;
