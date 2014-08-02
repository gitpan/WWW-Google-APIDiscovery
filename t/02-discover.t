#!perl

use strict; use warnings;
use WWW::Google::APIDiscovery;
use Test::More tests => 2;

my $google = WWW::Google::APIDiscovery->new;

eval { $google->discover; };
like($@, qr/ERROR: Missing mandatory param: api_id/);

eval { $google->discover('xyz'); };
like($@, qr/ERROR: Unsupported API/);

