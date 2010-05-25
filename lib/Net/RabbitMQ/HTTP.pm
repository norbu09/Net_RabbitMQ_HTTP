package Net::RabbitMQ::HTTP;

use warnings;
use strict;
use JSON;
use Net::RabbitMQ::HTTP::RPC;

=head1 NAME

Net::RabbitMQ::HTTP - The great new Net::RabbitMQ::HTTP!

=head1 VERSION

Version 0.2

=cut

our $VERSION = '0.2';

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
            $params->{timeout} || 5,    # channel timeout
            $params->{vhost}            # virtual host
        ],
    };
    $params->{service} = 'rabbitmq';
    return _call( $req, $params );
}

sub logout {
    my $params = shift;
    my $req    = {
        method => 'close',
        params => [],
    };
    return _call( $req, $params );
}

sub exchange_declare {
    my $params = shift;
    my $req    = {
        method => 'call',
        name   => $params->{service},
        params => [
            'exchange.declare' => [
                $params->{ticket} || 1,    # ticket
                $params->{exchange},       # exchange
                $params->{type} || "direct",    # exchange type
                ( $params->{passive}     ? JSON::true : JSON::false ), # passive
                ( $params->{durable}     ? JSON::true : JSON::false ), # durable
                ( $params->{auto_delete} ? JSON::true : JSON::false )
                ,    # auto_delete
                ( $params->{internal} ? JSON::true : JSON::false ),   # internal
                ( $params->{nowait}   ? JSON::true : JSON::false ),   # nowait
                {}    # arguments
            ]
        ],
    };
    return _call( $req, $params );
}

sub queue_declare {
    my $params = shift;
    my $req    = {
        method => 'call',
        name   => $params->{service},
        params => [
            'queue.declare' => [
                $params->{ticket} || 1,    # ticket
                $params->{queue},          # queue
                ( $params->{passive}   ? JSON::true : JSON::false ), # passive
                ( $params->{durable}   ? JSON::true : JSON::false ), # durable
                ( $params->{exclusive} ? JSON::true : JSON::false ), # exclusive
                ( $params->{auto_delete} ? JSON::true : JSON::false )
                ,    # auto_delete
                ( $params->{nowait} ? JSON::true : JSON::false ),    # nowait
                {}                                                   # arguments
            ]
        ],
    };
    return _call( $req, $params );
}

sub queue_delete {
    my $params = shift;
    my $req    = {
        method => 'call',
        name   => $params->{service},
        params => [
            'queue.delete' => [
                $params->{ticket} || 1,    # ticket
                $params->{queue},          # queue
                ( $params->{if_unused} ? JSON::true : JSON::false ), # if_unused
                ( $params->{if_empty}  ? JSON::true : JSON::false ), # if_empty
                ( $params->{nowait}    ? JSON::true : JSON::false ), # nowait
            ]
        ],
    };
    return _call( $req, $params );
}

sub queue_bind {
    my $params = shift;
    my $req    = {
        method => 'call',
        name   => $params->{service},
        params => [
            'queue.bind' => [
                $params->{ticket} || 1,    # ticket
                $params->{queue},          # queue
                $params->{exchange},       # exchange
                $params->{routing_key},    # routhing key
                ( $params->{nowait} ? JSON::true : JSON::false ),    # nowait
                {}                                                   # arguments
            ]
        ],
    };
    return _call( $req, $params );
}

sub basic_publish {
    my $params = shift;
    my $req    = {
        method => 'cast',
        name   => $params->{service},
        params => [
            'basic.publish' => [
                $params->{ticket}   || 1,     # ticket
                $params->{exchange} || "",    # exchange
                $params->{queue},             # routing key
                ( $params->{mandatory} ? JSON::true : JSON::false ), # mandatory
                ( $params->{immediate} ? JSON::true : JSON::false ), # immediate
            ],
            $params->{message},
            [
                $parms->{content_type}      || undef,    # content_type
                $params->{content_encoding} || undef,    # content_encoding
                $params->{headers}          || undef,    # headers
                $params->{delivery_mode}    || undef,    # delivery_mode
                $params->{priority}         || undef,    # priority
                $params->{correlation_id}   || undef,    # correlation_id
                $params->{reply_to}         || undef,    # reply_to
                $params->{expiration}       || undef,    # expiration
                $params->{message_id}       || undef,    # message_id
                $params->{timestamp}        || undef,    # timestamp
                $params->{type}             || undef,    # type
                $params->{user_id}          || undef,    # user_id
                $params->{app_id}           || undef,    # app_id
                $params->{cluster_id}       || undef     # cluster_id
            ]
        ],
    };
    return _call( $req, $params );
}

sub basic_consume {
    my $params = shift;
    my $req    = {
        method => 'call',
        name   => $params->{service},
        params => [
            'basic.consume' => [
                $params->{ticket} || 1,    # ticket
                $params->{queue},          # queue
                $params->{tag} || "",      # consumer tag
                ( $params->{no_local}  ? JSON::true : JSON::false ), # no_local
                ( $params->{no_ack}    ? JSON::true : JSON::false ), # no_ack
                ( $params->{exclusive} ? JSON::true : JSON::false ), # exclusive
                ( $params->{nowait}    ? JSON::true : JSON::false ), # nowait
            ],
        ],
    };
    return _call( $req, $params );
}

sub poll {
    my $params = shift;
    my $req    = {
        method => 'poll',
        name   => $params->{service},
        params => [],
    };
    return _call( $req, $params );
}

sub basic_ack {
    my $params = shift;
    my $req    = {
        method => 'cast',
        name   => $params->{service},
        params => [
            'basic.ack' => [
                $params->{ticket} || 1,    # ticket
                ( $params->{multiple} ? JSON::true : JSON::false ),   # multiple
            ],
            $params->{message},
            [
                $parms->{content_type}      || undef,    # content_type
                $params->{content_encoding} || undef,    # content_encoding
                $params->{headers}          || undef,    # headers
                $params->{delivery_mode}    || undef,    # delivery_mode
                $params->{priority}         || undef,    # priority
                $params->{correlation_id}   || undef,    # correlation_id
                $params->{reply_to}         || undef,    # reply_to
                $params->{expiration}       || undef,    # expiration
                $params->{message_id}       || undef,    # message_id
                $params->{timestamp}        || undef,    # timestamp
                $params->{type}             || undef,    # type
                $params->{user_id}          || undef,    # user_id
                $params->{app_id}           || undef,    # app_id
                $params->{cluster_id}       || undef     # cluster_id
            ]
        ],
    };
    return _call( $req, $params );
}

sub basic_cancel {
    my $params = shift;
    my $req    = {
        method => 'call',
        name   => $params->{service},
        params => [
            'basic.cancel' => [
                $params->{service},    # ticket
                ( $params->{nowait} ? JSON::true : JSON::false ),    # nowait
            ],
        ],
    };
    return _call( $req, $params );
}

sub _call {
    my ( $req, $params ) = @_;
    $params->{uri} .= $params->{service}
      unless $params->{uri} =~ /.*[\d\w]{10}$/;
    my $res = Net::RabbitMQ::HTTP::RPC::call( $req, $params->{uri} );
    return _filter($res);
}

sub _filter {
    my $msg = shift;
    if ( $msg->{error} ) {
        return $msg->{error};
    }
    else {
        return $msg->{result};

        #return $msg;
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
