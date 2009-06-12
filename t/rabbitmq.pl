#!/usr/bin/perl -Ilib

use strict;
use warnings;
use Net::RabbitMQ::HTTP;
use Data::Dumper;

my $user = 'guest';
my $pass = 'guest';
my $uri = 'http://localhost:55672/rpc/';
my $queue = 'test';
my $message = "helo world";
my $service = Net::RabbitMQ::HTTP::login($user, $pass, $uri);
print "** Service: $service\n";
my $res;
if($service){
    $res = Net::RabbitMQ::HTTP::queue_declare($queue, $service, $uri);
    print "** Queue declare: $res **\n";
    $res = Net::RabbitMQ::HTTP::basic_publish($message, $queue, $service, $uri);
}
print Dumper($res);
