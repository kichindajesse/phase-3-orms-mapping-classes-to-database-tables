require 'sqlite3'

class Song
  attr_accessor :id, :name, :album

  def initialize(name:, album:)
    @id = nil
    @name = name
    @album = album
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS songs (id INTEGER PRIMARY KEY, name TEXT, album TEXT)")
  end

  def save
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.album)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    self
  end

  def self.create(name:, album:)
    song = self.new(name: name, album: album)
    song.save
    song
  end
end

DB = {:conn => SQLite3::Database.new("db/music.db")}
