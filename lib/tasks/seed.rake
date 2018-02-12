namespace :db do
  desc 'Initialize necesary roles for app'
  task seed: :environment do
    print "\e[0;36m Insertando roles necesarios para la aplicacion.......\e[0m"
    admin = Role.find_or_create_by!(name: 'admin')
    sucursal = Role.find_or_create_by!(name: 'sucursal')

    if admin.nil? || sucursal.nil?
      print "\e[0;31m [ERROR]...Admin nil? #{admin.nil?}...Sucursal nil?..#{sucursal.nil?}....\e[0m"
    else
      print "\e[0;32m [OK]\e[0m\n"
    end
  end
end
