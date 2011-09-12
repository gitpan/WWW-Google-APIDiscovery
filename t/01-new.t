#!perl

use strict; use warnings;
use WWW::Google::APIDiscovery;
use Test::More tests => 1;

eval { WWW::Google::APIDiscovery->new('buzzz'); };
like($@, qr/Attribute \(api\) does not pass the type constraint/);