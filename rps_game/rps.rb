require 'yaml'
MESSAGES = YAML.load_file('rps.yml')

ROCK = 'R'
PAPER = 'P'
SCISSORS = 'S'
LIZARD = 'L'
SPOCK = 'SP'

CHOICES = [ROCK, PAPER, SCISSORS, LIZARD, SPOCK]

POSSIBLE_CHOICES = {
  PAPER => [ROCK, SPOCK],
  SCISSORS => [PAPER, LIZARD],
  ROCK => [SCISSORS, LIZARD],
  LIZARD => [PAPER, SPOCK],
  SPOCK => [SCISSORS, ROCK]
}

PROMPT = <<-STR
  ==> Please, select:
    => P for paper
    => R for rock
    => S for scissors 
    => L for lizzard
    => SP for spock
STR

def prompt_name
  puts MESSAGES['name']
  name = gets.chomp
  until name.match?(/^[a-zA-Z]+$/)
    puts MESSAGES['invalid_name']
    name = gets.chomp
  end
  name
end

def prompt_choice
  player_choice = gets.chomp.upcase
  until CHOICES.include?(player_choice)
    puts "Invalid answer. #{player_choice} is not an option"
    puts PROMPT
    player_choice = gets.chomp.upcase
  end
  player_choice
end

def prompt_answer
  puts MESSAGES['answer']
  answer = gets.chomp.downcase
  answer_arr = %w[yes no y n]

  until answer_arr.include?(answer)
    puts MESSAGES['invalid_answer']
    answer = gets.chomp.downcase.strip
  end
  answer
end

def get_winner(points)
  winner = if points == [0, 0]
             'NO WINNER'
           elsif points == [1, 0]
             'YOU WON'
           else
             'COMPUTER WON'
           end
  winner
end

def calculate_points(choice1, choice2)
  points = 0
  if choice1 == choice2
    points += 0
  elsif POSSIBLE_CHOICES[choice1].include?(choice2)
    points += 1
  end
  points
end

def store_points(player_choice, computer_choice, player, computer)
  player << calculate_points(player_choice, computer_choice)
  computer << calculate_points(computer_choice, player_choice)
  [player.last, computer.last]
end

def final_results(name, player, computer)
  printed = if player.sum == computer.sum
              'No Winner'
            elsif player.sum > computer.sum
              "#{name.capitalize} Won"
            else
              'Computer Won'
            end
  "==> #{printed} <== \n#{name} = #{player.sum} \nComputer = #{computer.sum}"
end

def print_report(name, player, computer)
  counter = 0
  puts "===> Final Report <==="
  puts "Round  |  #{name} |  Computer"
  puts "____________________________"
  while counter < player.size
    puts "Round #{counter + 1}|  #{player[counter]}     |  #{computer[counter]}"
    puts "____________________________"
    counter += 1
  end
  puts "Thank you for playing. hope you enjoyed the game!"
end

def exit_game(name, wins_limit, player, computer, answer)
  if wins_limit == player.sum || wins_limit == computer.sum
    system 'clear'
    puts final_results(name, player, computer)
    print_report(name, player, computer)
    answer << prompt_answer
  end
end

def game_over
  true
end

def valid_number?(num)
  return false if num.to_i <= 0
  num.match?(/\A\d+\Z/)
end

def prompt_number
  puts MESSAGES['win_limit']
  limit = gets.chomp
  until valid_number?(limit)
    puts MESSAGES['invalid_limit']
    limit = gets.chomp
  end
  limit
end

def current_result(player, computer, player_choice, computer_choice, winner)
  puts "Player = #{player.sum}  |  Computer = #{computer.sum}"
  puts "entry = #{player_choice}  |  entry = #{computer_choice}"
  puts "===> #{winner} <==="
end

puts MESSAGES['welcome']
name = prompt_name

player = []
computer = []
player_choice = ''
computer_choice = ''
winner = ''

wins = prompt_number

loop do
  system 'clear'

  puts "Hello, #{name}."
  current_result(player, computer, player_choice, computer_choice, winner)

  puts PROMPT
  player_choice = prompt_choice
  computer_choice = CHOICES.sample
  results = store_points(player_choice, computer_choice, player, computer)
  winner = get_winner(results)

  answer = ''
  exit_game(name, wins.to_i, player, computer, answer)
  if answer.include?("y")
    player = []
    computer = []
    wins = prompt_number
  elsif answer.include?("n")
    break
  end
end
