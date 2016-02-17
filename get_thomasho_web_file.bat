svn revert D:\htdocs
svn update D:\htdocs > D:\THC\get_web\log\thomasho_update.log
sort < D:\THC\get_web\log\thomasho_update.log >> D:\THC\get_web\log\thomasho_changelist.log
ruby D:\THC\get_web\lib\get_thomasho_web_file.rb