require 'net/http'
require 'json'
 
URL_MICROSERVICE_PLAYER = 'http://localhost:8081'
URL_MICROSERVICE_MONSTER = 'http://localhost:8082'
URL_MICROSERVICE_MAP = 'http://localhost:8083'

# From “Code example of using REST in Ruby on Rails” by LEEjava
# https://leejava.wordpress.com/2009/04/10/code-example-to-use-rest-in-ruby-on-rails/
#
module RESTful
   
  def self.get(url)
    uri = URI.parse(url)
    http = Net::HTTP.start(uri.host, uri.port)
    resp = http.send_request('GET', uri.request_uri)
    JSON.parse(resp.body)
  end
 
  def self.post(url, data, content_type)
    uri = URI.parse(url)
    http = Net::HTTP.start(uri.host, uri.port)
    resp = http.send_request('POST', uri.request_uri, data, 'Content-Type' => content_type)
    JSON.parse(resp.body)
  end
 
  def self.put(url, data, content_type)
    uri = URI.parse(url)
    http = Net::HTTP.start(uri.host, uri.port)
    resp = http.send_request('PUT', uri.request_uri, data, 'Content-Type' => content_type)
    JSON.parse(resp.body)
  end
 
  def self.delete(url)
    uri = URI.parse(url)
    http = Net::HTTP.start(uri.host, uri.port)
    resp = http.send_request('DELETE', uri.request_uri)
    JSON.parse(resp.body)
  end
end

class Game
  
  # Initializes the map and deletes the monsters generated in the previous game
  def initialize
    RESTful.delete("#{URL_MICROSERVICE_MAP}/map")
    RESTful.get("#{URL_MICROSERVICE_MAP}/map")
    RESTful.delete("#{URL_MICROSERVICE_MONSTER}/monsters")
  end
  
  # Principal menu
  def menu
    loop do
      puts ""
      puts "WELCOME TO THIS NEW ADVENTURE GAME"
      puts "WHAT DO YOU WANT TO DO"
      puts "1 - START THE GAME"
      puts "2 - SEE HIGH SCORES"
      puts "3 - EXIT"
      puts ""
      action = get_action
      case action
      when 1
        start
      when 2
        puts "*******************************************"
        puts "*               HIGH SCORES               *"
        puts "*******************************************"
        puts
        players = get_high_scores
        players.each do |player|
          puts "Number # 1"
          puts "Name: #{player['name']}"
          puts "Score: #{player['score']}"
          puts "Time playing (minutes): #{player['time playing']}"
          puts ""
        end
        next
      else
        exit
      end
    end
  end
  
  # Starts the game, calling the principal routine
  def start
    @startTime = Time.now
    repart_treasure
    repart_monster
    puts("WHAT IS YOUR NAME, EXPLORER")
    @name = gets.chomp.upcase
    data_name = create_player(@name)
    @idPlayer = data_name['player_id'].to_i
    update_variables
    main_routine
  end
  
  # HTTP post method to create a new player
  def create_player(name)
    RESTful.post("#{URL_MICROSERVICE_PLAYER}/player", {'name' => name}.to_json, 'application/json')
  end
  
  # HTTP put method to update the player's score
  def get_score
    RESTful.put("#{URL_MICROSERVICE_PLAYER}/score", {'id' => @idPlayer}.to_json, 'application/json')
    score = RESTful.get("#{URL_MICROSERVICE_PLAYER}/player/#{@idPlayer}/score")
    score[0]['score']
  end
  
  # HTTP get method to get the information for the given element
  def get_info_player(info)
    current_info = RESTful.get("#{URL_MICROSERVICE_PLAYER}/player/#{@idPlayer}/#{info}")
    current_info[0][info]
  end
  
  # HTTP put method to update the value for the given element
  def update_info_player(info, new_value)
    RESTful.put("#{URL_MICROSERVICE_PLAYER}/player", {'id' => @idPlayer, 'element' => info, 'value' => new_value}.to_json, 'application/json')
  end
  
  # HTTP put method to update the elements in the map for the given room id
  def update_info_map(roomId, field, value)
    RESTful.put("#{URL_MICROSERVICE_MAP}/map", {'room_id' => roomId, 'field' => field, 'value' => value}.to_json, 'application/json')
  end
  
  # HTTP get method to get useful information of the room for the given room id
  def get_room(id)
    RESTful.get("#{URL_MICROSERVICE_MAP}/map/#{id}")
  end
  
  # HTTP get method to get elements with the highest scores (only the ones that complete the game)
  def get_high_scores
    RESTful.get("#{URL_MICROSERVICE_PLAYER}/players")
  end
  
  # HTTP put method to update the ferocity for the given monster id
  def update_info_monster(monster_id, ferocity)
    RESTful.put("#{URL_MICROSERVICE_MONSTER}/monster/#{monster_id}", {'ferocity' => ferocity}.to_json, 'application/json')
  end
  
  def get_monster(monster_id)
    RESTful.get("#{URL_MICROSERVICE_MONSTER}/monster/#{monster_id}")
  end
  
  def delete_monster(monster_id)
    RESTful.delete("#{URL_MICROSERVICE_MONSTER}/monster/#{monster_id}")
  end
  
  # HTTP put method triggered when there the user tried to cheat
  def cheater
    puts("YOU HAVE TRIED TO CHEAT ME!")
    RESTful.put("#{URL_MICROSERVICE_PLAYER}/cheater", {'id' => @idPlayer}.to_json, 'application/json')
    sleep(2)
  end
  
  # Repart all the treasures in the map
  def repart_treasure
    count = 0
    loop do
      random = Random.rand(16)
      if random == 6 || random == 16
        next
      end
      treasure_value = Random.rand(100)
      RESTful.put("#{URL_MICROSERVICE_MAP}/map", {'room_id' => random, 'field' => 'treasure', 'value' => treasure_value}.to_json, 'application/json')
      count += 1
      break if count == 4
    end
  end
  
  # Creates and repart all the monsters in the map
  def repart_monster
    monsters = [{'name' => 'Fanatical Fleshgorger'.upcase, 'ferocity' => 10}, 
                {'name' => 'Maloventy Maldemer'.upcase, 'ferocity' => 15}, 
                {'name' => 'Devastating Ice Dragon'.upcase, 'ferocity' => 20},
                {'name' => 'Horremdous Hodgepodger'.upcase, 'ferocity' => 25}, 
                {'name' => 'Ghastly Gruesomeness'.upcase, 'ferocity' => 30}]
    count = 0
    loop do
      random = Random.rand(16)
      room = get_room(random)
      if random == 6 || random == 16 || room['treasure_value'] != 0
        next
      end
      dataMonster = RESTful.post("#{URL_MICROSERVICE_MONSTER}/monster", {'name' => monsters[count]['name'], 'ferocity' => monsters[count]['ferocity'], 'room' => random}.to_json, 'application/json')
      update_info_map(random, 'monster', dataMonster['monster_id'].to_i)
      count += 1
      break if count == 5
    end
    
  end
  
  # Calculates the elapsed time from the beginning to the end of the game
  def get_time_playing(start, finish)
    (finish - start) / 60
  end
  
  # Principal routine that handles all the events
  def main_routine
    loop do
      update_variables
      currentRoomInfo = get_room(@currentRoom)
      if(@currentRoom != @previousRoom)
        @strength -= 5
        update_info_player('strength', @strength)
        @tally += 1
        update_info_player('tally', @tally)
      end
      if(@currentRoom == 16)
        update_info_player('time_playing', get_time_playing(@startTime, Time.now))
        puts("CONGRATS!, YOU HAVE WON THE GAME")
        puts("YOUR SCORE IS #{get_score}")
        update_info_player('game_completed', 1)
        exit
      end
       puts("\n**********************************")
       puts("")
      if(@strength < 1)
        puts("YOU HAVE DIED.........")
        puts("YOUR SCORE IS #{get_score}")
        exit
      end
      if(@strength < 10)
        puts("WARNING, YOUR STRENGTH IS RUNNING LOW")
      end
      @tally += 1
      update_info_player('tally', @tally)
      puts("#{@name.upcase}, YOUR STRENGTH IS #{@strength}")
      if(@wealth > 0)
        puts("YOU HAVE #{@wealth} GOLD")
      end
      if(@food > 0)
        puts("YOUR PROVISIONS SACK HOLDS #{@food} UNITS OF FOOD")
      end
      if(@axe != 0 || @sword != 0 || @amulet != 0)
        print("YOU ARE CARRIYING ")
      end
      if(@axe == 1)
        print("AN AXE ")
      end
      if(@sword == 1)
        print("A SWORD ")
      end
      if((@axe == 1 || @sword == 1) && @amulet == 1)
        print("AND ")
      end
      if(@amulet == 1)
        print("THE MAGIC AMULET")
      end
      if(@light == 0)
        puts("IT IS TO DARK TO SEE ANYTHING")
      else
        puts("")
        puts(currentRoomInfo['room_desc'])
      end
      treasure = currentRoomInfo['treasure_value']
      monster = currentRoomInfo['monster_id']
      if(treasure == 0 && monster == 0)
        puts("THE ROOM IS EMPTY")
      elsif(treasure != 0)
        puts("THERE IS A TREASURE HERE WORTH OF #{treasure}")
      else
        monster = get_monster(monster)
        ferocity = monster[0]['ferocity']
        puts("DANGER...THERE IS A MONSTER HERE....")
        puts("IT IS A #{monster[0]['name']}")
        puts("THE DANGER LEVEL IS #{ferocity}")
      end
      loop do
        puts("WHAT DO YOU WANT TO DO")
        move = get_movement
        break if process_movement(move, treasure, monster, currentRoomInfo)
        sleep(2)
        puts("\n**********************************\n")
      end
    end
  end
  
  # Process the movement according to the action given
  def process_movement(move, treasure, monster, infoRoom)
    flee = rand()
    if(monster != 0 && move != "R" && move != "F")
      puts("FIGHT OR RUN!")
      return false
    elsif(monster != 0 && move == "R" &&  flee > 0.7)
      loop do
        puts('WHICH WAY DO YOU WANT TO FLEE?')
        move = get_movement
         if isPossibleMove(move, infoRoom)
        move(move, infoRoom)
        return true
      else
        p errorMove(move)
        return false
      end
      end
    elsif(monster != 0 && move == "R" && flee < 0.6)
      puts('NO YOU MUST STAND AND FIGHT')
      sleep(2)
      bePrepared(infoRoom['monster_id'])
      return true
    elsif(monster != 0  && move == "F")
      bePrepared(infoRoom['monster_id'])
      return true
    elsif(move == "Q")
      update_info_player('time_playing', get_time_playing(@startTime, Time.now))
      puts("YOUR SCORE IS #{get_score}")
      exit
    elsif(move == "T")
      puts("\n********************************\n")
      puts("* YOUR TALLY AT PRESENT IS #{get_score} *")
      puts("********************************\n")
      sleep(3)
      return true
    elsif(move == "I")
      inventory
      update_info_player('prev_room', @currentRoom)
      sleep(2)
      return true
    elsif(move == "C" && @food == 0)
      puts("YOU HAVE NO FOOD")
    elsif(move == "C")
      eat_food
      update_info_player('prev_room', @currentRoom)
       sleep(2)
      return true
    elsif(move == "F" && monster == 0)
      puts("THERE IS NOTHING TO FIGTH HERE")
    elsif(move == "P" && treasure == 0)
      puts("THERE IS NOTHING TO PICK UP")
      sleep(2)
      return true
    elsif(move == "P")
      @wealth += infoRoom['treasure_value']
      update_info_player('wealth', @wealth)
      update_info_map(@currentRoom, 'treasure', 0)
    elsif(move == "M" && @amulet == 1)
      teleport
      sleep(2)
      return true
    else
      if isPossibleMove(move, infoRoom)
        move(move, infoRoom)
        return true
      else
        p errorMove(move)
        return false
      end
    end
  end
  
  # Adjust the ferocity of the monster according to the player stats
  def bePrepared(monster_id)
    monster = get_monster(monster_id)
    ferocity = monster[0]['ferocity']
    if(@suit == 1)
      puts('YOUR ARMOR INCREASES YOUR CHANCE OF SUCCESS')
      ferocity = 3 * (ferocity/4)
      update_info_monster(monster_id, ferocity)
    end
    i=0;
    while(i<=6)
      puts('*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*')
      i += 1
    end
    if(@axe == 0 && @sword == 0)
      puts('YOU HAVE NO WEAPONS')
      puts('YOU MUST FIGHT WITH BARE HANDS')
      ferocity = ferocity + (ferocity/5)
      update_info_monster(monster_id, ferocity)
      fight(monster_id)
    elsif (@axe == 1 && @sword == 0)
      puts('YOU HAVE ONLY AN AXE TO FIGHT WITH')
      ferocity = 4 * (ferocity/5)
      update_info_monster(monster_id, ferocity)
      fight(monster_id)
    elsif (@axe == 0 && @sword == 1)
      puts('YOU MUST FIGHT WITH YOUR SWORD')
      ferocity = 3 * (ferocity/4)
      update_info_monster(monster_id, ferocity)
      fight(monster_id)
    elsif (@axe == 1 && @sword == 1)
      loop do
        puts("WHICH WEAPON?")
        puts("1 - AXE")
        puts("2 - SWORD")
        weapon = get_action
        if (weapon == 1)
          ferocity = 4 * (ferocity/5)
          update_info_monster(monster_id, ferocity)
          fight(monster_id)
        break                    
        elsif (weapon == 2)
          ferocity = 3 * (ferocity/4)
          update_info_monster(monster_id, ferocity)
          fight(monster_id)
          break
        end
      end
    end
  end
  
  # Simulates the fight
  def fight(monster_id)
    loop do
      monster = get_monster(monster_id)
      ferocity = monster[0]['ferocity']
      rndNumberFight = rand()
      if(rndNumberFight > 0.5)
        puts(monster[0]['name'] + ' ATTACKS')
      else
        puts('YOU ATTACK')
      end
      sleep(1)
      puts("")
      if(rndNumberFight > 0.6 && @light == 1)
        puts('YOUR TORCH WAS KNOCKED FROM YOU')
        update_info_player('light', 0)
        sleep(1)
        puts("")
      end
      if(rndNumberFight > 0.6 && @axe == 1)
        puts('YOU DROP YOUR AXE IN THE HEAT OF BATTLE')
        update_info_player('axe', 0)
        ferocity = 5 * (ferocity/4)
        sleep(1)
        puts("")
      end
      if(rndNumberFight > 0.6 && @sword == 1)
        puts('YOUR SWORD IS KNOCKED FROM YOUR HAND!!!')
        update_info_player('sword', 0)
        ferocity = 4 * (ferocity/3)
        sleep(1)
        puts("")
      end
      sleep(1)
      puts("")
      rndNumberFight = rand()
      if(rndNumberFight > 0.5)
        puts('YOU MANAGE TO WOUND IT')
        sleep(1)
        puts("")
        ferocity = 5 * (ferocity/6)
        if(rndNumberFight > 0.95)
          puts('Aaaaargh')
          puts('RIP! TEAR! RIP')
          sleep(1)
          puts("")
        end
        if(rndNumberFight > 0.9)
          puts('YOU WANT TO RUN BUT YOU STAND YOUR GROUND')
          puts('*&%%$#$% $%#!! @ #$$# #$@! #$ $#$')
          sleep(1)
          puts("")
        end
        if(rndNumberFight > 0.70)
          puts('WILL THIS BE A BATTLE TO THE DEATH?')
          puts('HIS EYES FLASH FEARFULLY')
          puts('BLOOD DRIPS FROM HIS CLAWS')
          puts('YOU SMELL THE SULPHUR ON HIS BREATH')
          puts('HE STRIKES WILDLY, MADLY...........')
          puts('YOU HAVE NEVER FOUGHT AN OPONENT LIKE THIS!!')
          sleep(1)
          puts("")
        end
      end
      rndNumberFight = rand()
      update_info_monster(monster_id, ferocity)
      if(rndNumberFight > 0.5)
        puts('THE MONSTER WOUNDS YOU!')
        @strength -= 5
        update_info_player('strength', @strength)
        sleep(1)
        puts("")
      end
      rndNumberFight = rand()
      if(rndNumberFight > 0.35)
        next
      else
        if(rndNumberFight * 20 > ferocity)
          puts('AND YOU MANAGED TO KILL THE ' + monster[0]['name'])
          @monsters_killed += 1
          update_info_player('monsters_killed', @monsters_killed)
          sleep(1)
          puts("")
          update_info_map(@currentRoom, 'monster', 0)
          delete_monster(monster_id)
          update_variables
          return
        else
          puts('THE ' + monster[0]['name'] + ' DEFEATED YOU')
          @strength = @strength/2
          update_info_player('strength', @strength)
          update_info_player('room', 6)
          sleep(1)
          puts("")
          update_info_map(@currentRoom, 'monster', 0)
          delete_monster(monster_id)
          update_variables
          return
        end
      end
    break if @strength < 1    
    end
  end
  
  # Method to move the current position of the player to the new room
  def move(move, infoRoom)
    update_info_player('prev_room', @previousRoom)
    case move
    when "W"
      newRoom = infoRoom['left_room_id']
    when "E"
      newRoom = infoRoom['right_room_id']
    when "N"
      newRoom = infoRoom['upside_room_id']
    when "S"
      newRoom = infoRoom['downside_room_id']
    else
      return false
    end
    return false if newRoom == 0
    update_info_player('room', newRoom)
    true
  end
  
  # Action perform to eat food
  def eat_food
    return if @food < 1
    loop do
      puts("YOU HAVE #{@food} UNITS OF FOOD")
      puts("HOW MANY DO YOU WANT TO EAT")
      food = get_action
      if food <= @food
        @food -= food
        update_info_player('food', @food)
        @strength += (food * 5)
        update_info_player('strength', @strength)
      break
      end
    end
  end
  
  # Action performed to open the store
  def inventory
    puts("\n**********************************")
    puts("\nPROVISIONS  & INVENTORY")
    loop do
      @wealth = get_info_player('wealth')
      if(@wealth == 0)
        puts("\nYOU HAVE NO MONEY")
        return
      end
      puts("\nYOU HAVE #{@wealth}")
      if(@wealth >= 0.1)
        puts("\nYOU CAN BUY ")
        puts("\t 1 - FLAMING TORCH ($15)")
        puts("\t 2 - AXE ($10)")
        puts("\t 3 - SWORD ($20)")
        puts("\t 4 - FOOD ($2 PER UNIT)")  
        puts("\t 5 - MAGIC AMULET ($30)")
        puts("\t 6 - SUIT OF ARMOR ($50)")
        puts("\t 0 - TO CONTINUE ADVENTURE")
        if(@light == 1)
          puts("YOU HAVE A TORCH")
        end
        if(@axe == 1)
          puts("YOU HAVE AN AXE")
        end
        if(@sword == 1)
          puts("YOU HAVE A SWORD")
        end
        if(@suit == 1)
          puts("YOU HAVE A SUIT")
        end
        if(@amulet == 1)
          puts("YOU HAVE AN AMULET")
        end
        puts("\nENTER NO. OF ITEM REQUIRED")
        item = get_action
        if(item == 0)
          break
        elsif(item == 1)
          if(@light == 1)
            puts("YOU ALREADY OWN A FLAMING TORCH")
            sleep(2)
            puts("-----------------------------------")
            next
          end
          @wealth -= 15
          update_info_player('wealth', @wealth)
          @light = 1
          update_info_player('light', @light)
        elsif(item == 2)
          if(@axe == 1)
            puts("YOU ALREADY OWN AN AXE")
            sleep(2)
            puts("-----------------------------------")
            next
          end
          @wealth -= 10
          update_info_player('wealth', @wealth)
          @axe = 1
          update_info_player('axe', @axe)
        elsif(item == 3)
          if(@sword == 1)
            puts("YOU ALREADY OWN A SWORD")
            sleep(2)
            puts("-----------------------------------")
            next
          end
          @wealth -= 20
          update_info_player('wealth', @wealth)
          @sword = 1
          update_info_player('sword', @sword)
        elsif(item == 4)
          if(@wealth > 1)
            buy_food
          else
            cheater
            break
          end
        elsif(item == 5)
          if(@amulet == 1)
            puts("YOU ALREADY OWN AN AMULET")
            sleep(2)
            puts("-----------------------------------")
            next
          end
          @wealth -= 30
          update_info_player('wealth', @wealth)
          @amulet = 1
          update_info_player('amulet', @amulet)
        elsif(item == 6)
          if(@suit == 1)
            puts("YOU ALREADY OWN A SUIT")
            sleep(2)
            puts("-----------------------------------")
            next
          end
          @wealth -= 50
          update_info_player('wealth', @wealth)
          @suit = 1
          update_info_player('suit', @suit)
        else
          sleep(2)
          puts("INVALID OPTION")
        end
        if(@wealth < 0)
          cheater
          sleep(2)
          break
        end
      end
      puts("-----------------------------------")
      sleep(2)
    end
  end
  
  # Action performed in the inventory to buy food
  def buy_food
    loop do
      puts("\nHOW MANY UNITS OF FOOD")
      food = get_action
      if(food * 2 > @wealth)
        puts("YOU HAVEN'T GOT ENOUGH MONEY")
        sleep(2)
        next
      else
        puts("\nYOU BOUGTH #{food} UNITS OF FOOD")
        @food += food
        update_info_player('food', @food)
        @wealth -= (food * 2)
        update_info_player('wealth', @wealth)
        sleep(2)
        break
      end
    end
  end
  
  # If the user has an amulet then move his position to a random room
  def teleport
    loop do
      random = Random.rand(16)
      if random == 6 || random == 16 || random == @currentRoom
        next
      end
      update_info_player('prev_room', @previousRoom)
      update_info_player('room', random)
      break
    end
  end
  
  # Private methods
  private
  
    # Method to provide a description when the move can't be performed
    def errorMove(move)
      case move
      when "W"
        "YOU CANNOT GO IN THAT DIRECTION"
      when "N"
        "NO EXIT THAT WAY"
      when "S"
        "THERE IS NO EXIT SOUTH"
      when "E"
        "YOU CANNOT MOVE THROUGH SOLID STONE"
      else
        "THAT IS NOT A VALID MOVE"
      end
    end
    
    # Method to check if the movement given is allowed
    def isPossibleMove(move, infoRoom)
      case move
      when "W"
        direction = infoRoom['left_room_id']
      when "E"
        direction = infoRoom['right_room_id']
      when "N"
        direction = infoRoom['upside_room_id']
      when "S"
        direction = infoRoom['downside_room_id']
      else
        return false
      end
      return false if direction == 0
      true
    end
    
    # Updates all the variables
    def update_variables
      @strength = get_info_player('strength')
      @tally = get_info_player('tally')
      @light = get_info_player('light')
      @food = get_info_player('food')
      @axe = get_info_player('axe')
      @sword = get_info_player('sword')
      @amulet = get_info_player('amulet')
      @suit = get_info_player('suit')
      @wealth = get_info_player('wealth')
      @currentRoom = get_info_player('room')
      @previousRoom = get_info_player('prev_room')
      @monsters_killed = get_info_player('monsters_killed')
    end
    
     # Action to get the input (letters)
    def get_movement
        gets.chomp.upcase
    end
    
    # Action to get the input (numbers)
    def get_action
        gets.to_i
    end
end

game = Game.new
game.menu



