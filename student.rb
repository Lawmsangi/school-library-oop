require_relative 'person'

class Student < Person
  attr_accessor :parent_permission
  attr_reader :classroom

  def initialize(age, name: 'Unknown', parent_permission: true)
    super(age, name: name, parent_permission: parent_permission)
  end

  def classroom=(classroom)
    @classroom = classroom
    classroom.students.push(self) unless classroom.students.include?(self)
  end

  def play_hooky
    '¯\\(ツ)/¯'
  end
end
