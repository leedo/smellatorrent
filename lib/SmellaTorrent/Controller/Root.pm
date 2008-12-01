package SmellaTorrent::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';

use Data::Dumper;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

SmellaTorrent::Controller::Root - Root Controller for SmellaTorrent

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 default

=cut
sub auto : Private {
	my ( $self, $c ) = @_;
	if ( ! $c->authenticate_http ) {
		$c->authorization_required_response( realm => "SmellaTorrent" );
	}
	$c->error(0);
}

sub stopall : Local {
	my ( $self, $c ) = @_;
	eval {
		$c->model('Rtorrent')->send_request("d.multicall","main","d.stop=")->value;
	};
	$c->res->redirect( $c->req->base );
}

sub startall : Local {
	my ( $self, $c ) = @_;
	eval {
		$c->model('Rtorrent')->send_request("d.multicall","main","d.start=")->value;
	};
	$c->res->redirect( $c->req->base );
}

sub index : Private {
	my ( $self, $c ) = @_;
	$c->forward('status');
}

sub views : Regex('(main|name|started|stopped|complete|incomplete|hashing|seeding)') {
	my ( $self, $c ) = @_;
	$c->stash->{view} = $c->req->captures->[0];
	$c->stash->{template} = 'index.tt';
	$c->forward('status');
}

sub control : Regex('^(erase|stop|start)$') {
	my ( $self, $c ) = @_;
	my $hash = $c->req->param('id');
	my $action = $c->req->captures->[0];
	if ($hash =~ /[\d\w]+/) {
		eval {
			$c->model('Rtorrent')->send_request("d.$action",$hash)->value;
		};
		$c->stash->{error} = $@ if $@;
	}
	$c->res->redirect( $c->req->base );
}

sub status : Private {
    my ( $self, $c ) = @_;

	if (! exists $c->stash->{view}) {
		$c->stash->{view} = 'name';
	}

	my @status;
		$c->stash->{total} = {
			up_rate => 0,
			down_rate => 0,
			torrents => 0,
		};
		my $info = $c->model('Rtorrent')->send_request('d.multicall',
			$c->stash->{view},
			'd.get_name=',
			'd.is_active=',
			'd.get_ratio=',
			'd.get_size_bytes=',
			'd.get_completed_bytes=',
			'd.get_up_total=',
			'd.get_down_rate=',
			'd.get_up_rate=',
			'd.get_hash=',
			'd.get_state=',
		)->value;
		for (@$info) {
			$c->stash->{data} = $info;
			$c->stash->{total}{up_rate} += $_->[7];
			$c->stash->{total}{down_rate} += $_->[6];
			$c->stash->{total}{torrents} ++;
			push @status, {
				name		=> $_->[0],
				active		=> $_->[1],
				ratio		=> sprintf("%.2f",$_->[2] / 100),
				size		=> $_->[3],
				size_formatted	=> int(($_->[3]) / 1024 / 1024),
				completed	=>  $_->[4],
				uploaded	=> $_->[5],
				down_rate	=> $_->[6],
				up_rate		=> $_->[7],
				id			=> $_->[8],
				state		=> $_->[9],
			};
		}
	$@ ? $c->stash->{error} = ($@) : $c->stash->{status} = \@status;
}

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

lee,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
