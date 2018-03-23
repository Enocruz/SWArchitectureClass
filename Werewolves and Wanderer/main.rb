# WEREWOLVES AND WARDERER
# Date: 15-Mar-2018
# Authors:
#          A01374527 Luis Daniel Rivero Sosa
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz
# File: main.rb


# WEREWOLVES AND WANDERER
#
# COMMANDS:
# 1. I -> Opens the inventory
# 2. F -> Starts a fight
# 3. N -> Go to the north
# 4. S -> Go to the south
# 5. E -> Go to the east
# 6. W -> Go to the west
# 7. P -> Pick up a treasure in the curren room
# 8. U -> Go upstairs
# 9. D -> Go downstairs
# 10. T -> Shows the tally

require './map'

class Game
    
    attr_accessor :name
    def initialize
        @wealth = 75
        @strength = 100
        @tally = 0
        @mk = 0
        @food = 0
        @monsters_killed = 0
        @suit = 0
        @light = 0
        @axe = 0
        @amulet = 0
        @sword = 0
        @map = Map.new
        @name = ''
        @score = 0
    end

    def start
        puts("WHAT IS YOUR NAME, EXPLORER")
        @name = gets.chomp.upcase
        main_routine
    end
    
    def get_score
        puts("YOUR SCORE IS")
        @score = 3 * @tally + 5 * @strength + 2 * @wealth + @food + 30 * @mk
        puts(@score)
        exit
    end
    def main_routine
        loop do
            if(@map.currentRoom != @map.previousRoom)
                @strength -= 5
                @tally += 1
            end
            if(@map.isGameWon)
                @map.getWonMessage(@name)
                get_score
            end
            puts("\n**********************************")
            puts("")
            if(@strength < 10)
                puts("WARNING, YOUR STRENGTH IS RUNNING LOW")
            end
            if(@strength < 1)
                puts("YOU HAVE DIED.........")
                get_score
            end
            @tally += 1
            puts("#{name.upcase}, YOUR STRENGTH IS #{@strength}")
            if(@wealth > 0)
                puts("YOU HAVE #{@wealth} GOLD")
            end
            if(@food > 0)
                puts("YOUR PROVISIONS SACK HOLDS #{@food} UNITS OF FOOD")
            end
            if(@axe != 0 || @sword != 0 || @amulet != 0)
                print("YOU ARE CARRIYING ")
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
            end
            if(@light == 0)
                puts("IT IS TO DARK TO SEE ANYTHING")
            else
                puts("")
                puts(@map.getRoomDescription)
            end
            treasureAndMonster = @map.getTreasuresAndMonsters
            if(treasureAndMonster == 0)
                puts("THE ROOM IS EMPTY")
            elsif(treasureAndMonster > 9)
                puts("THERE IS A TREASURE HERE WORTH OF #{treasureAndMonster}")
            else
                puts("DANGER...THERE IS A MONSTER HERE....")
                if(treasureAndMonster == -1)
                    puts("IT IS A FEROCIOUS WEREWOLF")
                    puts("THE DANGER LEVEL IS 5")
                elsif(treasureAndMonster == -2)
                    puts("IT IS A FANATICAL FLESHGORGER")
                    puts("THE DANGER LEVEL IS 10")
                elsif(treasureAndMonster == -3)
                    puts("IT IS A MALOVENTY MALDEMER")
                    puts("THE DANGER LEVEL IS 15")
                elsif(treasureAndMonster == -4)
                    puts("IT IS A DEVASTATINT ICE-DRAGON")
                    puts("THE DANGER LEVEL IS 20")
                elsif(treasureAndMonster == -5)
                    puts("IT IS A HORRENDOUS HODGEPODGER")
                    puts("THE DANGER LEVEL IS 25")
                else
                    puts("IT IS A GHASTLY GRUESOMENESS")
                    puts("THE DANGER LEVEL IS 30")
                end
            end
            loop do
                puts("WHAT DO YOU WANT TO DO")
                move = get_movement
                break if process_movement(move, treasureAndMonster)
                sleep(2)
                puts("\n**********************************\n")
            end
        end
    end
    
    #Returns true if a movement was performed otherwise returns false
    def process_movement(move, treasureAndMonster)
        flee = rand()
        if(treasureAndMonster < 0 && move != "R" && move != "F")
            puts("FIGHT OR RUN!")
            return false
        elsif(treasureAndMonster < 0 && move == "R" &&  flee > 0.7)
            loop do
                puts('WHICH WAY DO YOU WANT TO FLEE?')
                move = get_movement
                if(@map.isPossibleMove(move))
                    @map.move(move)
                    return true
                else
                    puts(@map.getMoveError(move))
                end
            end
        elsif(treasureAndMonster < 0 && move == "R" && flee < 0.7)
            puts('NO YOU MUST STAND AND FIGHT')
            sleep(2)
            getToFight(treasureAndMonster)
            return true
        elsif(treasureAndMonster <0 && move == "F")
            getToFight(treasureAndMonster)
            return true
        elsif(move == "Q")
            get_score
        elsif(move == "T")
            puts("\n********************************\n")
            puts("* YOUR TALLY AT PRESENT IS #{3*@tally + 5*@strength + 2*@wealth + @food + 30*@monsters_killed} *")
            puts("********************************\n")
            sleep(3)
            return true
        elsif(move == "I")
            inventory
            @map.updatePreviousRoom
            sleep(2)
            return true
        elsif(move == "C" && @food == 0)
            puts("YOU HAVE NO FOOD")
        elsif(move == "C")
            eat_food
            @map.updatePreviousRoom
            sleep(2)
            return true
        elsif(move == "F" && treasureAndMonster >= 0)
            puts("THERE IS NOTHING TO FIGTH HERE")
        elsif(move == "P")
            pick_up_treasure(treasureAndMonster)
            @map.setEmptyRoom
            sleep(2)
            return true
        elsif(move == "M" && @amulet == 1)
            @map.teleport
            sleep(2)
            return true
        else
            if(@map.isPossibleMove(move))
                @map.move(move)
                return true
            else
                puts(@map.getMoveError(move))
                return false
            end
        end
    end
    
    def getToFight(monsterNumber)
        if(monsterNumber == -1)
            ferocity = 5
        elsif (monsterNumber == -2)
            ferocity = 10
        elsif (monsterNumber == -3)
            ferocity = 15
        elsif (monsterNumber == -4)
            ferocity = 20
        elsif (monsterNumber == -5)
            ferocity = 25
        elsif (monsterNumber == -6)
            ferocity = 30
        end
        bePrepared(monsterNumber, ferocity)
    end
    
    def bePrepared(monsterNumber, ferocity)
        if(@suit == 1)
            puts('YOUR ARMOR INCREASES YOUR CHANCE OF SUCCESS')
            ferocity = 3 * (ferocity/4)
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
            battle(monsterNumber,ferocity)
        elsif (@axe == 1 && @sword == 0)
            puts('YOU HAVE ONLY AN AXE TO FIGHT WITH')
            ferocity = 4 * (ferocity/5)
            battle(monsterNumber,ferocity)
        elsif (@axe == 0 && @sword == 1)
            puts('YOU MUST FIGHT WITH YOUR SWORD')
            ferocity = 3 * (ferocity/4)
            battle(monsterNumber, ferocity)
        elsif (@axe == 1 && @sword == 1)
            loop do
                puts("WHICH WEAPON?")
                puts("1 - AXE")
                puts("2 - SWORD")
                weapon = get_action
                if (weapon == 1)
                    ferocity = 4 * (ferocity/5)
                    battle(monsterNumber, ferocity)
                    break                    
                elsif (weapon == 2)
                    ferocity = 3 * (ferocity/4)
                    battle(monsterNumber, ferocity)
                    break
                end
            end
        end
    end
    
    def battle(monsterNumber, ferocity)
        if(monsterNumber == -1) 
            fight('Ferocious Werewolf',ferocity)
        elsif (monsterNumber == -2)
            fight('Fanatical Fleshgorger',ferocity)
        elsif (monsterNumber == -3)
            fight('Maloventy Maldemer',ferocity)
        elsif (monsterNumber == -4)
            fight('Devastating Ice Dragon',ferocity)
        elsif (monsterNumber == -5)
            fight('Horremdous Hodgepodger',ferocity)
        elsif (monsterNumber == -6)
            fight('Ghastly Gruesomeness',ferocity,axe)
        end
    end
    
    def fight(name, ferocity)
        loop do
            rndNumberFight = rand()
            if(rndNumberFight > 0.5)
                puts(name + ' ATTACKS')
            else
                puts('YOU ATTACK')
            end
            sleep(1)
            puts("")
            if(rndNumberFight > 0.5 && @light == 1)
                puts('YOUR TORCH WAS KNOCKED FROM YOU')
                @light = 0
                sleep(1)
                puts("")
            end

            if(rndNumberFight > 0.5 && @axe == 1)
                puts('YOU DROP YOUR AXE IN THE HEAT OF BATTLE')
                @axe = 0
                ferocity = 5 * (ferocity/4)
                sleep(1)
                puts("")
            end

            if(rndNumberFight > 0.5 && @sword == 1)
                puts('YOUR SWORD IS KNOCKED FROM YOUR HAND!!!')
                @sword = 0
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
            if(rndNumberFight > 0.5)
                puts('THE MONSTER WOUNDS YOU!')
                @strength -= 5
                sleep(1)
                puts("")
            end

            rndNumberFight = rand()
            
            if(rndNumberFight > 0.35)
                next
            else
                if(rndNumberFight*16 > ferocity)
                    puts('AND YOU MANAGED TO KILL THE ' + name)
                    @monsters_killed += 1
                    @map.setEmptyRoom
                    sleep(1)
                    puts("")
                    return
                else
                    puts('THE ' + name + ' DEFEATED YOU')
                    @strength = @strength/2
                    @map.setEmptyRoom
                    @map.currentRoom = 6
                    sleep(1)
                    puts("")
                    return
                end
            end
        break if @strength < 1    
        end
    end
    
    def get_movement
        gets.chomp.upcase
    end
    def get_action
        gets.to_i
    end
    
    def pick_up_treasure(treasure)
        if treasure < 10
            puts("THERE IS NO TREASURE TO PICK UP")
            return
        elsif @light == 1
            @wealth += treasure
            @map.setEmptyRoom
            return
        end
    end
    
    def eat_food
        return if @food < 1
        loop do
            puts("YOU HAVE #{@food} UNITS OF FOOD")
            puts("HOW MANY DO YOU WANT TO EAT")
            food = get_action
            if food <= @food
                @food -= food
                @strength += (food * 5)
                break
            end
        end
        
    end
    
    def buy_food
        loop do
            puts("\nHOW MANY UNITS OF FOOD")
            food = get_action
            if(food*2 > @wealth)
                puts("YOU HAVEN'T GOT ENOUGH MONEY")
                sleep(2)
                next
            else
                puts("\nYOU BOUGTH #{food} UNITS OF FOOD")
                @food += food
                @wealth -= (food * 2)
                sleep(2)
                break
            end
        end
    end
    
    def cheater
        puts("YOU HAVE TRIED TO CHEAT ME!")
        @wealth = 0
        @suit = 0
        @light = 0
        @axe = 0
        @amulet = 0
        @sword = 0
        @food /= 4
        sleep(2)
    end
    
    def inventory
        puts("\n**********************************")
        puts("\nPROVISIONS  & INVENTORY")
        loop do
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
                    @light = 1
                elsif(item == 2)
                    if(@axe == 1)
                        puts("YOU ALREADY OWN AN AXE")
                        sleep(2)
                        puts("-----------------------------------")
                        next
                    end
                    @wealth -= 10
                    @axe = 1
                elsif(item == 3)
                    if(@sword == 1)
                        puts("YOU ALREADY OWN A SWORD")
                        sleep(2)
                        puts("-----------------------------------")
                        next
                    end
                    @wealth -= 20
                    @sword = 1
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
                    @amulet = 1
                elsif(item == 6)
                    if(@suit == 1)
                        puts("YOU ALREADY OWN A SUIT")
                        sleep(2)
                        puts("-----------------------------------")
                        next
                    end
                    @wealth -= 50
                    @suit = 1
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
end

game = Game.new
game.start

