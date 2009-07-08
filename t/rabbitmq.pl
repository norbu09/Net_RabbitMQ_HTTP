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
print "** Service: " . $service->{service} . "\n";
if ($service) {

    my $_queue = {
        uri     => $uri,
        queue   => $queue,
        service => $service->{service},
    };

    #my $res = Net::RabbitMQ::HTTP::queue_declare($_queue);
    #print "** Queue declare: $res **\n";

    my $_pub = {
        uri     => $uri,
        queue   => $queue,
        service => $service->{service},
        message => $message,
    };

    #my $res = Net::RabbitMQ::HTTP::basic_publish($_pub);
    my $res = Net::RabbitMQ::HTTP::basic_consume($_pub);
    print Dumper($res);
    $res = Net::RabbitMQ::HTTP::poll($_pub);
    print Dumper($res);
    if ( $res->[0] ) {
        print "** msg: " . $res->[0]->{content} . "\n";
        $_pub->{tag} = $res->[0]->{args}->[0];
        $res = Net::RabbitMQ::HTTP::basic_ack($_pub);
    }
    $res = Net::RabbitMQ::HTTP::basic_cancel($_pub);
    print Dumper($res);
    $res = Net::RabbitMQ::HTTP::logout($_pub);
    print Dumper($res);
}
