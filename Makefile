# Docker 네트워크 생성 (최초 1회 실행 필요)
setup-network:
	docker network create django-elk-network || true

# Django 컨테이너 관리
up: setup-network
	docker-compose -f docker-compose.django.yml up -d

down:
	docker-compose -f docker-compose.django.yml down

build:
	docker-compose -f docker-compose.django.yml up --build -d

logs:
	docker-compose -f docker-compose.django.yml logs -f app

# Django 관리 명령어
makemigrations:
	docker-compose -f docker-compose.django.yml run --rm app sh -c "python manage.py makemigrations"

migrate:
	docker-compose -f docker-compose.django.yml run --rm app sh -c "python manage.py wait_for_db && python manage.py migrate"

test:
	docker-compose -f docker-compose.django.yml run --rm app sh -c "python manage.py test"

shell:
	docker-compose -f docker-compose.django.yml run --rm app sh -c "python manage.py shell"

superuser:
	docker-compose -f docker-compose.django.yml run --rm app sh -c "python manage.py createsuperuser"

runserver:
	docker-compose -f docker-compose.django.yml run --rm app sh -c "python manage.py runserver 0.0.0.0:8000"

setup:
	docker-compose -f docker-compose.django.yml run --rm app sh -c "python manage.py setup"

startapp:
	docker-compose -f docker-compose.django.yml run --rm app sh -c "python manage.py startapp $(filter-out $@,$(MAKECMDGOALS))"

testapp:
	docker-compose -f docker-compose.django.yml run --rm app sh -c "python manage.py test $(filter-out $@,$(MAKECMDGOALS))"

run:
	docker-compose -f docker-compose.django.yml run --rm app sh -c "python manage.py $(filter-out $@,$(MAKECMDGOALS))"

# ELK 컨테이너 관리
elk-up: setup-network
	docker-compose -f docker-compose.elk.yml up -d

elk-down:
	docker-compose -f docker-compose.elk.yml down

elk-restart:
	docker-compose -f docker-compose.elk.yml down && docker-compose -f docker-compose.elk.yml up -d

elk-logs:
	docker-compose -f docker-compose.elk.yml logs -f

# 전체 컨테이너 관리 (Django + ELK)
all-up: setup-network
	docker-compose -f docker-compose.django.yml up -d && docker-compose -f docker-compose.elk.yml up -d

all-down:
	docker-compose -f docker-compose.django.yml down && docker-compose -f docker-compose.elk.yml down

all-restart:
	docker-compose -f docker-compose.django.yml down && docker-compose -f docker-compose.elk.yml down && \
	docker-compose -f docker-compose.django.yml up -d && docker-compose -f docker-compose.elk.yml up -d

# 해당 목표가 실제로 존재하지 않음을 Make에 알려주는 더미 규칙
%:
	@: