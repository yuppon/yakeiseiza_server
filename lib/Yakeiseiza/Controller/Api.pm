package Yakeiseiza::Controller::Api;
use Ark 'Controller';
use Data::Dumper;

sub news :Local :Args(0) {
    my ($self, $c) = @_;

    my @photos = $c->model('Schema::Photo')->recent($c->req->param('page') || 1, $c->req->param('offset_id') || 0);
    my $json = { photos => [] };

    for my $photo (@photos) {
        my $photo_json = $photo->to_json;

        $photo_json->{is_like} = 0;
        if ($c->user) {
            $photo_json->{is_like} = 1 if $c->user->obj->has_like($photo->id);
        }

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
