package SquareStats::Schema::Result::ScoreMatrixOsok;
use strict;
use warnings;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table_class('DBIx::Class::ResultSource::View');
__PACKAGE__->table('score_matrix_osok');
__PACKAGE__->result_source_instance->is_virtual(1);
__PACKAGE__->result_source_instance->view_definition(
    q[
      SELECT
        kill.killer AS nick,
        SUM(CASE WHEN NOT kill.gib AND NOT kill.suicide THEN 1 ELSE 0 END) AS frags,
        SUM(CASE WHEN     kill.gib AND NOT kill.suicide THEN 1 ELSE 0 END) AS gibs,
        SUM(CASE WHEN NOT kill.gib AND     kill.suicide THEN 1 ELSE 0 END) AS suicides,
        
        SUM(CASE WHEN NOT kill.gib AND NOT kill.suicide THEN 1 ELSE 0 END)
        + 2*SUM(CASE WHEN kill.gib AND NOT kill.suicide THEN 1 ELSE 0 END)
        - SUM(CASE WHEN NOT kill.gib AND kill.suicide THEN 1 ELSE 0 END)
            AS total_score
            
      FROM kill, game
      WHERE kill.game = game.id
      AND mode = 'osok'
      GROUP BY kill.killer
    ]
);

__PACKAGE__->add_columns(
    'nick' => {
      data_type => 'varchar',
      size      => 255,
    },
    'frags' => {
      data_type => 'integer',
    },
    'gibs' => {
      data_type => 'integer',
    },
    'suicides' => {
      data_type => 'integer',
    },
    'total_score' => {
      data_type => 'integer',
    },
  );
  
1;