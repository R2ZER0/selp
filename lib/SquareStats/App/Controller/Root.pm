package SquareStats::App::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

SquareStats::App::Controller::Root - Root Controller for SquareStats::App

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->redirect('/leaderboard');
}

=head2 leaderboard

A leaderboard of the top scorers

=cut

sub leaderboard :Global {
    my ( $self, $c ) = @_;
    
    my $topten = $c->model('SS::Kill')->search({
        -and => [
            suicide => 'FALSE',
            gib => 'FALSE',
        ]
    }, {
        select => [ 'killer', { count => 'id' } ],
        as => [qw/ killer kills /],
        group_by => 'killer',
        order_by => 'kills',
        rows => 10,
    });
    
    $c->stash(leaders => $topten);
    $c->stash(template => 'leaderboard.tt');
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Rikki Guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
