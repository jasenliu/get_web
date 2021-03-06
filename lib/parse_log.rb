require 'rubygems'
#require 'ftools'
require 'fileutils'
require 'find'

def dir_validate(file_path)
	dir = File.dirname(file_path)
	FileUtils.mkdir_p(dir) if !File.directory?(dir)
end

def delete_dir(file_path)
	Find.find(file_path) do |file|
		next if file == file_path
		if File.directory?(file)
			FileUtils.remove_dir(file)
		else
			File.delete(file)
		end
	end
end

def get_file_list(log_path)
	js_file_list = []
	non_js_file_list = []
	
	lines = File.open(log_path).readlines
	lines.each do |line|
    if line.end_with?(".js\n")
			js_file_list << line
		else
			if line.include?("revision") || line.include?("Updating")
				puts "ignore..."
			else
				non_js_file_list << line
			end
		end
	end
	hash_file = {
		"js" => js_file_list,
		"non_js" => non_js_file_list
	}
	hash_file
end

def parse_file_list(log_path)
	tem_js_list = []
	tem_non_js_list = []
	
	hash_file = get_file_list(log_path)
	js_file_list = hash_file["js"]
	non_js_file_list = hash_file["non_js"]
	
	js_file_list.each do |js|
		if js.start_with?('A') || js.start_with?('U')
			js = js.sub(/[AU]/, '').gsub('\\', '/').strip
			tem_js_list << js
		end
	end
	
	non_js_file_list.each do |non_js|
		if non_js.start_with?('A') || non_js.start_with?('U')
		  non_js = non_js.sub(/[AU]/, '').gsub('\\', '/').strip
			tem_non_js_list << non_js
		end
	end
	
	tem_hash_file = {
		"js" => tem_js_list.uniq,
		"non_js" => tem_non_js_list.uniq
	}
	tem_hash_file
end

def compress_js_file(log_path, web_root_path, compress_path)
	hash_file = parse_file_list(log_path)
	js_file_list = hash_file["js"]
	non_js_file_list = hash_file["non_js"]
	
	if !non_js_file_list.empty?
		non_js_file_list.each do |non_js|
			next if File.directory?(non_js)
			tem_file_path = non_js.sub(web_root_path, compress_path)
			dir_validate(tem_file_path)
			FileUtils.cp(non_js, tem_file_path)
		end
	else
		puts "\n no non_js file to copy"
	end
	
	if !js_file_list.empty?
		js_file_list.each do |js_file|
			compress_file_path = js_file.sub(web_root_path, compress_path)
			dir_validate(compress_file_path)
			`uglifyjs #{js_file} -o #{compress_file_path} -c`
		end
	else
		puts "\n no js file to compress"
	end
end
