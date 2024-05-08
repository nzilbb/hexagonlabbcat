
/* version 0.21 */
CREATE TABLE {0}_speaker_field (
  attribute VARCHAR(50) NOT NULL,
  data_type VARCHAR(50) NOT NULL,
  label VARCHAR(50) NOT NULL,
  description VARCHAR(50) NOT NULL,
  display_order INTEGER NOT NULL,
  searchable INTEGER NOT NULL,
  search_results INTEGER NOT NULL,
  display INTEGER NOT NULL,
  PRIMARY KEY  (attribute)
);

CREATE TABLE {0}_transcript_field (
  attribute VARCHAR(50) NOT NULL,
  data_type VARCHAR(50) NOT NULL,
  label VARCHAR(50) NOT NULL,
  description VARCHAR(50) NOT NULL,
  display_order INTEGER NOT NULL,
  searchable INTEGER NOT NULL,
  search_results INTEGER NOT NULL,
  display INTEGER NOT NULL,
  PRIMARY KEY  (attribute)
);

