import threading

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
