# Decorator Pattern
# Date: 08-March-2018
# Authors:
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz

# File: coffee.rb 

# Beverages prices
# Name	                Price
# Dark Roast Coffee	    $0.99
# Espresso	            $1.99
# House Blend Coffee    $0.89

# Definition of class Beverage
class Beverage
    
    # Empty initializer for children
    def initialize
    end
    
    # Empty method for children which contains all the description for the beverage
    def description
        ""
    end
    
    # Method that contains 0 as the principal cost, used to add the final cost of the beverage
    def cost
        0
    end
end

# Definition of class DarkRoast which inherits from Beverage 
class DarkRoast < Beverage
    
    # Initializer method according to the beverages price table
    def initialize
        super
        @cost = 0.99
        @description = "Dark Roast Coffee"
    end
    
    # Method to concat the description to the beverage class
    def description
        super + @description
    end
    
    # Method to add the cost to the current beverage cost
    def cost
        super + @cost
    end
    
end

# Definition of class Espresso which inherits from Beverage 
class Espresso < Beverage
    
    # Initializer method according to the beverages price table
    def initialize
        super
        @cost = 1.99
        @description = "Espresso"
    end
    
    # Method to concat the description to the beverage class
    def description
        super + @description
    end
    
    # Method to add the cost to the current beverage cost
    def cost
        super + @cost
    end
end

# Definition of class HouseBlend which inherits from Beverage 
class HouseBlend < Beverage
    
    # Initializer method according to the beverages price table
    def initialize
        super
        @cost = 0.89
        @description = "House Blend Coffee"
    end

    # Method to concat the description to the beverage class
    def description
        super + @description
    end
    
    # Method to add the cost to the current beverage cost
    def cost
        super + @cost
    end
end

# Empty class (Decorator)
class CondimentDecorator < Beverage
end

# Condiments table
# Name  	Price
# Mocha	    $0.20
# Whip	    $0.10
# Soy	    $0.15
# Milk	    $0.10

# Definition of class Mocha, a subclass of decorator
class Mocha < CondimentDecorator
    
    # Initializer method according to the condiments table
    def initialize(beverage)
        @beverage = beverage
        @cost =  0.20
        @description = "Mocha"
    end
    
    def cost
        @beverage.cost + @cost
    end
    
    # Method to concat the description to the beverage given
    def description
        @beverage.description + ", " + @description
    end
end

# Definition of class Whip, a subclass of decorator
class Whip < CondimentDecorator   
    
    # Initializer method according to the condiments table
    def initialize(beverage)
        @beverage = beverage
        @cost =  0.10
        @description = "Whip"
    end
    
    # Method to add the cost to the current beverage cost
    def cost
        @beverage.cost + @cost
    end
    
    # Method to concat the description to the beverage given
    def description
        @beverage.description + ", " + @description
    end
end

# Definition of class Soy, a subclass of decorator
class Soy < CondimentDecorator
    
    # Initializer method according to the condiments table
    def initialize(beverage)
        @beverage = beverage
        @cost =  0.15
        @description = "Soy"
    end
    
    # Method to add the cost to the current beverage cost
    def cost
        @beverage.cost + @cost
    end
    
    # Method to concat the description to the beverage given
    def description
        @beverage.description + ", " + @description
    end
end

# Definition of class Milk, a subclass of decorator
class Milk < CondimentDecorator
    
    # Initializer method according to the condiments table
    def initialize(beverage)
        @beverage = beverage
        @cost =  0.10
        @description = "Milk"
    end
    
    # Method to add the cost to the current beverage cost
    def cost
        @beverage.cost + @cost
    end
    
    # Method to concat the description to the beverage given
    def description
        @beverage.description + ", " + @description
    end
end

