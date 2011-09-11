package Yakeiseiza::Controller::Photo;

use utf8;
use base 'Yakeiseiza::ControllerBase';
use Path::Class qw/file/;
use File::Copy;
use URI::Escape;

sub photo :Chained('/') :PathPart :CaptureArgs(1) {
    my ($self, $c, $photo_id) = @_;
    $c->stash->{photo_id} = $photo_id;
}

sub like :Chained('photo') :PathPart :Args(0) {

    my ($self, $c) = @_;

    $c->stash->{json} = { status => 'faild' };

    $self->check_login($c);

    my $photo_id = $c->stash->{photo_id};
    if ($c->user->obj->has_like($photo_id)) {
        $c->stash->{json}->{message} = $c->model('conf')->{message}->{has_like};
        $c->detach;
    }

    if (my $like = $c->user->obj->like($photo_id)) {
        $c->stash->{json}->{status} = 'ok';
    }
}

sub unlike :Chained('photo') :PathPart :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{json} = { status => 'faild' };

    $self->check_login($c);
    my $photo_id = $c->stash->{photo_id};

    unless ($c->user->obj->has_like($photo_id)) {
        $c->stash->{json}->{message} = $c->model('conf')->{message}->{not_has_like};
        $c->detach;
    }

    if ($c->user->obj->unlike($photo_id)) {
        $c->stash->{json}->{status} = 'ok';
    }
}

sub likes :Chained('photo') :PathPart :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{json} = { status => 'faild' };

    my $photo_id = $c->stash->{photo_id};

    my $photo = $c->model('Schema::Photo')->find($photo_id);

    unless ($photo) {
        $c->stash->{json}->{message} = $c->model('conf')->{message}->{not_exist_photo};
        $c->detach;
    }

    my @likes = $photo->recent_likes;
    my $users = [];
    
    for my $like (@likes) {
        my $user_json = $like->user->to_json;
        push @$users, $user_json;
    }

    $c->stash->{json}->{users} = $users;
    $c->stash->{json}->{status} = 'ok';
}

sub create :Local :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{json} = { status => 'faild' };

    $self->check_login($c);

    my $file = $c->req->uploads->{image};
    my $comment = $c->req->param('comment');
    my $name = $c->req->param('name');
    my $lon = $c->req->param('lon');
    my $lat = $c->req->param('lat');

    unless ( $file ) {
        $c->stash->{json}->{message} = $c->model('conf')->{message}->{file_not_exist};
        $c->detach;
    }

    #unless ( defined $name ) {
    #    $c->stash->{json}->{message} = 'name is not exists';
    #    $c->detach;
    #}

    if ($file) {
        my $tempfile = Path::Class::File->new($file->{tempname});
        my $movepath = File::Spec->catfile($c->model('home'), 'root', 'uploads', $tempfile->basename);
        File::Copy::move($tempfile->stringify, $movepath);

        my $photo = $c->model('Schema::Photo')->create({
                filename => $tempfile->basename,
                comment => uri_unescape($comment),
                name    => uri_unescape($name),
                lon     => $lon,
                lat     => $lat,
                user_id => $c->user->hash->{id},
            });

        $c->stash->{json}->{photo} = $photo->to_json;
        $c->stash->{json}->{status} = 'ok';
    }

}

sub index :Path {
}

sub area :Local :Args(0) {
    my ($self, $c) = @_;

    my $criteria = {
        min_lat => $c->req->param('min_lat'),
        max_lat => $c->req->param('max_lat'),
        min_lon => $c->req->param('min_lon'),
        max_lon => $c->req->param('max_lon'),
    };

    while ( my ($k, $v) = each(%$criteria) ) {
        unless ($v) {
            $c->stash->{json}->{message} = $k.' is not defined';
            $c->detach;
        }
    }

    my @photos = $c->model('Schema::Photo')->area($criteria);
    my $json = { photos => [] };

    for my $photo (@photos) {
        my $photo_json = $photo->to_json;
        $photo_json->{is_like} = 1 if $c->user->obj->has_like($photo->id);
        push @{$json->{photos}}, $photo_json;
    }

    $json->{status} = 'ok';
    $c->stash->{json} = $json;
}

sub end :Private {
    my ($self, $c) = @_;
    $c->forward( $c->view('JSON') );
}

1;
