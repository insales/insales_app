Заготовка приложения для InSales
================================

* [Интерфейс для API](https://github.com/insales/insales_api)
* Установка
* Удаление
* Прозрачный заход из InSales

Разворачинивае сервера
----------------------

* git clone git@github.com:insales/insales_app.git
* cd insales_app
* bundle install
* cp config/database.yml.example config/database.yml
* bundle exec rake db:migrate
* cp config/initializers/insales_api.rb.example config/initializers/insales_api.rb
* bundle exec rails s


Добавлегие приложениея на стороне InSales
-----------------------------------------

Все настройки на стороне вашего приложения прописываются в
config/initializers/insales_api.rb

Для того чтобы приложение стало доступным для тестовой
в вашем аккаунте в InSales надо:

* Заходим в раздле "Приложения" => "Разработчикам" => "Добавить приложение"
* Заполянем форму:
  Идентификатор:    MyApp.api_key
  URL установки:    http://#{MyApp.api_host}/install
  URL входа:        http://#{MyApp.api_host}/uninstall
  URL деинсталяции: http://#{MyApp.api_host}/main
* Создаем приложение, заходим в его карточку и занчение из поля "Секрет" копируем и прописываем в MyApp.api_secret

