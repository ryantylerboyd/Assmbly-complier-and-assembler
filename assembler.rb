require 'net/http'
require 'uri'
require 'json'
require 'zip'
require "fileutils"
output = []
register = ["sum"] #symbole table
file = File.open(Dir.getwd+"/test.txt")
def mnemonic_convert(string) #converts mnemonic to binary
    case string
    when "LODD"
        "0000000000000000"
    when "STOD"
        "0001000000000000"
    when "ADDD"
        "0010000000000000"
    when "SUBD"
        "0011000000000000"
    when "JPOS"
        "0100000000000000"
    when "JZER"
        "0101000000000000"
    when "JUMP"
        "0110000000000000"
    when "LOCO"
        "0111000000000000"
    when "LODL"
        "1000000000000000"
    when "STOL"
        "1001000000000000"
    when "ADDL"
        "1010000000000000"
    when "SUBL"
        "1011000000000000"
    when "JNEG"
        "1100000000000000"
    when "JNZE"
        "1101000000000000"
    when "CALL"
        "1110000000000000"
    when "PSHI"
        "1111000000000000"
    when "POPI"
        "1111001000000000"
    when "PUSH"
        "1111010000000000"
    when "POP"
        "1111011000000000"
    when "RETN"
        "1111100000000000"
    when "SWAP"
        "1111101000000000"
    when "INSP"
        "1111110000000000"
    when "DESP"
        "1111111000000000"
    else
        "0"
    end
end
class String
    def numeric?
      Float(self) != nil rescue false
    end
end

file.each_with_index do |line,index|
    operator=""
    operand=""
    line_split = line.split
    line_split.each_with_index do |line, index|
        if index==0
            puts "OPERATOR FOUND #{line}"
            operator = mnemonic_convert(line)
            puts "OPERATOR FOUND #{operator}"
        else
            puts line
            if line.numeric? && line.to_i > 0 
                operand = line.to_s
            else
                if register.include?(line)
                    operand = register.index(line)
                else
                    register.push(line)
                    operand = register.index(line)
                end
            end
        end
    end
    puts "OPERATOR:#{operator} OPERAND:#{operand}"
    convert1=operator.to_s
    convert2=operand.to_s
    if convert2.length < 15
        convert2= convert2.to_i.to_s(2)
    end
    while convert1.length < 16
        convert1 = "0"+convert1
    end
    while convert2.length < 16
        convert2 = "0"+convert2
    end
    puts "convert1:#{convert1} convert2:#{convert2}"
    convert1=convert1.to_s.to_i(2)
    convert2=convert2.to_s.to_i(2)
    command = (convert1+convert2).to_s(2)
    while command.length < 16
        command = "0"+command
    end
    output.push(command)
end
out_file = File.new(Dir.getwd+"/binaryout.txt", "w")
output.each do |value|
    puts out_file.puts(value)
end
out_file.close
p output
p register