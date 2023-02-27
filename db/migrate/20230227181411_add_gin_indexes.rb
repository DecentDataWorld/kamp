class AddGinIndexes < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX idx_fts_resources_name ON resources USING GIN (to_tsvector('english', name));
      CREATE INDEX idx_fts_resources_description ON resources USING GIN (to_tsvector('english', description));
      CREATE INDEX idx_fts_resources_concat ON resources USING GIN (to_tsvector('english', name || ' ' || description));

      CREATE INDEX idx_fts_collections_name ON collections USING GIN (to_tsvector('english', title));
      CREATE INDEX idx_fts_collections_description ON collections USING GIN (to_tsvector('english', description));
      CREATE INDEX idx_fts_collections_concat ON collections USING GIN (to_tsvector('english', title || ' ' || description));
    SQL
  end

  def down
    DROP INDEX idx_fts_resources_name;
    DROP INDEX idx_fts_resources_description;
    DROP INDEX idx_fts_resources_concat;

    DROP INDEX idx_fts_collections_name;
    DROP INDEX idx_fts_collections_description;
    DROP INDEX idx_fts_collections_concat;
  end
end
