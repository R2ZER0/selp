use utf8;
package SquareStats::Schema::Result::Game;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

SquareStats::Schema::Result::Game

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<game>

=cut

__PACKAGE__->table("game");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'game_id_seq'

=head2 server

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 map

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 mode

  data_type: 'enum'
  extra: {custom_type_name => "mode_t",list => ["osok","tosok","tdm","ctf"]}
  is_nullable: 0

=head2 start_time

  data_type: 'timestamp with time zone'
  is_nullable: 0

=head2 end_time

  data_type: 'timestamp with time zone'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "game_id_seq",
  },
  "server",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "map",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "mode",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "mode_t",
      list => ["osok", "tosok", "tdm", "ctf"],
    },
    is_nullable => 0,
  },
  "start_time",
  { data_type => "timestamp with time zone", is_nullable => 0 },
  "end_time",
  { data_type => "timestamp with time zone", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 kills

Type: has_many

Related object: L<SquareStats::Schema::Result::Kill>

=cut

__PACKAGE__->has_many(
  "kills",
  "SquareStats::Schema::Result::Kill",
  { "foreign.game" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-12-16 15:25:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:q7je6gbAq4clxby1Cwcmqw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
