require_relative '../services/database_service'

class Game
  attr_accessor :appid, :name, :description, :image, :developer

  def initialize(appid:, name:, description:, image:, developer:)
    @appid = appid
    @name = name
    @description = description
    @image = image
    @developer = developer
  end

  def self.find(appid)
    data = DatabaseService.instance.find_game(appid)
    if data
      new(appid: appid, name: data['name'], description: data['description'], image: data['image'], developer: data['developer'])
    else
      nil
    end
  end

  def save
    DatabaseService.instance.save_game(@appid, {
      'name' => @name,
      'description' => @description,
      'image' => @image,
      'developer' => @developer
    })
  end
end