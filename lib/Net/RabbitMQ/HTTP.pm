package Net::RabbitMQ::HTTP;

use warnings;
use strict;
use JSON;
use Net::RabbitMQ::HTTP::RPC;

=head1 NAME

Net::RabbitMQ::HTTP - The great new Net::RabbitMQ::HTTP!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Net::RabbitMQ::HTTP;

    my $foo = Net::RabbitMQ::HTTP->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 login

=cut

sub login {
    my $params = shift;
    my $req    = {
        method => 'open',
        params => [
            $params->{user},    # user
            $params->{pass},    # pass
            5,                  # channel timeout
            undef               # virtual host
        ],
    };
    $params->{uri} .= 'rabbitmq';
    my $res = Net::RabbitMQ::HTTP::RPC::call( $req, $params->{uri} );
    if ( $res->{result}->{service} ) {
        return $res->{result}->{service};
    }
    else {
        return $res->{error}->{message};
    }
}

sub queue_declare {
    my $params = shift;
    my $req    = {
        method => 'call',
        name   => $params->{service},
        params => [
            'queue.declare' => [
                1,                   # ticket
                $params->{queue},    # queue
                JSON::false,         # passive
                JSON::false,         # durable
                JSON::false,         # exclusive
                JSON::true,          # auto_delete
                JSON::false,         # nowait
                {}                   # arguments
            ]
        ],
    };
    $params->{uri} .= $params->{service};
    my $res = Net::RabbitMQ::HTTP::RPC::call( $req, $params->{uri} );
    if ($res) {
        return $res->{result}->{method};
    }
    else {
        return $res->{error}->{message};
    }
}

sub basic_publish {
    my $params = shift;
    my $req    = {
        method => 'cast',
        name   => $params->{service},
        params => [
            'basic.publish' => [
                1,                   # ticket
                "",                  # exchange
                $params->{queue},    # routing key
                JSON::false,         # mandatory
                JSON::false          # immediate
            ],
            $params->{message},
            [
                undef,               # content_type
                undef,               # content_encoding
                undef,               # headers
                undef,               # delivery_mode
                undef,               # priority
                undef,               # correlation_id
                undef,               # reply_to
                undef,               # expiration
                undef,               # message_id
                undef,               # timestamp
                undef,               # type
                undef,               # user_id
                undef,               # app_id
                undef                # cluster_id
            ]
        ],
    };
    $params->{uri} .= $params->{service};
    my $res = Net::RabbitMQ::HTTP::RPC::call( $req, $params->{uri} );
    if ($res) {

        #return $res->{result}->{method};
        return $res;
    }
    else {

        #return $res->{error}->{message};
        return $res;
    }
}

=head1 AUTHOR

Lenz Gschwendtner, C<< <norbu09 at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-net-rabbitmq-http at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net-RabbitMQ-HTTP>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::RabbitMQ::HTTP


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-RabbitMQ-HTTP>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-RabbitMQ-HTTP>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-RabbitMQ-HTTP>

=item * Search CPAN

L<http://search.cpan.org/dist/Net-RabbitMQ-HTTP/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Lenz Gschwendtner, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1;    # End of Net::RabbitMQ::HTTP
