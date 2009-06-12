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

=head2 function1

=cut

sub login {
    my ($user,$pass, $uri) = @_;
    my $req = {
        method => 'open',
        params => [$user, $pass, 5, undef],
    };
    $uri .= 'rabbitmq';
    my $res = Net::RabbitMQ::HTTP::RPC::call($req, $uri);
    if($res->{result}->{service}){
        return $res->{result}->{service};
    } else {
        return $res->{error}->{message};
    }
}

sub queue_declare {
    my ($queue, $service, $uri) = @_;
    my $req = {
        method => 'call',
        name => $service,
        params => ['queue.declare' => [1, $queue,JSON::false,JSON::false,JSON::false,JSON::true,JSON::false, {}]],
    };
    $uri .= $service;
    my $res = Net::RabbitMQ::HTTP::RPC::call($req, $uri);
    if($res){
        return $res->{result}->{method};
    } else {
        return $res->{error}->{message};
    }
}

sub basic_publish {
    my ($message, $queue, $service, $uri) = @_;
    my $req = {
        method => 'cast',
        name => $service,
        params => ['basic.publish' => [1, "", $queue,JSON::false,JSON::false],
            $message,
            [undef, undef, undef, undef, undef, undef, undef, undef, undef, undef, undef, undef, undef, undef ]],
    };
    $uri .= $service;
    my $res = Net::RabbitMQ::HTTP::RPC::call($req, $uri);
    if($res){
        #return $res->{result}->{method};
        return $res;
    } else {
        #return $res->{error}->{message};
        return $res;
    }
}

=head2 function2

=cut

sub function2 {
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

1; # End of Net::RabbitMQ::HTTP
