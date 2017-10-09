Заготовка приложения для InSales
================================

* [Интерфейс для API](https://github.com/insales/insales_api)
* Установка
* Удаление
* Прозрачный логин из InSales

Разработка
----------------------

Для быстрой развёртки приложения нужно установить [docker](https://www.docker.com/community-edition) и [docker-compose](https://docs.docker.com/compose/install/).

* `git clone git@github.com:insales/insales_app.git`
* `cd insales_app`
* `docker-compose up --build`

После этого приложение будет доступно по адресу http://localhost:3000, проверить его статус и увидеть логи запуска можно по адресу http://localhost:9001.

### Самостоятельный запуск приложения
* Остановить rails-приложение на http://localhost:9001
* `cd insales_app`
* `docker-compose exec app sudo -u rails -i`
* `cd webapp`
* `bundle exec rails server -b 0.0.0.0`

Добавление приложения на стороне InSales
-----------------------------------------

Все настройки на стороне вашего приложения прописываются в
config/initializers/insales_api.rb

Для того чтобы приложение стало доступным для тестовой
в вашем аккаунте в InSales надо:

* Заходим в раздел "Приложения" => "Разработчикам" => "Добавить приложение"
* Заполняем форму:
  * Идентификатор:    MyApp.api_key
  * URL установки:    http://#{host}/install
  * URL входа:        http://#{host}/main
  * URL деинсталляции: http://#{host}/uninstall
* Создаем приложение, заходим в его карточку и значение из поля "Секрет" копируем и прописываем в MyApp.api_secret
