package Yakeiseiza::ControllerBase;

use Ark 'Controller';

sub check_login {
    my ($self, $c) = @_;

    if (!$c->user) {
        $c->stash->{json}->{message} = $c->model('conf')->{message}->{not_login};
        $c->detach;
    }
}

1;
