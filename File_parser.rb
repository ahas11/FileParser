#!/usr/bin/ruby -w
require 'yaml'

def parse_yaml_line(line)
	unless line.include?(":")
		return line.strip, nil
	end

	key, value = line.split(":", 2)

	return key.strip, value.nil? ? nil : value.strip
end

def parse_yaml(yaml_string)
	puts "Parsing a Yaml"
	lines = yaml_string.split(/\n/)
	result = {}
	stack = [result]
	current_indent = 0 
	for line in lines
		stripped_line = line.strip
		unless stripped_line || stripped_line.start_with?("#")
			next
		end

		indent = line.length - line.lstrip.length

		if indent > current_indent
			parent = stack[-1]
			last_key =  Array(parent.keys())[-1]
			parent[last_key] = {}
			stack.append(parent[last_key])
		elsif indent < current_indent
			while indent < current_indent
				stack.pop()
				current_indent -= 2
			end
		end
		current_indent = indent
		key, value = parse_yaml_line(line)
		stack[-1][key] = value
	end
		return result
end

file = File.open("yaml_data.txt")
yaml_data = file.read

puts parse_yaml(yaml_data)



