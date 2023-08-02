require 'net/http'
require 'uri'
require 'json'
require 'zip'
require 'fileutils'
filename=gets.chomp
file = File.open(Dir.getwd + "/binaryout.txt")#LOADS IN THE SOURCE CODE
filedata=[]
register = [] # HOLDS ALL THE VALUES
sp=0
ac=0
mx=0
pc=0
#read in the file program. Although assembler normally reads in line by line we are going to save the
#data into the program so we can access each line that way. Instead of file reads which can
#cause errors.
file.each_with_index do |line, index|
    filedata[index]=line.gsub("\n","")
end
if filedata.size < 4096
    array_size = filedata.size+1
else
    array_size = 4096
end
register=Array.new(array_size) {|x| 0}
def decompiler(string)
    decompiled=[]
    decompiled=[string[0..3],string[4,15]]
end
def value(string)
    num_val=string.to_i(2)
end
#start processing the file data
pc=0
while(pc<filedata.size)
    puts "\n"
    puts "[SYSTEM] CURRENT LINE READ #{pc}"
    incomdata= decompiler(filedata[pc])
    if incomdata[0] == "0000"
        #puts value(incomdata[1])
        puts "LODD"
        puts "[SYSTEM] ac:=m[x]"
        ac=register[(incomdata[1].to_i(2))]
    elsif incomdata[0] == "0001"
        puts "STOD"
        puts "[SYSTEM] m[x]:=ac"
        register[(incomdata[1].to_i(2))]=ac
        puts "[SYSTEM] #{register[(incomdata[1].to_i(2))]}"
    elsif incomdata[0] == "0010"
        puts "ADDD"
        puts "[SYSTEM] ac:=ac+m[x]"
        ac = ac + register[(incomdata[1].to_i(2))]
        puts "[SYSTEM] #{ac}"
    elsif incomdata[0] == "0011"
        puts "SUBD"
        puts "[SYSTEM] ac:=ac-m[x]"
        ac = ac - register[(incomdata[1].to_i(2))]
        puts "[SYSTEM] #{ac}"
    elsif incomdata[0] == "0100"
        puts "JPOS"
        if ac >=0
            pc = (incomdata[1].to_i(2))
        end
        puts "[SYSTEM] #{pc}"
    elsif incomdata[0] == "0101"
        puts "JZER"
        if ac ==0
            pc = (incomdata[1].to_i(2))
        end
        puts "[SYSTEM] #{pc}"
    elsif incomdata[0] == "0110"
        puts "JUMP"
        pc = (incomdata[1].to_i(2))
        puts "[SYSTEM] #{pc}"
    elsif incomdata[0] == "0111"
        puts "LOCO"
        puts "[SYSTEM] ac:=x(0<=x<=4095)"
        ac=incomdata[1].to_i(2)
        puts "[SYSTEM] #{ac}"
    elsif incomdata[0] == "1000"
        puts "LODL"
        puts "[SYSTEM] ac:=m[sp+x]"
        ac = register[(incomdata[1].to_i(2))+sp]
        puts "[SYSTEM] #{ac}"
    elsif incomdata[0] == "1001"
        puts "STOL"
        puts "[SYSTEM] m[sp+x]:=ac"
        register[(incomdata[1].to_i(2))+sp]=ac
        puts "[SYSTEM] #{register[(incomdata[1].to_i(2))+sp]}"
    elsif incomdata[0] == "1010"
        puts "ADDL"
        puts "[SYSTEM] ac:=ac+m[sp+x]"
        ac =ac + register[(incomdata[1].to_i(2))+sp]
        puts "[SYSTEM] #{ac}"
    elsif incomdata[0] == "1011"
        puts "SUBL"
        puts "[SYSTEM] ac:=ac+m[sp+x]"
        ac =ac - register[(incomdata[1].to_i(2))+sp]
        puts "[SYSTEM] #{ac}"
    elsif incomdata[0] == "1100"
        puts "JNEG"
        if ac < 0
            pc = (incomdata[1].to_i(2))
        end
        puts "[SYSTEM] #{pc}"
    elsif incomdata[0] == "1101"
        puts "JNZE"
        if ac != 0
            pc = (incomdata[1].to_i(2))
        end
        puts "[SYSTEM] #{pc}"
    elsif incomdata[0] == "1110"
        puts "CALL"
        sp=sp-1
        register[sp]=pc
        pc=(incomdata[1].to_i(2))
    elsif incomdata[0] == "1111"
        #nextdatastream
        incomdata_2=filedata[pc][0..7]
        if incomdata_2 == "11110000"
            puts "PSHI"
            sp=sp-1
            register[sp]=register[ac]
        elsif incomdata_2 == "11110010"
            puts "POPI"
            register[ac]=register[sp]
            sp=sp+1
        elsif incomdata_2 == "11110100"
            puts "PUSH"
            sp=sp-1
            register[sp]=ac
        elsif incomdata_2 == "11110110"
            puts "POP"
            ac=register[sp]
            sp=sp+1
        elsif incomdata_2 == "11111000"
            puts "RETN"
            pc=register[sp]
            sp=sp+1
        elsif incomdata_2 == "11111010"
            puts "SWAP"
            tmp=ac
            ac=sp
            sp=tmp
        elsif incomdata_2 == "11111100"
            puts "INSP"
            sp=sp+(incomdata[1].to_i(2))
        elsif incomdata_2 == "11111110"
            puts "DESP"
            sp=sp-(incomdata[1].to_i(2))
        end
    end
    p register
    puts "[system] sp:#{sp} ac:#{ac} mx:#{mx} pc:#{pc}"
    pc+=1
end
pp register
