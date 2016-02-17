require File.join(File.dirname(__FILE__), 'parse_log.rb')

log_path = 'D:/THC/get_web/log/thomasho_changelist.log'
compress_path = 'D:/THC/get_web/w0702_for_thomasho'
web_root_path = 'D:/htdocs'
delete_dir(compress_path)
compress_js_file(log_path, web_root_path, compress_path)
