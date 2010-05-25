use inc::Module::Install;

name     'Net-RabbitMQ-HTTP';
all_from 'lib/Net/RabbitMQ/HTTP.pm';
author   'Lenz Gschwendtner <norbu09@cpan.org>';
license  'perl';

build_requires 'Test::More';

requires 'JSON';
requires 'LWP::UserAgent';

auto_install;

WriteAll;

