require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

def prompt(message)
  puts "=> #{message}"
end

# Removes all zeros that are located at the beginning of the string
def adjust_string(num)
  counter = 0
  if num.include?(".")
    d_point = num.index(".")
    if num.to_i == 0
      num = "0" + num.slice(d_point..num.size)
    end
  else
    while counter < num.size
      break if num[counter].to_i > 0
      num.delete!(num[counter])
    end
  end
  num == "" ? "0" : num
end

def integer?(num)
  num.to_i.to_s == num
end

def float?(num)
  array_num = num.split("").map { |n| n.to_i.to_s if n != "." }
  array_string = num.split("").map { |n| n if n != "." }
  return false if array_num.count(nil) > 1
  array_num == array_string
end

def valid_number?(num)
  arr = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "."]
  counter = 0
  while counter < num.size
    return false if !arr.include?(num[counter])
    counter += 1
  end
  num = adjust_string(num) if num.size > 1
  float?(num) || integer?(num)
end

# def valid_number?(num)
#   num = adjust_string(num) if num.size > 1
#   p num
#   float?(num) || integer?(num)
# end

def operation_to_message(op)
  result =  case op
            when '1' then "Adding"
            when '2' then "Multiplying"
            when '3' then "Dividing"
            else "subtracting"
            end
  result
end

def calculate(op, num1, num2)
  result =  case op
            when '1' then num1 + num2
            when '2' then num1 * num2
            when '3' then num1 / num2
            else num1 - num2
            end
  result
end

def get_number(num, order)
  loop do
    prompt "Enter the #{order} number"
    num = gets.chomp

    break if valid_number?(num)
    prompt MESSAGES['invalid_number']
  end

  num
end

prompt(MESSAGES['welcome'])
name = ''

loop do
  name = gets.chomp

  break if !name.empty?
  puts MESSAGES['valid_name']
end

prompt("Hi #{name}")

loop do
  operator = ''
  first_num = ''
  second_num = ''

  first_num = get_number(first_num, "first")
  second_num = get_number(second_num, "second")

  prompt(MESSAGES['get_operator'])
  loop do
    operator = gets.chomp
    break if %w(1 2 3 4).include?(operator)
    prompt(MESSAGES['invalid_operator'])
  end

  prompt("#{operation_to_message(operator)} the numbers...")

  result = calculate(operator, first_num.to_f, second_num.to_f)

  prompt("The result is #{result}")
  prompt(MESSAGES['start_over'])
  answer = gets.chomp.downcase

  break if answer.start_with?('n')
end
