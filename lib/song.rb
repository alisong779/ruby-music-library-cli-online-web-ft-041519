require 'pry'
class Song 
   attr_accessor :name, :artist, :genre  
  @@all = [] 
  
  def initialize(name, artist=nil, genre=nil)
    @name = name 
    self.artist=artist if artist 
    self.genre=genre if genre 
    #initialize artist= and/or genre= method if artist and/or genre are passed in 
  end 
  
  def self.all 
    @@all 
  end 
  
  def save
    @@all << self     
    self 
  end
  
  def self.destroy_all
    @@all.clear
  end 
      
  def self.create(song, artist=nil, genre=nil) 
    new_song = self.new(song, artist, genre)
    new_song.save
    new_song 
  end 
  
  def artist=(artist)
    @artist = artist
    artist.add_song(self)
    #assigning the passed in artist to the artist attr 
    #calling on the add song method on passed in artist, setting the arg for add_song(song) to self. 
  end 
  
  def genre=(genre)
    @genre = genre
    if !(genre.songs.include?(self))
      genre.songs << self
    # if genre doesnt include self in songs var then add self
    end 
  end 
  
  def self.find_by_name(name) 
    self.all.detect {|song| song.name == name}   
  end 
  
  def self.find_or_create_by_name(name) 
      song = self.find_by_name(name)
        if song == nil 
          self.create(name)
        else
          song 
        end 
  end 
  
  def self.new_from_filename(filename)
    song_name = filename.split(" - ")[1]
    artistname = filename.split(" - ")[0]
    genrename = filename.split(" - ")[2].gsub(".mp3", "")
    artist = Artist.find_or_create_by_name(artistname)
    genre = Genre.find_or_create_by_name(genrename)
    new(song_name, artist, genre) 
    #splitting the passed in filename by index, assigning to new var's. using the new var's to invoke find_or_create_by_name
    #on Artist and Genre classes. Creating a new song instance based on the new var song names.
  end 

  def self.create_from_filename(filename)
     new_from_filename(filename).tap {|s| s.save}
     #called on by the importer - then calls new_from_filename to format the filename correctly and create new instances as needed
  end 

end


  # the .create method calls on .save method which saves the instance to @@all
  #.save method eliminates the need for @@all << self on initialize
  #   new_from_filename, which instantiates a new Song object based on a provided filename.
  # .create_from_filename, which does the same thing as .new_from_filename but also saves the newly-created song
  # to the @@all class variable.
  # Song
  #artist=
  #assigns an artist to the song (song belongs to artist) artist=
  #invokes Artist#add_song to add itself to the artist's collection of songs(artist has many songs) 
  # #initialize
  #invokes #artist= instead of simply assigning to an @artist instance variable to ensure that associations are created upon initialization 
      
