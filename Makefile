up:
	docker-compose up

down:
	docker-compose down

build:
	docker-compose up --build

makemigrations:
	docker-compose run --rm app sh -c "python manage.py makemigrations"

migrate:
	docker-compose run --rm app sh -c "python manage.py wait_for_db && python manage.py migrate"

test:
	docker-compose run --rm app sh -c "python manage.py test"

shell:
	docker-compose run --rm app sh -c "python manage.py shell"

superuser:
	docker-compose run --rm app sh -c "python manage.py createsuperuser"

runserver:
	docker-compose run --rm app sh -c "python manage.py runserver"

setup:
	docker-compose run --rm app sh -c "python manage.py setup"

startapp:
	docker-compose run --rm app sh -c "python manage.py startapp $(filter-out $@,$(MAKECMDGOALS))"

testapp:
	docker-compose run --rm app sh -c "python manage.py test $(filter-out $@,$(MAKECMDGOALS))"

run:
	docker-compose run --rm app sh -c "python manage.py $(filter-out $@,$(MAKECMDGOALS))"

# 해당 목표가 실제로 존재하지 않음을 Make에 알려주는 더미 규칙
%:
	@: