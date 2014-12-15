use strict;
use warnings;

use SquareStats::App;

my $app = SquareStats::App->apply_default_middlewares(SquareStats::App->psgi_app);
$app;

