require 'yaml'
MESSAGES = YAML.load_file('loan_calc_messages.yml')

def valid_name
  puts MESSAGES['name']
  name = gets.chomp
  while !name.match?(/^[a-zA-Z]+$/)
    puts MESSAGES['invalid_name']
    name = gets.chomp
  end

  name
end

def valid_answer
  puts MESSAGES['start_over']
  answer = gets.chomp.downcase
  answer_arr = ["yes", "no", "y", "n"]

  while !answer_arr.include?(answer)
    puts MESSAGES['invalid_answer']
    answer = gets.chomp.downcase.strip
  end

  answer
end

def validate_number(num, over_zero)
  return false if num.to_f == 0 && over_zero
  num.match?(/\A\d+\.\d+\Z/) || num.match?(/\A\d+\Z/)
end

def prompt(msg, over_zero)
  puts MESSAGES[msg]
  var = gets.chomp
  while validate_number(var, over_zero) == false
    puts MESSAGES['valid_number']
    var = gets.chomp
  end
  var
end

def print_results(name, loan_amount, duration, interest_rate, monthly_pmt)
  puts <<-STR
  => Name: #{name}
  => Loan Amount: #{loan_amount} dollars
  => Loan Term: #{duration} months
  => Loan Rate: #{format('%.2f', interest_rate)} %
  ==> Monthly Payments : #{format('%.2f', monthly_pmt)} dollars
  ==> Total #{duration} Payments: #{format('%.2f', (monthly_pmt.to_f * duration))} dollars
  ==> Total Interest: #{format('%.2f', ((monthly_pmt.to_f * duration) - (loan_amount.to_f)))} dollars
  STR
end

def calculate_pmt(loan_amount, interest_rate, duration)
  return loan_amount / duration if interest_rate == 0
  loan_amount * ((interest_rate) / (1 - ((1 + interest_rate)**(-duration))))
end

YEAR = 12

puts MESSAGES['welcome']

name = valid_name

puts "Hello, #{name}."

loop do
  loan_amt = prompt('loan_amount', true)
  rate = prompt('interest_rate', false)
  loan_term = prompt('duration', true)

  duration = loan_term.to_f * YEAR
  monthly_rate = (rate.to_f / 100) / YEAR
  monthly_pmt = calculate_pmt(loan_amt.to_f, monthly_rate, duration)

  print_results(name, loan_amt, duration, rate, monthly_pmt)

  answer = valid_answer
  break if answer == "n" || answer == "no"
end
