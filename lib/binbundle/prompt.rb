# frozen_string_literal: true

module Binbundle
  # Command line prompts
  module Prompt
    ##
    ## Ask a yes or no question in the terminal
    ##
    ## @param      question          [String] The question
    ##                               to ask
    ## @param      default_response  [Boolean]   default
    ##                               response if no input
    ##
    ## @return     [Boolean] yes or no
    ##
    def self.yn(question, default_response: nil)
      $stdin.reopen('/dev/tty')

      default = if default_response.is_a?(String)
                  default_response =~ /y/i ? true : false
                else
                  default_response
                end

      # if this isn't an interactive shell, answer default
      return default unless $stdout.isatty

      # clear the buffer
      if ARGV&.length
        ARGV.length.times do
          ARGV.shift
        end
      end
      system 'stty cbreak'

      options = if default.nil?
                  '[y/n]'
                else
                  "[#{default ? 'Y/n' : 'y/N'}]"
                end
      $stdout.syswrite "#{question.sub(/\?$/, '')} #{options}? "
      res = $stdin.sysread 1
      puts
      system 'stty cooked'

      res.chomp!
      res.downcase!

      return default if res.empty?

      res =~ /y/i ? true : false
    end
  end
end
