#!/bin/bash

echo "Elasticsearch 초기 설정을 시작합니다..."

# Elasticsearch가 정상적으로 실행될 때까지 대기
until curl -s -u "elastic:${ELASTIC_PASSWORD}" "http://elasticsearch:9200/_cluster/health" | grep -q '"status":"yellow"\|"status":"green"'; do
  echo "$(date) Elasticsearch가 아직 준비되지 않았습니다. 다시 확인 중..."
  sleep 5 # 5초 대기 후 다시 체크
done

echo "Elasticsearch가 정상적으로 실행되었습니다!"

# Logstash 유저 생성
echo "Logstash 사용자 생성..."
curl -X POST "http://elasticsearch:9200/_security/user/logstash_user" \
  -u "elastic:${ELASTIC_PASSWORD}" \
  -H "Content-Type: application/json" \
  -d "{
    \"password\": \"${LOGSTASH_PASSWORD}\",
    \"roles\": [\"logstash_writer\"],
    \"full_name\": \"Logstash User\",
    \"email\": \"logstash@example.com\"
  }"
echo ""

# Logstash writer Role 생성
echo "Logstash writer Role 생성..."
curl -X POST "http://elasticsearch:9200/_security/role/logstash_writer" \
  -u "elastic:${ELASTIC_PASSWORD}" \
  -H "Content-Type: application/json" \
  -d '{
    "cluster": ["monitor", "manage_index_templates"],
    "indices": [
      {
        "names": ["logstash-*", "django-logs-*"],
        "privileges": ["write", "create", "create_index", "manage", "auto_configure"]
      }
    ]
  }'
echo ""

# Kibana System 계정 비밀번호 변경
echo "Kibana System 계정 비밀번호 변경..."
curl -X POST "http://elasticsearch:9200/_security/user/kibana_system/_password" \
  -u "elastic:${ELASTIC_PASSWORD}" \
  -H "Content-Type: application/json" \
  -d "{
    \"password\": \"${KIBANA_PASSWORD}\"
  }"
echo ""

# APM 관련 Role 및 유저 생성
echo "APM Role 생성..."
curl -X POST "http://elasticsearch:9200/_security/role/custom_apm_role" \
  -u "elastic:${ELASTIC_PASSWORD}" \
  -H "Content-Type: application/json" \
  -d '{
    "cluster": [
      "monitor",
      "read_pipeline",
      "manage_ingest_pipelines",
      "manage_index_templates",
      "manage"
    ],
    "indices": [
      {
        "names": ["apm-*"],
        "privileges": ["write", "create", "create_index", "manage"]
      }
    ]
  }'
echo ""

echo "Kibana APM Access Role 생성..."
curl -X POST "http://elasticsearch:9200/_security/role/kibana_apm_access" \
  -u "elastic:${ELASTIC_PASSWORD}" \
  -H "Content-Type: application/json" \
  -d '{
    "cluster": ["monitor"],
    "indices": [
      { "names": [".kibana*"], "privileges": ["read", "view_index_metadata"] },
      { "names": ["apm-*"], "privileges": ["read", "view_index_metadata"] }
    ],
    "applications": [
      {
        "application": "kibana-.kibana",
        "privileges": ["read"],
        "resources": ["apm"]
      }
    ]
  }'
echo ""

echo "APM Server 계정 생성..."
curl -X POST "http://elasticsearch:9200/_security/user/apm_server_user" \
  -u "elastic:${ELASTIC_PASSWORD}" \
  -H "Content-Type: application/json" \
  -d "{
    \"password\": \"${APM_SERVER_PASSWORD}\",
    \"roles\": [\"custom_apm_role\", \"kibana_apm_access\", \"apm_system\"],
    \"full_name\": \"APM Server User\",
    \"email\": \"apm@example.com\",
    \"enabled\": true
  }"
echo ""

echo "모든 설정이 완료되었습니다!"
