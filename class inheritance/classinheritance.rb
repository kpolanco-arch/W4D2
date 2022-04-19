class Employee
attr_reader :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name= name
    @title = title
    @salary = salary
    @boss = boss

  end

  def bonus(multiplier)
    bonus = salary * multiplier
  end


end


class Manager < Employee

  attr_reader :employees

  def initialize(name, title, salary, boss)
    super
    @employees = []
  end

  def add_employee(*employee)
    employee.each { |emp| @employees << emp }
  end

  def bonus(multiplier)

    multiplier * self.sum_salary
    
  end

  def sum_salary
    return 0 if @employees.empty?
    count=0
    @employees.each do |employee|
      count+= employee.salary
      if employee.is_a?(Manager)
       count+= employee.sum_salary
      end
    end
    return count
  end
end

david = Employee.new("David", "TA", 10000, "Darren")
shawna = Employee.new("Shawna", "TA", 12000, "Darren")
darren = Manager.new("Darren", "TA Manager", 78000, "Ned")
ned = Manager.new("Ned", "Founder", 1000000, nil)

darren.add_employee(david, shawna)
ned.add_employee(darren)

p ned.bonus(5)
p darren.bonus(4)
p david.bonus(3)