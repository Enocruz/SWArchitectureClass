# WEREWOLVES AND WARDERER
# Date: 15-Mar-2018
# Authors:
#          A01374527 Luis Daniel Rivero Sosa
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz
# File: map.rb

class Map
    
    attr_reader :map, :previousRoom
    attr_accessor :currentRoom
    def initialize()
        @map = createOriginalMap()
        addTreasuresAndMonsters()
        @currentRoom = 6
        @previousRoom = 0
    end
    
    def isGameWon()
        return true if @currentRoom == 11
        false
    end
    
    def getWonMessage(name)
        return "YOU'VE DONE IT!! THAT WAS THE EXIT FROM THE CASTLE. YOU HAVE SUCCEEDED, #{name}! YOU MANAGED TO GET OUT OF THE CASTLE. WELL DONE!"
    end

    def getTreasuresAndMonsters()
        return @map[@currentRoom-1][6]
    end
    
    def setEmptyRoom
        @map[@currentRoom-1][6] = 0
    end
    
    def isPossibleMove(move)
        possibleMoves = ["N","S","E","W","U","D"]
        index = possibleMoves.index(move)
        return false if index == nil
        direction = @map[@currentRoom-1][index]
        return false if direction == 0
        true
    end
    
    def getMoveError(move)
        possibleMoves = ["N","S","E","W","U","D"]
        index = possibleMoves.index(move)
        return index if index == nil
        errors = ["NO EXIT THAT WAY",
        "THERE IS NO EXIT SOUTH",
        "YOU CANNOT GO IN THAT DIRECTION",
        "YOU CANNOT MOVE THROUGH SOLID STONE",
        "THERE IS NO WAY UP FROM HERE",
        "YOU CANNOT DESCEND FROM HERE"]
        return errors[index]
    end
    
    def updatePreviousRoom
        @previousRoom = @currentRoom    
    end
    
    def teleport
        @previousRoom = @currentRoom
        loop do
            aleatorio = Random.rand(19)
            if(aleatorio != 6 || aleatorio != 11)
                @currentRoom = aleatorio
                break
            end
        end
    end
    
    def move(direction)
        @previousRoom = @currentRoom
        possibleMoves = ["N","S","E","W","U","D"]
        index = possibleMoves.index(direction)
        return false if index == nil
        newRoom = @map[@currentRoom-1][index]
        return false if newRoom == 0
        @currentRoom = newRoom
        true
    end
    
    
    def toString
       (1..19).each{|index| puts "room #{index} = #{@map[index-1]}"} 
    end
    
    def addTreasuresAndMonsters()
        #create list with 4 random values each
        listTreasures = []
        listMonsters = []
        numberOfMonsters = 6
        numberOfNormalTreasures = 4;
        listExtratreasures = [3,15]
        while(listTreasures.length < numberOfNormalTreasures || listMonsters.length <numberOfMonsters)
            aleatorio = Random.rand(19)
            if(aleatorio!= 5 && aleatorio!= 10 && listTreasures.length < numberOfNormalTreasures &&
                listMonsters.include?(aleatorio) == false && listTreasures.include?(aleatorio) == false)
                listTreasures << aleatorio
            end
            aleatorio = Random.rand(19)
            if(aleatorio!= 5 && aleatorio!= 10 && listMonsters.length < numberOfMonsters &&
                listMonsters.include?(aleatorio) == false && listTreasures.include?(aleatorio) == false)
                listMonsters << aleatorio
            end
        end
        
        #add the treasures and monsters to map
        #puts "#{listTreasures},#{listMonsters},#{listExtratreasures}"
        listTreasures.each{ |treasure| @map[treasure][6] = 10 + Random.rand(100) }
        (0..listMonsters.length-1).to_a.each{|number| @map[listMonsters[number]][6] = -(number + 1)}
        listExtratreasures.each{ |treasure| @map[treasure][6] = 100 + Random.rand(100)}
        
    end
    
    
    def createOriginalMap()
        [[0,2,0,0,0,0,0],[1,3,3,0,0,0,0],[2,0,5,2,0,0,0],[0,5,0,0,0,0,0],
            [4,0,0,3,15,13,0],[0,0,1,0,0,0,0],[0,8,0,0,0,0,0],[7,10,0,0,0,0,0],
                [0,19,0,8,0,8,0],[8,0,11,0,0,0,0],[0,0,10,0,0,0,0],[0,0,0,13,0,0,0],
                    [0,0,12,0,5,0,0],[0,15,17,0,0,0,0],[14,0,0,0,0,5,0],[17,0,19,0,0,0,0],
                        [18,16,0,14,0,0,0],[0,17,0,0,0,0,0],[9,0,16,0,0,0,0]]
    end
    def getRoomDescription()
        dictionaryRoomDescriptions = 
        {
            1 => "YOU ARE IN THE HALLWAY. *THERE IS A DOOR TO THE SOUTH THROUGH WINDOWS TO THE NORTH YOU CAN SEE A SECRET HERB GARDEN",
            2 => "THIS IS THE AUDIENCE CHAMBER. *THERE IS A WINDOW TO THE WEST BY LOOKING TO 
THE RIGHT THROUGH IT YOU CAN SEE THE ENTRANCE TO THE CASTLE.",
            3 => "YOU ARE IN THE GREAT HALL, AN L-SHAPED ROOM. THERE ARE TWO DOORS IN THIS ROOM.
THE WOOD PANELS ARE WARPED AND FADED... *",
            4 => "THIS IS THE MONARCH'S PRIVATE MEETING ROOM. *THERE IS A SINGLE EXIT TO THE SOUTH",
            5 => "THIS INNER HALLWAY CONTAINS A DOOR TO THE NORTH, AND ONE TO THE WEST,
AND A CIRCULAR STAIRWELL PASSES THROUGH THE ROOM. *YOU CAN SEE AN ORNAMENTAL LAKE THROUGH
THE WINDOWS TO THE SOUTH",
            6 => "YOU ARE AT THE ENTRANCE TO A FORBIDDING-LOOKING STONE CASTLE.  YOU ARE FACING EAST",
            7 => "THIS IS THE CASTLE'S KITCHEN. THROUGH WINDOWS IN THE NORTH WALL YOU CAN SEE 
A SECRET HERB GARDEN. IT HAS BEEN MANY YEARS SINCE MEALS WERE PREPARED FOR THE MONARCH AND THE COURT. 
IN THIS KITCHEN....... *",
            8 => "YOU ARE IN THE STORE ROOM, AMIDST SPICES, VEGETABLES, AND VAST SACKS OF FLOUR
AND OTHER PROVISIONS. THE AIR IS THICK WITH SPICE AND CURRY FUMES...",
            9 => "YOU HAVE ENTERED THE LIFT... IT SLOWLY DESCENDS...",
            10 => "YOU ARE IN THE REAR VESTIBULE THERE ARE WINDOWS TO THE SOUTH FROM WHICH 
YOU CAN SEE THE ORNAMENTAL LAKE THERE IS AN EXIT TO THE EAST, AND ONE TO THE NORTH",
            11 => "",
            12 => "YOU ARE IN THE DANK, DARK DUNGEON THERE IS A SINGLE EXIT, 
A SMALL HOLE IN WALL TOWARDS THE WEST. *",
            13 => "YOU ARE IN THE PRISON GUARDROOM, IN THE BASEMENT OF THE CASTLE.
THE STAIRWELL ENDS IN THIS ROOM. THERE IS ONE OTHER EXIT, A SMALL HOLE IN THE EAST
WALL THE AIR IS DAMP AND UNPLEASANT...A CHILL WIND RUSHES INTO THE ROOM FROM GAPS IN 
THE STONE AT THE TOP OF THE WALLS",
            14 => "YOU ARE IN THE MASTER BEDROOM ON THE UPPER LEVEL OF THE CASTLE....
LOOKING DOWN FROM THE WINDOW TO THE WEST YOU CAN SEE THE ENTRANCE TO THE
CASTLE, WHILE THE SECRET HERB GARDEN IS VISIBLE BELOW THE NORTH WINDOW.
THERE ARE DOORS TO THE EAST AND TO THE SOUTH....",
            15 => "THIS IS THE L-SHAPED UPPER HALLWAY. *TO THE NORTH IS A DOOR, AND THERE
IS A STAIRWELL IN THE HALL AS WELL. YOU CAN SEE THE LAKE THROUGH THE SOUTH WINDOWS",
            16 => "THIS ROOM WAS USED AS THE CASTLE TREASURY IN BY-GONE YEARS....
*THERE ARE NO WINDOWS, JUST EXITS.",
            17 => "OOOOH...YOU ARE IN THE CHAMBERMAIDS' BEDROOM FAINT PERFUME STILL HANGS IN THE
AIR... THERE IS AN EXIT TO THE WEST AND A DOOR TO THE SOUTH....",
            18 => "THIS TINY ROOM ON THE UPPER LEVEL IS THE DRESSING CHAMBER. THERE IS A
WINDOW TO THE NORTH, WITH A VIEW OF THE HERB GARDEN DOWN BELOW. A DOOR LEAVES TO THE SOUTH.",
            19 => "THIS IS THE SMALL ROOM OUTSIDE THE CASTLE YOU CAN SEE......................
THE LAKE THROUGH THE SOUTHERN WINDOWS",
        }
        
        dictionaryOptionalDescriptions = 
        {
            1 => "FROM THE DUST ON THE GROUND YOU CAN TELL NO-ONE HAS WALKED HERE FOR A LONG, LONG TIME.\n",
            2 => "THE FADED TAPE STRIES ON THE WALL ONLY HINT AT THE SPLENDOR WHICH THIS ROOM ONCE HAD.\n",
            3 => "AS YOU STAND THERE, YOU HEAR A MOUSE SCAMPER ALONG THE FLOOR BEHIND YOU...
YOU WHIRL AROUND...BUT SEE NOTHING!",
            4 => "THE ECHO OF ANCIENT PLOTTING AND WRANGLING HANGScHEAVY IN THE MUSTY AIR...\n",
            5 => "THE ROOM IS SMALL, AND UNFRIENDLY. ",
            6 => "",
            7 => "...A RAT SCURRIES ACROSS THE FLOOR... ",
            8 => "",
            9 => "",
            10 => "",
            11 => "",
            12 => "...A HOLLOW, DRY CHUCKLE IS HEARD FROM THE GUARD ROOM.... ",
            13 => "",
            14 => "",
            15 => "...A MOTH FLITS ACROSS NEAR THE CEILING... ",
            16 => "...A SPIDER SCAMPERS DOWN THE WALL........ ",
            17 => "",
            18 => "",
            19 => "",
        }
        description = dictionaryRoomDescriptions[@currentRoom]
        if(Random.rand(10) > 4)
            description.sub!("*",dictionaryOptionalDescriptions[@currentRoom])
        else
            description.sub!("*","")
        end
        return description
    end
end
