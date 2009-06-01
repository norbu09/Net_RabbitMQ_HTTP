#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Net::RabbitMQ::HTTP' );
}

diag( "Testing Net::RabbitMQ::HTTP $Net::RabbitMQ::HTTP::VERSION, Perl $], $^X" );
