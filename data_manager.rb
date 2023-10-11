require 'json'
require_relative 'book'
require_relative 'person'
require_relative 'student'
require_relative 'teacher'
class DataManager
  def save_books(books)
    File.open('data/books.json', 'w') do |file| data = { 
      'Books' => books.map { |book| { 'title' => book.title, 'author' => book.author } } } file.write(JSON.pretty_generate(data))
    end
  end

  def load_books
    return [] unless File.exist?('data/books.json')

    data = JSON.parse(File.read('data/books.json'))
    books = []
    data['Books'].map { |book_data| books << Book.new(book_data['title'], book_data['author']) }
    books
  end

  def save_people(people)
    File.open('data/people.json', 'w') do |file|
      data = {
        'People' => people.map do |person|
          person_data = {
            'type' => person.class.to_s,
            'age' => person.age,
            'name' => person.name,
            'id' => person.id
          }
          if person.instance_of?(Teacher)
            person_data['specialization'] = person.specialization
          elsif person.instance_of?(Student)
            person_data['parent_permission'] = person.parent_permission
          end
          person_data
        end
      }
      file.write(JSON.pretty_generate(data))
    end
  end

  def load_people
    return [] unless File.exist?('data/people.json')

    data = JSON.parse(File.read('data/people.json'))
    persons = []
    data['People'].map do |person_data|
      persons << if person_data['type'] == 'Teacher'
                   Teacher.new(person_data['age'].to_i, person_data['specialization'], name: person_data['name'])
                 else
                   Student.new(person_data['age'].to_i, name: person_data['name'],
                                                        parent_permission: person_data['parent_permission'])
                 end
    end
    persons
  end

  def save_rentals(books, people, rentals)
    rentals_data = []
    rentals.each do |rental|
      book_index = books.index(rental.book)
      person_index = people.index(rental.person)
      rentals_data << { 'date' => rental.date, 'book' => book_index, 'person' => person_index }
    end
    File.write('data/rentals.json', JSON.pretty_generate(rentals_data))
  end

  def load_rentals(books, people)
    return [] unless File.exist?('data/rentals.json')

    data = JSON.parse(File.read('data/rentals.json'))
    rentals_list = []
    data.each do |rental_data|
      book = books[rental_data['book']]
      person = people[rental_data['person']]
      rentals_list << Rental.new(rental_data['date'], book, person)
    end
    rentals_list
  end
end
