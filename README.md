# Django-ELK 프로젝트

**Django-ELK**는 **Django 애플리케이션의 로그 및 성능 데이터를 ELK (Elasticsearch, Logstash, Kibana)와 APM (Application Performance
Monitoring)으로 수집, 분석 및 시각화하는 프로젝트**입니다.

## 1. 주요 기능

- **Django 로그 수집** → Logstash를 통해 Elasticsearch에 저장
- **APM 서버 연동** → 애플리케이션 성능 모니터링 (트랜잭션, 오류, 메트릭)
- **Kibana 대시보드 제공** → 실시간 로그 조회 및 분석

---

## 2. 구성 요소 (ELK 스택 + APM)

| 서비스               | 설명                      |
|-------------------|-------------------------|
| **Django**        | Python 웹 프레임워크 (애플리케이션) |
| **Postgresql**    | Postgresql 데이터 베이스      |
| **Elasticsearch** | 로그 및 APM 데이터 저장소        |
| **Logstash**      | 로그 수집 및 변환              |
| **Kibana**        | 시각화 및 대시보드 제공           |
| **APM Server**    | 애플리케이션 성능 데이터 수집        |

---

## 3. 프로젝트 구조

```plaintext
django-elk/
├── app/  # Django 애플리케이션
│   ├── config/ # Django 설정 파일
│   ├── core/   # 애플리케이션 로직
│   ├── logs/   # 로그 파일
│   └── manage.py
├── docker-compose.django.yml  # Django 어플리케이션 Docker Compose 설정 파일
├── docker-compose.elk.yml     # ELK 스택 Docker Compose 설정 파일
├── apm-server.yml         # APM Server 설정 파일
├── logstash.conf          # Logstash 설정 파일
├── Dockerfile             # Django 어플리케이션 Dockerfile
├── requirements.txt       # Python 패키지 목록
├── .env                   # 환경 변수 파일
└── README.md
```

---

## 4. 환경 변수 설정 (.env)

환경 변수 파일 `.env`를 생성하고 아래 내용을 추가하세요.

```plaintext
SECRET_KEY=your_secret_key  # Django secret
DEBUG=True
ELASTIC_PASSWORD=enter_your_password    # Elasticsearch 비밀번호
KIBANA_PASSWORD=enter_your_password     # Kibana 비밀번호
LOGSTASH_PASSWORD=enter_your_password   # Logstash 비밀번호
APM_SERVER_PASSWORD=enter_your_password # APM Server 비밀번호
APM_SECRET_TOKEN=your_apm_secret_token  # APM Secret Token
APM_KIBANA_HOST=http://kibana:5601
APM_ELASTICSEARCH_HOST=http://elasticsearch:9200
```

---

## 5. 프로젝트 실행

1. **Django 어플리케이션 실행**

```bash
# Linux / macOS
make all up # Docker Compose 실행

# Windows
docker-compose -f docker-compose.django.yml up -d
docker-compose -f docker-compose.elk.yml up -d
```
