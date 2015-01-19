package SquareStats::App::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
    TIMER => 1, # Show timer stats in comments
    WRAPPER => 'wrapper.tt', # Set the main wrapper template
);

=head1 NAME

SquareStats::App::View::HTML - TT View for SquareStats::App

=head1 DESCRIPTION

TT View for SquareStats::App.

=head1 SEE ALSO

L<SquareStats::App>

=head1 AUTHOR

Rikki Guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
