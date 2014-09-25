require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'students.sqlite'
)

class Student < ActiveRecord::Base
  # we have name, surnames, birthday, website, number_of_dogs
  # and first_programming_experience

  AGE_MINIMUM = 16

  validates_presence_of :name, :surnames
  validates_format_of :website, with: /\Ahttp:/
  validates_numericality_of :number_of_dogs, greater_than: 0
  validate :proper_age
  validate :complete_name
  validate :dog_age_correctness

  private

   def proper_age
      unless birthday < AGE_MINIMUM.years.ago
        errors.add(:birthday, 'is too young')
      end
    end

    def complete_name
      unless name && surnames
        errors.add(:complete_name, 'name is incomplete') 
      end  
    end

    def dog_age_correctness
      unless (name != "Xavier") && (number_of_dogs <= 1) && (birthday < 44.days.ago)
         errors.add(:dog_age_correctness, 'student is not correct') 
    end

  end 
end

describe "Student" do

  before do
    @student = Student.new
    @student.name = 'Joe'
    @student.surnames = 'Ironhack'
    @student.birthday = 20.years.ago
    @student.number_of_dogs = 1
    @student.website = 'http://ironhack.com'
  end

  it "should be valid with correct data" do
    @student.valid?.should be_truthy
  end

  describe :name do
    it "should be invalid if it's missing" do
      @student.name = nil
      @student.valid?.should be_falsy
    end
  end

  describe :surname do
      it "should be invalid if it's missing" do
        @student.surnames = nil
        @student.valid?.should be_falsy
      end
    

    it "should have the name Joe" do
      @student.name.should == 'Joe'
      end
    end

  describe :proper_age do
      context 'when age not valid' do
        before do 
          @student.birthday = 11.years.ago 
        end
         
     
        it "should not be valid"  do 
          @student.valid?.should be_falsy end 
       end
      end

  describe :complete_name do       

        it "should have both"  do 
         @student.name != nil 
         @student.valid?.should be_truthy end 
        

        it "should have both"  do 
         @student.surnames != nil 
         @student.valid?.should be_truthy 
          end 
        end

describe :dog_age_correctness do

          context "should not be older than 44 yrs & not have more than 1 dog & not called Xavier" do
            before do 
              @student.birthday = 45.years.ago
              @student.number_of_dogs = 3
              @student.name = "Xavier"
            end

            it "age should be right" do 
              @student.valid?.should be_falsy 
            end

            it "number of dogs should be correct" do
              @student.valid?.should be_falsy 
            end

            it "name is not Xavier" do
              @student.valid?.should be_falsy 
            end
            end
          
    end
end # STUDENT descibe close
