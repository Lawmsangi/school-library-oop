require_relative 'book'
require_relative 'person'

class Rental
  attr_accessor :date, :book, :person

  def initialize(date, book, person)
    @date = date
    @book = book
    @person = person

    book.rentals << (self)
    person.rentals << (self)
  end
end

person1 = Person.new(17, name: 'Mario')
book1 = Book.new('The Hobbit', 'J. R. R. Tolkien')
# rental1 = Rental.new('2019-01-01', book1, person1)
book1.add_rental(person1, '2019-01-01')
puts book1.rentals
