import threading
import elasticapm
from django.urls import resolve
from django.utils.deprecation import MiddlewareMixin

_thread_locals = threading.local()


def get_current_request():
    """현재 요청 객체를 반환"""
    return getattr(_thread_locals, "request", None)


def get_current_response():
    """현재 응답 객체를 반환"""
    return getattr(_thread_locals, "response", None)


class ThreadLocalRequestMiddleware:
    """각 요청을 스레드 로컬 저장소에 저장하는 미들웨어"""

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        _thread_locals.request = request  # 요청 저장
        response = self.get_response(request)
        _thread_locals.response = response  # 응답 저장
        return response


class CustomAPMTransactionMiddleware(MiddlewareMixin):
    def process_request(self, request):
        client = elasticapm.get_client()
        if client:
            transaction = client.begin_transaction("request")
            request.apm_transaction = transaction  # 요청 객체에 트랜잭션 저장

        resolver_match = resolve(request.path_info)

        if resolver_match:
            url_pattern = resolver_match.route  # URL 패턴 가져오기

            # URL 패턴의 동적 파라미터를 템플릿 형식으로 변환
            for param in resolver_match.kwargs.keys():
                url_pattern = url_pattern.replace(f"(?P<{param}>[^/.]+)", f"<{param}>")

            # URL 패턴의 마지막 슬래시 제거
            url_pattern = url_pattern.replace("/$", "")

            elasticapm.set_transaction_name(f"{request.method} {url_pattern}")

    def process_response(self, request, response):
        client = elasticapm.get_client()
        transaction = getattr(request, "apm_transaction", None)

        if client and transaction:
            transaction.result = f"HTTP {response.status_code}"
            client.end_transaction(transaction.name, transaction.result)

        return response
