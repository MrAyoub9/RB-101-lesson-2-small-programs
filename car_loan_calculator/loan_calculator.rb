require 'yaml'
MESSAGES = YAML.load_file('loan_calc_messages.yml')


def is_number?(num)
  arr = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "."]
  counter = 0
  while counter < num.size
    return false if !arr.include?(num[counter])
    counter += 1
  end
  true
end

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

def validate_number(num)
  if !is_number?(num)
    return false
  else
    num = adjust_string(num) if num.size > 1
    array_num = num.split("").map { |n| n.to_i.to_s if n != "." }
    array_string = num.split("").map { |n| n if n != "." }
    return false if array_num.count(nil) > 1
    array_num == array_string
  end
end

def prompt(msg, var)
  puts MESSAGES[msg]
  var = gets.chomp
  while validate_number(var) == false 
    puts MESSAGES['valid_number']
    var = gets.chomp
  end
  return var
end
  
def print_results(name, loan_amount, duration, interest_rate, monthly_pmt)
  puts <<-STR
  => Name: #{name}
  => Loan Amount: #{loan_amount} dollars
  => Loan Term: #{duration} months
  => Loan Rate: #{interest_rate} %
  ==> Monthly Payments : #{monthly_pmt} dollars
  ==> Total #{duration} Payments: #{monthly_pmt.to_f*duration} dollars
  ==> Total Interest: #{(monthly_pmt.to_f*duration) - (loan_amount.to_f)} dollars
  STR
end

def calculate_pmt(loan_amount, interest_rate, duration)
  if interest_rate > 0
    loan_amount * ((interest_rate) / (1 - ((1 + interest_rate)**(-duration))))
  else
    loan_amount / duration
  end
end

YEAR = 12

puts MESSAGES['welcome']

puts MESSAGES['name']
name = gets.chomp

# while !valid_name()
#   puts MESSAGES['valid_name']
#   name = gets.chomp
# end

puts "Hello, #{name}."

loop do
  loan_amount = prompt('loan_amount', loan_amount)

  interest_rate = prompt('interest_rate', interest_rate)

  loan_term = prompt('duration', loan_term)

  duration = loan_term.to_f * YEAR
  monthly_pmt = calculate_pmt(loan_amount.to_f, interest_rate.to_f, duration)

  print_results(name, loan_amount, duration, interest_rate, monthly_pmt)

  # puts "Name: #{name}"
  # puts "Loan Amount: #{loan_amount} dollars"
  # puts "Loan Term: #{duration} months"
  # puts "Loan Rate: #{interest_rate}"
  # puts "==> Monthly Payments : #{monthly_pmt}"

  # print_results(name, loan_amount, duration, interest_rate, monthly_pmt)

  # puts MESSAGES['loan_amount']
  # loan_amt = gets.chomp
  # validate_number(loan_amt)

  # puts MESSAGES['interest_rate']
  # interest_rate = gets.chomp
  # validate_number(interest_rate)

  # puts MESSAGES['duration']
  # loan_term = gets.chomp
  # validate_number(loan_term)

  # duration = loan_term * YEAR
  # monthly_pmt = calculate_pmt(loan_amt, interest_rate, duration)

  #create variable to store this prompt
  # <<-STR
  # Name: #{name}
  # Loan Type: #{loan_type}
  # Loan Amount: #{loan_amount} dollars
  # Loan Term: #{duration} months
  # Loan Rate: #{APR}
  # ==> Monthly Payments : #{monthly_pmt}
  # STR

  puts "would you like to perform another loan calculation (Yes/No)?"
  answer = gets.chomp.downcase
  # validate_answer(answer)
  break if answer == "y" || answer == "yes"
end