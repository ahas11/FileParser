#!/usr/bin/ruby -w

# A function to parse one line of of a yaml file
def parse_yaml_line(line)

	#unless the line includes a semi colon, it is not a key and value pair
	#if the line does not contain a semi colon, it is stripped and returned as the key while
	#the value becomes nil 
	unless line.include?(":")
		return line.strip, nil
	end

	#splitting the line at the first colon to create a key and value pair
	key, value = line.split(":", 2) 

	#returning the key stripped of whitespace
	#if value is nill it gets returned as nil, 
	#if value is not nil, return the value stripped of white space
	return key.strip, value.nil? ? nil : value.strip
end

# a funtion to parse a yaml document using the parse_yaml_line function
def parse_yaml(yaml_string)
	puts "Parsing a Yaml"
	lines = yaml_string.split(/\n/) #the yaml string gets split into individual lines
	result = {} #initializing an empty hash table for the parsed data
	stack = [result] ##initializing a stack that has the result hash as the first element
	current_indent = 0  #to track the current indentation in the yaml file
	for line in lines
		stripped_line = line.strip #stripping the line of whitespace
		#if the stripped_line is nil or starts with a # (a comment), move on to the next iteration
		unless stripped_line || stripped_line.start_with?("#") 
			next
		end

		#calculating the indentaion
		indent = line.length - line.lstrip.length

		#if the indent is bigger than the current indentation
		if indent > current_indent
			parent = stack[-1] #get the result hash table
			last_key =  Array(parent.keys())[-1] #getting the last key used in the result hash table
			parent[last_key] = {} #creating another hash table with the parent set as the last key used
			stack.append(parent[last_key]) #appending the hash table where the parent is the last key used
		#if the indent is smaller than the current indentation
		elsif indent < current_indent
			#as long as the indentation is smaller than the current indentation
			while indent < current_indent
				stack.pop() #moving up one level in the stack  
				current_indent -= 2
			end
		end
		current_indent = indent
		key, value = parse_yaml_line(line) #calling the parse_yaml_line to parse the current line
		stack[-1][key] = value #setting the current key with its value in the parent's hash table
	end
		return result #returning the result hash table, which contains all keys and values
end

# opening the yaml file
file = File.open("yaml_data2.yml")
# reading the yaml file
yaml_data = file.read
# parsing the yaml file
puts parse_yaml(yaml_data)