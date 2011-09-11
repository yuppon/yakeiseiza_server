package Yakeiseiza;
use Ark;

our $VERSION = '0.01';

use_model 'Yakeiseiza::Models';

use_plugins qw/
    Authentication
    Authentication::Credential::Password
    Authentication::Store::DBIx::Class
    Session
    Session::Store::Model
    Session::State::Cookie
/;

1;
