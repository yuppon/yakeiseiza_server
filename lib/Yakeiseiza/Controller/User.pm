package Yakeiseiza::Controller::User;

use utf8;
use base 'Yakeiseiza::ControllerBase';
use Email::Valid::Loose;

sub create :Local :Args(0) {

    my ($self, $c) = @_;

    $c->stash->{json} = { status => 'faild' };

    if ($c->user) {
        $c->stash->{json}->{message} = $c->model('conf')->{message}->{logined};
        $c->detach;
    }

    my $res = $self->check_user_param($c);

    if ($c->model('Schema::User')->has_email($res->{email})) {
        $c->stash->{json}->{message} = $c->model('conf')->{message}->{duplicate_email};
        $c->detach;
    }

    if ($c->model('Schema::User')->create($res)) {
        $c->stash->{json}->{status} = 'ok';
    }

}

sub update :Local :Args(0) {

    my ($self, $c) = @_;

    $c->stash->{json} = { status => 'faild' };

    $self->check_login($c);

    my $res = $self->check_user_param($c);

    unless ($c->user->obj->email eq $res->{email}) {
        if ($c->model('Schema::User')->has_email($res->{email})) {
            $c->stash->{json}->{message} = $c->model('conf')->{message}->{duplicate_email};
            $c->detach;
        }
    }


    if ((my $user = $c->user->obj->update($res))) {
        $c->user->hash({ $user->get_columns });
        $c->user->obj($user);
        $c->auth->persist_user($c->user);
        $c->stash->{json}->{status} = 'ok';
    }
}

sub check_user_param {
    my ($self, $c) = @_;

    my $res = {
        email => $c->req->param('email'),
        password => $c->req->param('password'),
        username  => $c->req->param('username'),
    };

    while ( my ($key, $val) = each(%$res) ) {
        unless ( $val) {
            $c->stash->{json}->{message} = $key.' が入力されていません';
            $c->detach;
        }
    }

    my $email_res = Email::Valid::Loose->address($res->{email});
    unless (defined $email_res) {
        $c->stash->{json}->{message} = $c->model('conf')->{message}->{invalid_email};
        $c->detach;
    }

    return $res;
}

sub verify :Local :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{json} = { status => 'faild' };

    if ($c->user) {
        $c->stash->{json}->{status} = 'ok';
    }
    else {
    }
}

sub login :Local :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{json} = { status => 'faild' };

    my $user;
    if ($user = $c->authenticate({ email => $c->req->param('email'), password => $c->req->param('password') })) {
        $c->stash->{json}->{status} = 'ok';
    }
    else {
        $c->detach;
    }
}

sub logout :Local :Args(0) {
    my ($self, $c) = @_;

    $c->logout;
    $c->session->initialize_session_data;
    $c->stash->{json} = { status => 'ok' };
}

sub likes :Local :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{json} = { status => 'faild' };

    $self->check_login($c);

    my @likes = $c->user->obj->recent_likes;

    $json = [];

    for my $like (@likes) {
        my $photo_json = $like->photo->to_json;
        $photo_json->{is_like} = 1;
        push @$json, $photo_json;
    }

    $c->stash->{json}->{status} = 'ok';
    $c->stash->{json}->{photos} = $json;
}

sub end :Private {
    my ($self, $c) = @_;
    $c->forward( $c->view('JSON') );
}

1;
