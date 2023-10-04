require_relative 'person'

class Student < Person
  attr_accessor :name
  attr_reader :classroom

  def initialize(age, classroom, name: 'Unknown')
    super(age, name: name)
    self.classroom = classroom
  end

  def classroom=(classroom)
    @classroom = classroom
    classroom.students.push(self) unless classroom.students.include?(self)
  end

  def play_hooky
    '¯\\(ツ)/¯'
  end
end
