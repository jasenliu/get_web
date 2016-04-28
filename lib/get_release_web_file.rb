require File.join(File.dirname(__FILE__), 'parse_log.rb')

log_path = 'D:/THC/get_web/log/changelist.log'
compress_path = 'D:/THC/get_web/w0702_for_13'
web_root_path = 'D:/w0702'
delete_dir(compress_path)
compress_js_file(log_path, web_root_path, compress_path)
