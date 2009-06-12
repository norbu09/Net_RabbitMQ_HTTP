#!/usr/bin/perl -Ilib

use strict;
use warnings;
use Net::RabbitMQ::HTTP;
use Data::Dumper;

my $user    = 'guest';
my $pass    = 'guest';
my $uri     = 'http://localhost:55672/rpc/';
my $queue   = 'test';
my $message = "helo world";

my $_open = {
    uri  => $uri,
    user => $user,
    pass => $pass,
};

my $service = Net::RabbitMQ::HTTP::login($_open);
print "** Service: $service\n";
if ($service) {

    my $_queue = {
        uri     => $uri,
        queue   => $queue,
        service => $service,
    };

    my $res = Net::RabbitMQ::HTTP::queue_declare($_queue);
    print "** Queue declare: $res **\n";

    my $_pub = {
        uri     => $uri,
        queue   => $queue,
        service => $service,
        message => $message,
    };
    $res = Net::RabbitMQ::HTTP::basic_publish($_pub);
    print Dumper($res);
}
