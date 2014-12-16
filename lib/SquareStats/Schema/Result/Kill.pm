use utf8;
package SquareStats::Schema::Result::Kill;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

SquareStats::Schema::Result::Kill

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<kill>

=cut

__PACKAGE__->table("kill");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'kill_id_seq'

=head2 game

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 killer

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 victim

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 weapon

  data_type: 'enum'
  extra: {custom_type_name => "weapon_t",list => ["knife","pistol","carbine","shotgun","subgun","sniper","assault","grenade"]}
  is_nullable: 0

=head2 time

  data_type: 'integer'
  is_nullable: 0

=head2 gib

  data_type: 'boolean'
  is_nullable: 0

=head2 suicide

  data_type: 'boolean'
  is_nullable: 0

=head2 killer_x

  data_type: 'real'
  is_nullable: 0

=head2 killer_y

  data_type: 'real'
  is_nullable: 0

=head2 killer_z

  data_type: 'real'
  is_nullable: 0

=head2 victim_x

  data_type: 'real'
  is_nullable: 0

=head2 victim_y

  data_type: 'real'
  is_nullable: 0

=head2 victim_z

  data_type: 'real'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "kill_id_seq",
  },
  "game",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "killer",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "victim",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "weapon",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "weapon_t",
      list => [
        "knife",
        "pistol",
        "carbine",
        "shotgun",
        "subgun",
        "sniper",
        "assault",
        "grenade",
      ],
    },
    is_nullable => 0,
  },
  "time",
  { data_type => "integer", is_nullable => 0 },
  "gib",
  { data_type => "boolean", is_nullable => 0 },
  "suicide",
  { data_type => "boolean", is_nullable => 0 },
  "killer_x",
  { data_type => "real", is_nullable => 0 },
  "killer_y",
  { data_type => "real", is_nullable => 0 },
  "killer_z",
  { data_type => "real", is_nullable => 0 },
  "victim_x",
  { data_type => "real", is_nullable => 0 },
  "victim_y",
  { data_type => "real", is_nullable => 0 },
  "victim_z",
  { data_type => "real", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 game

Type: belongs_to

Related object: L<SquareStats::Schema::Result::Game>

=cut

__PACKAGE__->belongs_to(
  "game",
  "SquareStats::Schema::Result::Game",
  { id => "game" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-12-16 14:59:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tpY8B1kixYqwuzraDOW8ug
# These lines were loaded from '/home/rikki/perl5/perlbrew/perls/perl-5.20.0/lib/site_perl/5.20.0/SquareStats/Schema/Result/Kill.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package SquareStats::Schema::Result::Kill;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

SquareStats::Schema::Result::Kill

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<kill>

=cut

__PACKAGE__->table("kill");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'kill_id_seq'

=head2 game

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 killer

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 victim

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 weapon

  data_type: 'enum'
  extra: {custom_type_name => "weapon_t",list => ["knife","pistol","carbine","shotgun","subgun","sniper","assault","grenade"]}
  is_nullable: 0

=head2 time

  data_type: 'timestamp with time zone'
  is_nullable: 0

=head2 gib

  data_type: 'boolean'
  is_nullable: 0

=head2 suicide

  data_type: 'boolean'
  is_nullable: 0

=head2 killer_x

  data_type: 'real'
  is_nullable: 0

=head2 killer_y

  data_type: 'real'
  is_nullable: 0

=head2 killer_z

  data_type: 'real'
  is_nullable: 0

=head2 victim_x

  data_type: 'real'
  is_nullable: 0

=head2 victim_y

  data_type: 'real'
  is_nullable: 0

=head2 victim_z

  data_type: 'real'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "kill_id_seq",
  },
  "game",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "killer",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "victim",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "weapon",
  {
    data_type => "enum",
    extra => {
      custom_type_name => "weapon_t",
      list => [
        "knife",
        "pistol",
        "carbine",
        "shotgun",
        "subgun",
        "sniper",
        "assault",
        "grenade",
      ],
    },
    is_nullable => 0,
  },
  "time",
  { data_type => "timestamp with time zone", is_nullable => 0 },
  "gib",
  { data_type => "boolean", is_nullable => 0 },
  "suicide",
  { data_type => "boolean", is_nullable => 0 },
  "killer_x",
  { data_type => "real", is_nullable => 0 },
  "killer_y",
  { data_type => "real", is_nullable => 0 },
  "killer_z",
  { data_type => "real", is_nullable => 0 },
  "victim_x",
  { data_type => "real", is_nullable => 0 },
  "victim_y",
  { data_type => "real", is_nullable => 0 },
  "victim_z",
  { data_type => "real", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 game

Type: belongs_to

Related object: L<SquareStats::Schema::Result::Game>

=cut

__PACKAGE__->belongs_to(
  "game",
  "SquareStats::Schema::Result::Game",
  { id => "game" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-12-15 21:47:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/MZmP/7ysfAtW79t5iMqiA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/home/rikki/perl5/perlbrew/perls/perl-5.20.0/lib/site_perl/5.20.0/SquareStats/Schema/Result/Kill.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
