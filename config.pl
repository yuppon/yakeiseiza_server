use utf8;
use Yakeiseiza::Models;

my $home = Yakeiseiza::Models->get('home');

return {
    database => [
        'dbi:mysql:yakeiseiza', 'root', 'root',
        {
            on_connect_do => 'SET NAMES utf8',
            mysql_enable_utf8 => 1,
            quote_char => '`',
            name_sep => '.',
        },
    ],

    limit => 8,
    url        => 'http://yakei.naka.sfc.keio.ac.jp',

    facebook => {
        app_id  => '169156959765189',
        secret  => '53eaaed22e0061ab51099b26adc3fc1b',
    },

    cache => {
        class => 'Cache::FastMmap',
        deref => 1,
        args  => {
            share_file     => $home->subdir('tmp')->file('cache')->stringify,
            unlink_on_exit => 0,
        },
    },

    'Plugin::Session::Store::Model' => {
        model => 'cache',
    },

    'Plugin::Authentication::Credential::Password' => {
        password_type => 'hashed',
        user_field => 'email',
    },

    'Plugin::Authentication::Store::DBIx::Class' => {
        model => 'Schema',
        user_field => 'email',
    },

    message => {
        not_login       => 'you are not login',
        logined         => 'already logined',
        file_not_exist  => 'file is not exists',
        invalid_email   => '正しくないメールアドレスです',
        duplicate_email => 'このメールアドレスは既に登録されています',
        has_like        => '既にﾖｲﾈをしています',
        not_has_like    => 'まだﾖｲﾈをしていません',
        not_exist_photo => 'この写真は存在しません',
    },
};

