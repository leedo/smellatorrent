package SmellaTorrent::Model::Rtorrent;

use strict;
use warnings;
use base 'Catalyst::Model::XMLRPC';

__PACKAGE__->config(
    location => 'http://localhost/RPC2',
    # For more options take a look at L<RPC::XML::Client>.
);

=head1 NAME

SmellaTorrent::Model::Rtorrent - XMLRPC Catalyst model component

=head1 SYNOPSIS

See L<SmellaTorrent>.

=head1 DESCRIPTION

XMLRPC Catalyst model component.

=head1 AUTHOR

lee,,,

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
