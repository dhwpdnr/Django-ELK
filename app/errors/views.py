from rest_framework.generics import GenericAPIView
from rest_framework.response import Response
from rest_framework.exceptions import NotFound, PermissionDenied, ValidationError, ParseError, APIException
from rest_framework import status


class ClientErrorAPI(GenericAPIView):
    def get(self, request, *args, **kwargs):
        error_type = request.query_params.get('error_type')

        if error_type == 'not_found':
            raise NotFound(detail="요청한 리소스를 찾을 수 없습니다.")

        elif error_type == 'permission_denied':
            raise PermissionDenied(detail="권한이 없습니다.")

        elif error_type == 'validation_error':
            raise ValidationError(detail={"message": "잘못된 입력값입니다.", "field": "example_field"})

        elif error_type == 'parse_error':
            raise ParseError(detail="요청 데이터를 파싱할 수 없습니다.")

        return Response(
            {
                "message": "error_type을 지정해 주세요.",
                "error_type": [
                    "not_found",
                    "permission_denied",
                    "validation_error",
                    "parse_error",
                ]
            },
            status=status.HTTP_200_OK
        )


class ServerErrorAPI(GenericAPIView):
    def get(self, request, *args, **kwargs):
        error_type = request.query_params.get('error_type')

        if error_type == 'internal_server_error':
            raise APIException(detail="500 Internal Server Error 발생!")

        elif error_type == 'database_error':
            # 강제적으로 DB 에러 발생시키기
            from django.db import connection
            with connection.cursor() as cursor:
                cursor.execute("INVALID SQL QUERY")  # 잘못된 SQL 문 실행

        elif error_type == 'zero_division':
            result = 1 / 0  # ZeroDivisionError 발생

        elif error_type == 'recursion_error':
            def recursive_func():
                return recursive_func()  # 무한 재귀 호출

            recursive_func()

        return Response(
            {
                "message": "error_type을 지정해 주세요.",
                "error_type": [
                    "internal_server_error",
                    "database_error",
                    "zero_division",
                    "recursion_error",
                ]
            },
            status=status.HTTP_200_OK
        )
