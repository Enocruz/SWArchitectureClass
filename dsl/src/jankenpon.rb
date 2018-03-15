# Domain-Specific Language Pattern
# Date: 15-Mar-2018
# Authors:
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz
# File: jankenpon_test.rb

def show(arg)
    print ("Result = #{arg.s}\n")
end

class Lizard
    def s
        "Lizard"
    end

    def +(arg)
        if(arg == Paper)
            puts("Lizard eats Paper (winner Lizard)")
            self
        elsif(arg == Spock)
            puts("Lizard poisons Spock (winner Lizard)")
            self
        elsif(arg == Lizard)
            puts("Lizard tie (winner Lizard)")
            self
        else
            arg + self
        end
    end
    def -(arg)
        if(arg == Scissors)
            puts("Scissors decapitate Lizard (loser Lizard)")
            self
        elsif(arg == Rock)
            puts("Rock crushes Lizard (loser Lizard)")
            self
        elsif(arg == Lizard)
            puts("Lizard tie (loser Lizard)")
            self
        else
            arg - self
        end
    end
    
end


class Spock
    def s
        "Spock"
    end

    def +(arg)
        if(arg == Rock)
            puts("Spock vaporizes Rock (winner Spock)")
            self
        elsif(arg == Scissors)
            puts("Spock smashes Scissors (winner Spock)")
            self
        elsif(arg == Spock)
            puts("Spock tie (winner Spock)")
            self
        else
            arg + self
        end
    end
    def -(arg)
        if(arg == Paper)
            puts("Paper disproves Spock (loser Spock)")
            self
        elsif(arg == Lizard)
            puts("Lizard poisons Spock (loser Spock)")
            self
        elsif(arg == Spock)
            puts("Spock tie (loser Spock)")
            self
        else
            arg - self
        end
    end
    
end


class Paper
    def s
        "Paper"
    end

    def +(arg)
        if(arg == Rock)
            puts("Paper covers Rock (winner Paper)")
            self
        elsif(arg == Spock)
            puts("Paper disproves Spock (winner Paper)")
            self
        elsif(arg == Paper)
            puts("Paper tie (winner Paper)")
            self
        else
            arg + self
        end
    end
    def -(arg)
        if(arg == Scissors)
            puts("Scissors cut Paper (loser Paper)")
            self
        elsif(arg == Lizard)
            puts("Lizard eats Paper (loser Paper)")
            self
        elsif(arg == Paper)
            puts("Paper tie (loser Paper)")
            self
        else
            arg - self
        end
    end
    
end

class Rock
    def s
        "Rock"
    end

    def +(arg)
        if(arg == Scissors)
            puts("Rock crushes Scissors (winner Rock)")
            self
        elsif(arg == Lizard)
            puts("Rock crushes Lizard (winner Rock)")
            self
        elsif(arg == Rock)
            puts("Rock tie (winner Rock)")
            self
        else
            arg + self
        end
    end
    def -(arg)
        if(arg == Paper)
            puts("Paper covers Rock (loser Rock)")
            self
        elsif(arg == Spock)
            puts("Spock vaporizes Rock (loser Rock)")
            self
        elsif(arg == Rock)
            puts("Rock tie (loser Rock)")
            self
        else
            arg - self
        end
    end
    
end

class Scissors
    def s
        "Scissors"
    end
    def +(arg)
        if(arg == Paper)
            puts("Scissors cut Paper (winner Scissors)")
            self
        elsif(arg == Lizard)
            puts("Scissors decapitate Lizard (winner Scissors)")
            self
        elsif(arg == Scissors)
            puts("Scissors tie (winner Scissors)")
            self
        else
            arg + self
        end
    end
    def -(arg)
        if(arg == Spock)
            puts("Spock smashes Scissors (loser Scissors)")
            self
        elsif(arg == Rock)
            puts("Rock crushes Scissors (loser Scissors)")
            self
        elsif(arg == Scissors)
            puts("Scissors tie (loser Scissors)")
            self
        else
            arg - self
        end
    end
    
end

Paper = Paper.new
Scissors = Scissors.new
Lizard = Lizard.new 
Spock = Spock.new
Rock = Rock.new