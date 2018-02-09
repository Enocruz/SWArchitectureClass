# The source code contained in this file is used to
# simulate a control remote

# Command Pattern
# Date: 08-Feb-2018
# Authors:
#          A01374648 Mario Lagunes Nava
#          A01375640 Brandon Alain Cruz Ruiz
# File: control.rb

# A class that simulates a Remote Control with the Undo button.
class RemoteControlWithUndo

  # Initializes the on and off commands.
  def initialize
    @on_commands = []
    @off_commands = []
    no_command = NoCommand.new
    7.times do
      @on_commands << no_command
      @off_commands << no_command
    end
    @undo_command = no_command
  end

  # Sets the status of the command according to the slot.
  def set_command(slot, on_command, off_command)
    @on_commands[slot] = on_command
    @off_commands[slot] = off_command
  end

  # If the button is pushed, enters here.
  def on_button_was_pushed(slot)
    @on_commands[slot].execute
    @undo_command = @on_commands[slot]
  end

  # If the off button is pushed, enters here.
  def off_button_was_pushed(slot)
    @off_commands[slot].execute
    @undo_command = @off_commands[slot]
  end

  # If the undo button is pushed, enters here.
  def undo_button_was_pushed()
    @undo_command.undo
  end

  # Prints the information in the order of the buttons pushed.
  def inspect
    string_buff = ["\n------ Remote Control -------\n"]
    @on_commands.zip(@off_commands) \
        .each_with_index do |commands, i|
      on_command, off_command = commands
      string_buff << \
      "[slot #{i}] #{on_command.class}  " \
        "#{off_command.class}\n"
    end
    string_buff << "[undo] #{@undo_command.class}\n"
    string_buff.join
  end

end

# A class when no button is pushed.
class NoCommand

  # This method executes nothing.
  def execute
  end

  # This methos undoes nothing.
  def undo
  end

end

# A class that simulates the Light.
class Light

  attr_reader :level

  # Initializes the location and the level in which the Light may work.
  def initialize(location)
    @location = location
    @level = 0
  end

  # Turn on the light and sets its level on 100.
  def on
    @level = 100
    puts "Light is on"
  end

  # Turn off the ligth and sets its level on 0.
  def off
    @level = 0
    puts "Light is off"
  end

  # Checks at what level is the light.
  def dim(level)
    @level = level
    if level == 0
      off
    else
      puts "Light is dimmed to #{@level}%"
    end
  end

end

# A class that simulates de Ceiling Fan
class CeilingFan

  # Access these constants from outside this class as
  # CeilingFan::HIGH, CeilingFan::MEDIUM, and so on.
  HIGH   = 3
  MEDIUM = 2
  LOW    = 1
  OFF    = 0

  attr_reader :speed

  # Initializes the location and the speed of the Ceiling Fan
  def initialize (location)
    @location = location
    @speed = OFF
  end

  # Turns the ceiling fan on high.
  def high
    @speed = HIGH
    puts "#{@location} ceiling fan is on high"
  end

  # Turns the ceiling fan on medium.
  def medium
    @speed = MEDIUM
    puts "#{@location} ceiling fan is on medium"
  end

  # Turns the ceiling fan on low.
  def low
    @speed = LOW
    puts "#{@location} ceiling fan is on low"
  end

  # Turns the ceiling fan off.
  def off
    @speed = OFF
    puts "#{@location} ceiling fan is off"
  end

end

# A class that command the on light.
class LightOnCommand

  attr_reader :light

  # Initializes the object lights
  def initialize(light)
    @lights = light
  end

  # Turns the lights on
  def execute
    @lights.on
  end

  # Undoes the last action done of lights.
  def undo
      @lights.off
  end
end

# A class that command the off light.
class LightOffCommand
  attr_reader :light

  # Initializes the object lights.
  def initialize(light)
    @lights = light
  end

  # Turns the lights off.
  def execute
    @lights.off
  end

  # Undoes the last action done of lights.
  def undo
      @lights.on
  end
end

# A class that commands the high speed of the ceiling fan.
class CeilingFanHighCommand
  attr_reader :fan

  # Initializes the object fan.
  def initialize(fan)
    @fan = fan
    @lastExed = ''
  end

  # Puts the celing fan at high.
  def execute
    @lastExec = fan.speed
    @fan.high  
  end

  # Undoes the last action done by fan.
  def undo
    if @lastExec == CeilingFan::LOW
      @fan.low
    elsif @lastExec == CeilingFan::MEDIUM
      @fan.medium
    elsif @lastExec == CeilingFan::HIGH
      @fan.high
    end
  end
end

# A class that commands the medium speed of the ceiling fan.
class CeilingFanMediumCommand
  attr_reader :fan

  # Initializes the object fan.
  def initialize(fan)
    @fan = fan  
    @lastExec = ''
  end

  # Puts the ceiling fan at high
  def execute
    @lastExec = fan.speed
    @fan.medium
  end

  # Undoes the last action done by fan.
  def undo
    if @lastExec == CeilingFan::LOW
      @fan.low
    elsif @lastExec == CeilingFan::MEDIUM
      @fan.medium
    elsif @lastExec == CeilingFan::HIGH
      @fan.high
    end
  end
end

# A class that commands the off button of the ceiling fan.
class CeilingFanOffCommand
  attr_reader :fan

  # Initializes the object fan.
  def initialize(fan)
    @fan = fan
    @lastExec = ''
  end

  # Puts the ceiling fan at off
  def execute
    @lastExec = fan.speed
    @fan.off
  end

  # Undoes the last action done by fan, in this case, it ignores
  # the off part, so it is like it undoes the last last action done by fan.
  def undo
    if @lastExec == CeilingFan::LOW
      @fan.low
    elsif @lastExec == CeilingFan::MEDIUM
      @fan.medium
    elsif @lastExec == CeilingFan::HIGH
      @fan.high
    end
  end
end