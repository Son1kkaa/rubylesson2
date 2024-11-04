require 'minitest/autorun'
require 'minitest/reporters'
require_relative 'home1'  # Підключення першого файлу з оновленою назвою
require 'date'

# Налаштування Minitest для створення звіту у форматі HTML
Minitest::Reporters.use! Minitest::Reporters::HtmlReporter.new

class StudentTest < Minitest::Test
  def setup
    Student.clear_students  # Очищення списку студентів перед кожним тестом
    @student = Student.new("Smith", "John", Date.new(2000, 5, 15))
  end

  def test_initialization
    assert_equal "Smith", @student.surname
    assert_equal "John", @student.name
    assert_equal Date.new(2000, 5, 15), @student.date_of_birth
  end

  def test_calculate_age
    expected_age = Date.today.year - 2000 - (Date.today < Date.new(Date.today.year, 5, 15) ? 1 : 0)
    assert_equal expected_age, @student.calculate_age
  end

  def test_add_duplicate_student
    student_count_before = Student.students.size
    duplicate_student = Student.new("Smith", "John", Date.new(2000, 5, 15))
    assert_equal student_count_before, Student.students.size, "Дубльований студент не повинен додаватися"
  end

  def test_get_students_by_age
    age = @student.calculate_age
    students_by_age = Student.get_students_by_age(age)
    assert_includes students_by_age, @student
  end

  def test_get_students_by_name
    students_by_name = Student.get_students_by_name("John")
    assert_includes students_by_name, @student
  end

  def test_invalid_date_of_birth
    assert_raises(ArgumentError) do
      Student.new("Invalid", "Date", Date.today + 1)
    end
  end
end

# Тести у стилі Spec
describe Student do
  before do
    Student.clear_students  # Очищення списку студентів перед кожним тестом
    @student = Student.new("Doe", "Jane", Date.new(1995, 8, 23))
  end

  it "ініціалізується з коректними атрибутами" do
    _(@student.surname).must_equal "Doe"
    _(@student.name).must_equal "Jane"
    _(@student.date_of_birth).must_equal Date.new(1995, 8, 23)
  end

  it "обчислює правильний вік" do
    expected_age = Date.today.year - 1995 - (Date.today < Date.new(Date.today.year, 8, 23) ? 1 : 0)
    _(@student.calculate_age).must_equal expected_age
  end

  it "не додає дубльованих студентів" do
    initial_size = Student.students.size
    duplicate = Student.new("Doe", "Jane", Date.new(1995, 8, 23))
    _(Student.students.size).must_equal initial_size
  end

  it "знаходить студентів за віком" do
    age = @student.calculate_age
    students_by_age = Student.get_students_by_age(age)
    _(students_by_age).must_include @student
  end

  it "знаходить студентів за іменем" do
    students_by_name = Student.get_students_by_name("Jane")
    _(students_by_name).must_include @student
  end

  it "викидає помилку для майбутньої дати народження" do
    _(proc { Student.new("Future", "Person", Date.today + 1) }).must_raise ArgumentError
  end
end
