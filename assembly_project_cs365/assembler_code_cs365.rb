require 'net/http'
require 'uri'
require 'json'
require 'zip'
require 'fileutils'
output = [] #STORES OUTPUT BINARY

class String #CHECK TO SEE IF YOU ARE LOADING IN A NUMBER VALUE OR A SYMBOLE
    def numeric?
      !Float(self).nil?
    rescue StandardError
      false
    end
  end
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
filename=gets.chomp
file = File.open(Dir.getwd + "/#{filename}")#LOADS IN THE SOURCE CODE
filedata=[]
register = [] # symbole table
file.each_with_index do |line, index|
    filedata[index]=line.gsub("\n","")
end
def decompiler(string)
    if string.length<4
      decompiled=[string,""]
    else
    decompiled=[]
    decompiled=[string[0..3].gsub(" ",""),string[4,string.length].gsub(" ","")]
    end
end
def command_builder(string,string2)
    out_1 = string[0..(15-string2.length)]+string2
end
filedata.each_with_index do  |data,index|
    puts "\n"
    puts "[SYSTEM] PROCESSING LINE:[#{index}]"

   decom_data= decompiler(data)
   puts "[SYSTEM][#{index}] INSTRUCTION:[#{decom_data[0]}] DATA VALUE:[#{decom_data[1]}]"
   


   #processes the numeric values in the psudo code. 
   if decom_data[1].numeric?
    dvb=(decom_data[1].to_i).to_s(2)
    puts "[SYSTEM][#{index}] INSTRUCTION:[#{mnemonic_convert(decom_data[0])}] DATA VALUE:[#{(decom_data[1].to_i).to_s(2)}]"
    puts "[SYSTEM][#{index}] Binary:#{command_builder(mnemonic_convert(decom_data[0]),(decom_data[1].to_i).to_s(2))}"
    output.push(command_builder(mnemonic_convert(decom_data[0]),(decom_data[1].to_i).to_s(2)))
   else
    #processes the non-numeric values
    #if ther register already has this then ok move on.
    if register.include?(decom_data[1])
    else
    #if the register does not already have this add this name to the reigster. 
    register.push(decom_data[1])
    end
    #now we checked if its in the registry list we can now convert it to binary
    #i made this into two steps because it allows the program to be added onto later 
    #if i want to expand the program.

    #looks at the register table and gets the register location
    #converts it to an integer and then to a binary number
    output.push(command_builder(mnemonic_convert(decom_data[0]),((register.index(decom_data[1])).to_i).to_s(2)))
    puts "[SYSTEM][#{index}] Binary:#{command_builder(mnemonic_convert(decom_data[0]),((register.index(decom_data[1])).to_i).to_s(2))}"
   end
end
#instruction printer. Allows you to check the code. becide your instruction
puts "This allows you to check the binary next to each line input"
    puts "This is not needed for the program to run only to check"
filedata.each_with_index do |data,index|
    decom_data= decompiler(data)
puts "Instruction:[#{decom_data[0]}] Value:[#{decom_data[1]}] Binary:[#{output[index]}]"
end
#Save Binary Data to file
out_file = File.new(Dir.getwd + '/binaryout.txt', 'w')
output.each do |value|
puts out_file.puts(value)
end