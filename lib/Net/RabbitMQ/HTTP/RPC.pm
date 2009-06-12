#!/usr/bin/perl -Ilib

package Net::RabbitMQ::HTTP::RPC;

use strict;
use warnings;
use LWP::UserAgent;
use Carp;
use JSON;

sub call {
    my ($req, $uri) = @_;
    $uri = 'http://localhost:55672/rpc/rabbitmq' unless $uri;
    $req->{version} = '1.1';
    $req->{address} = $uri,
    $req->{id} = int(rand(time));
    print STDERR "** ".to_json($req)."\n";
    my $res = _post($uri, to_json($req));
    return(from_json($res));
}

sub _post {
    my ( $uri, $content ) = @_;
    my $ua = _init();
    my $res = $ua->post(
        $uri,
        Content_Type => 'application/json',
        Content      => $content,
        Accept       => 'application/json',
    );
    if ( $res->is_success ) {
        return $res->content;
    }
    else {
        carp $res->status_line;
    }
}

sub _get {
    my ($uri) = @_;
    my $ua = _init();
    my $res = $ua->get( $uri, Accept => 'application/json', );
    if ( $res->is_success ) {
        return $ua->content;
    }
    else {
        carp $res->status_line;
    }
}

sub _init {
    return my $ua = LWP::UserAgent->new(
        agent   => 'RabbitMQ::HTTP/' . $Net::RabbitMQ::HTTP::VERSION . ' beta ',
        timeout => 10,
    );
}

1;
