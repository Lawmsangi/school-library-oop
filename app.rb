require_relative 'book'
require_relative 'rental'
require_relative 'student'
require_relative 'teacher'
require_relative 'classroom'
require_relative 'data_manager'

class App
  attr_accessor :rentals, :books, :people

  def initialize()
    @data_manager = DataManager.new
    @rentals = @data_manager.load_rentals(@books, @people)
    @books = @data_manager.load_books
    @people = @data_manager.load_people
  end

  def list_books
    if @books.empty?
      puts 'No people'
    else
      @books.each_with_index do |book, i|
        puts "Number: #{i + 1}, Title: #{book.title}, Author: #{book.author}"
      end
    end
  end

  def list_people
    if @people.empty?
      puts 'No People'
    else
      @people.each_with_index do |person, i|
        puts "No: #{i + 1}, Name: #{person.name},age: #{person.age} ID: #{person.id}"
        if person.instance_of?(Teacher)
          puts "Specialization: #{person.specialization}"
        elsif person.instance_of?(Student)
          puts "Parent permission: #{person.parent_permission}"
        end
      end
    end
  end

  def create_person()
    puts "\n"
    puts 'Do you want to create a student (1) or teacher (2)? [Input number]:'
    type = gets.chomp.to_i
    puts 'Enter person age:'
    age = gets.chomp.to_i
    puts 'Enter person name:'
    name = gets.chomp
    if type == 1
      puts 'Has parent permission? [Yes/No]'
      parent_permission = gets.chomp
      create_student(age, name, parent_permission)
    elsif type == 2
      puts 'Enter specialization'
      specialization = gets.chomp
      create_teacher(age, specialization, name)
    else
      puts 'Invalid input'
    end
  end

  def create_student(age, name, has_parent_permission)
    student = Student.new(age, name: name, parent_permission: has_parent_permission)
    @people << student
    @data_manager.save_people(@people)
  end

  def create_teacher(age, specialization, name)
    teacher = Teacher.new(age, specialization, name: name)
    @people << teacher
    @data_manager.save_people(@people)
  end

  def create_book()
    puts "\n"
    puts 'Enter book title:'
    title = gets.chomp
    puts 'Enter book author:'
    author = gets.chomp
    book = Book.new(title, author)
    @books << book
    @data_manager.save_books(@books)
  end

  def create_rental()
    puts "\n"
    puts 'Enter rental date:'
    date = gets.chomp
    list_books
    puts 'Enter book number:'
    book = gets.chomp.to_i
    list_people
    puts 'Enter person number:'
    person = gets.chomp.to_i
    rental = Rental.new(date, books[book - 1], people[person - 1])
    @rentals << rental
    @data_manager.save_rentals(@books, @people, @rentals)
  end

  def list_rentals()
    puts "\n"
    list_people
    puts 'Enter person id:'
    id = gets.chomp.to_i
    @people.each do |person|
      next unless person.id == id

      puts "Name: #{person.name}"
      if person.rentals.empty?
        puts 'Has no rentals'
      else
        person.rentals.each do |rental|
          puts "Date: #{rental.date}, Book: #{rental.book.title} by #{rental.book.author}"
        end
      end
    end
  end
end
