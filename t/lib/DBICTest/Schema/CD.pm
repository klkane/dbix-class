package # hide from PAUSE 
    DBICTest::Schema::CD;

use base 'DBIx::Class::Core';

__PACKAGE__->table('cd');
__PACKAGE__->add_columns(
  'cdid' => {
    data_type => 'integer',
    is_auto_increment => 1,
  },
  'artist' => {
    data_type => 'integer',
  },
  'title' => {
    data_type => 'varchar',
    size      => 100,
  },
  'year' => {
    data_type => 'varchar',
    size      => 100,
  },
  'genreid' => { 
    data_type => 'integer' 
  }
);
__PACKAGE__->set_primary_key('cdid');
__PACKAGE__->add_unique_constraint([ qw/artist title/ ]);

__PACKAGE__->belongs_to( artist => 'DBICTest::Schema::Artist', undef, { 
    is_deferrable => 1, 
    on_delete => undef,
    on_update => 'SET NULL',
});

__PACKAGE__->has_many( tracks => 'DBICTest::Schema::Track' );
__PACKAGE__->has_many(
    tags => 'DBICTest::Schema::Tag', undef,
    { order_by => 'tag' },
);
__PACKAGE__->has_many(
    cd_to_producer => 'DBICTest::Schema::CD_to_Producer' => 'cd'
);

__PACKAGE__->might_have(
    liner_notes => 'DBICTest::Schema::LinerNotes', undef,
    { proxy => [ qw/notes/ ] },
);
__PACKAGE__->many_to_many( producers => cd_to_producer => 'producer' );
__PACKAGE__->many_to_many(
    producers_sorted => cd_to_producer => 'producer',
    { order_by => 'producer.name' },
);

__PACKAGE__->belongs_to('genre', 'DBICTest::Schema::Genre', { 'foreign.genreid' => 'self.genreid' });

#__PACKAGE__->add_relationship('genre', 'DBICTest::Schema::Genre',
#    { 'foreign.genreid' => 'self.genreid' },
#    { 'accessor' => 'single' }
#);

1;
