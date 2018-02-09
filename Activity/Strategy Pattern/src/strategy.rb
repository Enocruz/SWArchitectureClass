class Student

  attr_reader :id, :name, :gender, :gpa

  def initialize(id, name, gender, gpa)
    @id = id
    @name = name
    @gender = gender
    @gpa = gpa
  end

end

class StudentStrategy

  def execute(array)
    raise 'Abstract method called!'
  end

end

class Course

  def strategy=(new_strategy)
    if !new_strategy.is_a? StudentStrategy
      raise 'Invalid argument. Was expecting a StudentStrategy.'
    end
    @strategy = new_strategy
  end

  def initialize
    @students = []
    @strategy = nil
  end

  def add_student(student)
    @students.push(student)
  end

  def execute
    @strategy.execute(@students)
  end

end

class CountGenderStrategy < StudentStrategy
    def initialize(gender)
        @gender = gender
    end
    def execute(array)
       array.inject(0) {|sum, student| (student.gender == @gender) ? sum + 1 : sum}
    end
end

class ComputeAverageGPAStrategy < StudentStrategy
    def execute(array)
        if(array.length == 0)
            nil
        else
            array.inject(0) {|sum, student| sum + student.gpa } / array.length
        end
    end
end

class BestGPAStrategy < StudentStrategy
    def execute(array)
        if(array.length == 0)
            nil
        else
            maxGPA = array[0].gpa
            i = 1
            index = 0
            while (i < array.length) do
                if(array[i].gpa > maxGPA)
                    maxGPA = array[i].gpa
                    index = i
                end
                i += 1
            end 
            array[index].name
        end
    end
end
