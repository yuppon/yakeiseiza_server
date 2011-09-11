package Yakeiseiza::Models;
use strict;
use warnings;

use Ark::Models '-base';
use Module::Find;
use Data::Dumper;

register Schema => sub {
    my $self = shift;
    my $conf = $self->get('conf')->{database} or die 'require database config';

    $self->ensure_class_loaded('Yakeiseiza::Schema');
    Yakeiseiza::Schema->connect(@$conf);
};

for my $table (qw/Photo User Like/) {
    register "Schema::$table" => sub {
        my $self = shift;
        $self->get('Schema')->resultset($table);
    };
}

register Facebook => sub {
    my $self = shift;
    my $conf = $self->get('conf')->{facebook};
    $self->ensure_class_loaded('Facebook::Graph');
    Facebook::Graph->new($conf);
};

register Digest => sub {
    my $self = shift;
    $self->ensure_class_loaded('Digest::SHA1');
    Digest::SHA1->new;
};

register cache => sub {
    my ($self) = @_;

    my $conf = $self->get('conf')->{cache};
    return $self->adaptor($conf);
};

1;
