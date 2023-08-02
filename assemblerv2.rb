require 'net/http'
require 'uri'
require 'json'
require 'zip'
require 'fileutils'
output = [] #STORES OUTPUT BINARY
register = ['sum'] # symbole table
file = File.open(Dir.getwd + '/inputfile.txt')#LOADS IN THE SOURCE CODE
def mnemonic_convert(string) # converts mnemonic to binary
  case string
  when 'LODD'
    '0000000000000000'
  when 'STOD'
    '0001000000000000'
  when 'ADDD'
    '0010000000000000'
  when 'SUBD'
    '0011000000000000'
  when 'JPOS'
    '0100000000000000'
  when 'JZER'
    '0101000000000000'
  when 'JUMP'
    '0110000000000000'
  when 'LOCO'
    '0111000000000000'
  when 'LODL'
    '1000000000000000'
  when 'STOL'
    '1001000000000000'
  when 'ADDL'
    '1010000000000000'
  when 'SUBL'
    '1011000000000000'
  when 'JNEG'
    '1100000000000000'
  when 'JNZE'
    '1101000000000000'
  when 'CALL'
    '1110000000000000'
  when 'PSHI'
    '1111000000000000'
  when 'POPI'
    '1111001000000000'
  when 'PUSH'
    '1111010000000000'
  when 'POP'
    '1111011000000000'
  when 'RETN'
    '1111100000000000'
  when 'SWAP'
    '1111101000000000'
  when 'INSP'
    '1111110000000000'
  when 'DESP'
    '1111111000000000'
  else
    '0'
  end
end

class String #CHECK TO SEE IF YOU ARE LOADING IN A NUMBER VALUE OR A SYMBOLE
  def numeric?
    !Float(self).nil?
  rescue StandardError
    false
  end
end
operator = ''
operand = ''
def pushbinary(operator,operand)#JOINS THE OPERATOR AND OPERAND INTO A SINGLE 16 BIT BINARY
    convert1=operator.to_s
    convert2=operand.to_s
    while convert1.length < 16
        convert1 = "0"+convert1
    end
    while convert2.length < 16
        convert2 = "0"+convert2
    end
    convert1=convert1.to_s.to_i(2)
    convert2=convert2.to_s.to_i(2)
    command = (convert1+convert2).to_s(2)
    while command.length < 16
        command = "0"+command
    end
    p command
end
file.each_with_index do |line, index|#READS OM THE SOURCE CODE
  if line.match(':')#IF IT MATCHES A TAG THEN ADD TAG TO SYMBOLE TABLE AND GET TAG LOCATION
    operator=mnemonic_convert('LOCO')
    operand=index.to_s
    command=pushbinary(operator,operand)
    output.push(command)
    operator=mnemonic_convert('STOD')
    line=line.gsub(":","").gsub("\n","")
    register.push(line)
    operand = register.index(line)
    reverse_index = "0000111111111111".to_s.to_i(2)
    operand = (reverse_index-operand).to_s(2)
    command=pushbinary(operator,operand)
    output.push(command)
  else#PLIT THE OPERATOR AND OPERAND
    line_split = line.split
    line_split.each_with_index do |line, index|
      if index == 0#CONVERT THE OPERATOR ON THE TABLE
        operator = mnemonic_convert(line)
      else#CONVERT THE SYMBOLE TO BINARY
        if line.numeric? && line.to_i > 0#TELLS THE PROGRAM THAT THIS IS A VALUE NOT A SYMBOLE
          operand = line.to_s
        elsif register.include?(line)#LOOKS TO SEE IF THE OPERAND HAS BEEN USED BEFORE
          operand = register.index(line)
          reverse_index = "0000111111111111".to_s.to_i(2)
          operand = (reverse_index-operand).to_s(2)
        else#LOOKS TO SEE IF THE OPERAND HAS BEEN USED BEFORE
          register.push(line)
          operand = register.index(line)
          reverse_index = "0000111111111111".to_s.to_i(2)
          operand = (reverse_index-operand).to_s(2)
        end
      end
    end
    command=pushbinary(operator,operand)#combines the operator and operand into one 16 BIT VALUE
    output.push(command)#stores the command onto a stack
  end
  operator = ''
  operand = ''
end
out_file = File.new(Dir.getwd + '/binaryout.txt', 'w')
output.each do |value|
puts out_file.puts(value)
end
out_file.close
p "BINARY OUTPUT"
pp output
p "SYMBOLE TABLE"
pp register
