use strict;

use lib 'lib';
use Yakeiseiza::Models;

Yakeiseiza::Models->get('Schema')->deploy({ add_drop_table => 1 });
