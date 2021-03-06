require("pg")

require_relative("album.rb")
require_relative("../db/sql_runner.rb")

class Artist

  attr_reader :id
  attr_writer :name

  def initialize(options)
    @id = options["id"]
    @name = options["name"]
  end

  def save()
    sql = "INSERT INTO artists (name) VALUES ($1) RETURNING id;"
    values = [@name]
    name = SqlRunner.run(sql, values)
    @id = name[0]["id"].to_i
  end

  def self.all()
    sql = "SELECT * FROM artists"
    results = SqlRunner.run(sql)
    results.map {|result| Artist.new(result)}
  end

  def self.delete_all()
    sql = "DELETE FROM artists"
    SqlRunner.run(sql)
  end

  def delete()
    sql1 = "DELETE FROM albums WHERE artist_id = $1"
    value1 = [@id]
    SqlRunner.run(sql1, value1)

    sql = "DELETE FROM artists WHERE id = $1"
    value = [@id]
    SqlRunner.run(sql, value)
  end

  def albums()
    sql = "SELECT * FROM albums WHERE artist_id = $1"
    values = [@id]
    albums = SqlRunner.run(sql, values)
    return albums.map{|album| Album.new(album)}
  end

  def edit()
    sql = "UPDATE artists SET name = $1 WHERE id = $2"
    values = [@name, @id]
    SqlRunner.run(sql, values)
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [id]
    artist_id = SqlRunner.run(sql, values)
    return Artist.new(artist_id[0])
  end

end
