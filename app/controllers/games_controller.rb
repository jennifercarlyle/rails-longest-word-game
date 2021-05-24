require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = rand_letters
  end

  def score
    @guess = params[:guess]
    @grid = params[:grid]
    @result = result(@guess, @grid)
  end

  def result(guess, grid)
    if word_in_grid?(guess, grid) == false
      'Oops! You must use only letters from the grid.'
    elsif valid_word?(guess) == false
      "I'm sorry, #{guess.capitalize} is not a valid english word."
    else
      "Congratulations! #{guess.capitalize} is a valid english word!"
    end
  end

  private

  def rand_letters
    alphabet = ('A'..'Z').to_a
    rand_letters = []
    10.times do
      rand_letters << alphabet.sample
    end
    rand_letters
  end

  def valid_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_response = URI.open(url).read
    response = JSON.parse(word_response)
    response['found']
  end

  def word_in_grid?(word, grid)
    letters_array = []
    word.upcase.chars.each do |letter|
      if grid.include?(letter) && word.upcase.count(letter) <= grid.count(letter)
        letters_array << 'yes'
      else
        letters_array << 'no'
      end
    end
    letters_array.all? { |item| item == 'yes' }
  end
end
