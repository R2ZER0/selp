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
        killer,
        SUM(CASE WHEN NOT gib AND NOT suicide THEN 1 ELSE 0 END) AS frags,
        SUM(CASE WHEN     gib AND NOT suicide THEN 1 ELSE 0 END) AS gibs,
        SUM(CASE WHEN NOT gib AND     suicide THEN 1 ELSE 0 END) AS suicides,
        ((frags + 2*gibs) - suicides) AS total_score
      FROM kill NATURAL JOIN game
      WHERE mode = 'osok'
      GROUP BY killer      
    ]
);